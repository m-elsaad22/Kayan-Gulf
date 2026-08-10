import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createHmac, timingSafeEqual } from 'crypto';
import { OrdersService } from '../orders/orders.service';
import { PrismaService } from '../prisma/prisma.service';

/**
 * Payment gateway adapter.
 *
 * PAYMENT_PROVIDER=mock|tap|hyperpay|paymob
 * - mock / COD: local success (no PSP)
 * - tap: real Charge create when TAP_SECRET_KEY is set
 * - hyperpay / paymob: require keys; otherwise reject (no fake paid redirect in prod)
 *
 * Webhooks require HMAC header `x-kayan-signature` = hex(hmac_sha256(rawBody, PAYMENT_WEBHOOK_SECRET))
 * Client confirm is disabled unless PAYMENT_ALLOW_CLIENT_CONFIRM=true (dev only).
 */
@Injectable()
export class PaymentsService {
  private readonly logger = new Logger(PaymentsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly orders: OrdersService,
    private readonly config: ConfigService,
  ) {}

  async createIntent(
    userId: string,
    body: { orderId: string; paymentMethod: string },
  ) {
    const order = await this.prisma.order.findFirst({
      where: { id: body.orderId, userId },
    });
    if (!order) throw new NotFoundException('order_not_found');
    if (order.status === 'paid' || order.status === 'delivered') {
      throw new BadRequestException('order_already_paid');
    }

    const provider = this.resolveProvider(body.paymentMethod);
    const providerRef = `${provider}_${Date.now()}`;

    if (body.paymentMethod === 'cod' || provider === 'mock') {
      const payment = await this.prisma.payment.create({
        data: {
          userId,
          orderId: order.id,
          provider,
          method: body.paymentMethod,
          status: body.paymentMethod === 'cod' ? 'pending' : 'paid',
          amount: order.total,
          currency: order.currency,
          providerRef,
        },
      });

      if (body.paymentMethod !== 'cod') {
        await this.orders.markPaid(order.id);
      }

      return {
        orderId: order.id,
        paymentId: payment.id,
        status: body.paymentMethod === 'cod' ? 'pending' : 'success',
        provider,
        providerRef,
        redirectUrl: null,
      };
    }

    if (provider === 'tap') {
      return this.createTapIntent(userId, order, body.paymentMethod, providerRef);
    }

    // hyperpay / paymob: refuse fake checkouts — keys alone are not enough yet.
    if (provider === 'hyperpay' || provider === 'paymob') {
      throw new BadRequestException({
        message: 'payment_provider_not_implemented',
        provider,
        detail:
          'HyperPay/Paymob adapters are not production-wired. Use PAYMENT_PROVIDER=mock|tap or COD.',
      });
    }

    throw new BadRequestException(`unsupported_payment_provider:${provider}`);
  }

  /**
   * Client-side confirm — only for mock/dev when explicitly allowed.
   * Real card payments must complete via signed webhook.
   */
  async confirm(
    userId: string,
    body: { orderId: string; providerRef: string },
  ) {
    const allow =
      (this.config.get<string>('PAYMENT_ALLOW_CLIENT_CONFIRM') ?? 'false') ===
      'true';
    if (!allow) {
      throw new BadRequestException(
        'client_confirm_disabled_use_webhook_or_cod',
      );
    }

    const payment = await this.prisma.payment.findFirst({
      where: {
        orderId: body.orderId,
        userId,
        providerRef: body.providerRef,
      },
    });
    if (!payment) throw new NotFoundException('payment_not_found');
    if (payment.provider !== 'mock' && payment.provider !== 'cod') {
      throw new BadRequestException('client_confirm_only_for_mock');
    }

    await this.prisma.payment.update({
      where: { id: payment.id },
      data: { status: 'paid' },
    });
    await this.orders.markPaid(body.orderId);

    return {
      orderId: body.orderId,
      status: 'success',
      providerRef: body.providerRef,
    };
  }

  async webhook(
    body: {
      orderId?: string;
      providerRef?: string;
      status?: string;
    },
    signatureHeader?: string,
  ) {
    const secret = this.config.get<string>('PAYMENT_WEBHOOK_SECRET') ?? '';
    if (!secret || secret.length < 16) {
      throw new UnauthorizedException('webhook_secret_not_configured');
    }
    if (!signatureHeader) {
      throw new UnauthorizedException('missing_signature');
    }

    const payload = JSON.stringify({
      orderId: body.orderId ?? null,
      providerRef: body.providerRef ?? null,
      status: body.status ?? null,
    });
    const expected = createHmac('sha256', secret).update(payload).digest('hex');
    const provided = signatureHeader.replace(/^sha256=/i, '').trim();
    const a = Buffer.from(expected, 'utf8');
    const b = Buffer.from(provided, 'utf8');
    if (a.length !== b.length || !timingSafeEqual(a, b)) {
      throw new UnauthorizedException('invalid_signature');
    }

    if (!body.orderId || !body.providerRef) {
      throw new BadRequestException('invalid_webhook');
    }
    const payment = await this.prisma.payment.findFirst({
      where: { orderId: body.orderId, providerRef: body.providerRef },
    });
    if (!payment) throw new NotFoundException('payment_not_found');

    const paid = (body.status ?? 'paid').toLowerCase() === 'paid';
    await this.prisma.payment.update({
      where: { id: payment.id },
      data: {
        status: paid ? 'paid' : 'failed',
        rawJson: JSON.stringify(body),
      },
    });
    if (paid) {
      await this.orders.markPaid(body.orderId);
    }
    return { ok: true };
  }

  private async createTapIntent(
    userId: string,
    order: { id: string; total: number; currency: string },
    method: string,
    providerRef: string,
  ) {
    const secret = this.config.get<string>('TAP_SECRET_KEY') ?? '';
    if (!secret) {
      throw new BadRequestException('tap_secret_key_missing');
    }

    const redirectBase =
      this.config.get<string>('PAYMENT_REDIRECT_BASE') ??
      'https://pay.example.com/checkout';
    const redirectUrl = `${redirectBase}?orderId=${order.id}&ref=${providerRef}`;

    const amount = Number(order.total.toFixed(2));
    const res = await fetch('https://api.tap.company/v2/charges', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${secret}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        amount,
        currency: order.currency || 'SAR',
        threeDSecure: true,
        save_card: false,
        description: `KAYAN order ${order.id}`,
        reference: { transaction: providerRef, order: order.id },
        redirect: { url: redirectUrl },
        source: { id: 'src_all' },
        metadata: { orderId: order.id, providerRef },
      }),
    });

    const raw = await res.text();
    let json: Record<string, unknown> = {};
    try {
      json = JSON.parse(raw) as Record<string, unknown>;
    } catch {
      this.logger.error(`Tap non-JSON response: ${raw.slice(0, 200)}`);
    }

    if (!res.ok) {
      this.logger.error(`Tap charge failed status=${res.status} body=${raw}`);
      throw new BadRequestException({
        message: 'tap_charge_failed',
        status: res.status,
      });
    }

    const tapId = typeof json.id === 'string' ? json.id : providerRef;
    const transaction = json.transaction as { url?: string } | undefined;
    const tapRedirect =
      (typeof transaction?.url === 'string' && transaction.url) ||
      (typeof json.redirect === 'object' &&
        json.redirect &&
        typeof (json.redirect as { url?: string }).url === 'string' &&
        (json.redirect as { url: string }).url) ||
      redirectUrl;

    const payment = await this.prisma.payment.create({
      data: {
        userId,
        orderId: order.id,
        provider: 'tap',
        method,
        status: 'pending',
        amount: order.total,
        currency: order.currency,
        providerRef: tapId,
        redirectUrl: tapRedirect,
        rawJson: raw,
      },
    });

    return {
      orderId: order.id,
      paymentId: payment.id,
      status: 'pending',
      provider: 'tap',
      providerRef: tapId,
      redirectUrl: tapRedirect,
      clientSecret: null,
    };
  }

  private resolveProvider(method: string): string {
    if (method === 'cod') return 'cod';
    if (method === 'wallet') return 'wallet';
    if (method === 'tabby') return 'tabby';
    if (method === 'tamara') return 'tamara';
    if (method === 'applepay') return 'applepay';

    const configured =
      this.config.get<string>('PAYMENT_PROVIDER') ?? 'mock';
    return configured; // mock | tap | hyperpay | paymob
  }
}
