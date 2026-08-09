import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OrdersService } from '../orders/orders.service';
import { PrismaService } from '../prisma/prisma.service';

/**
 * Payment gateway adapter (Phase 2 stub).
 * PAYMENT_PROVIDER=mock|tap|hyperpay|paymob
 * - mock/cod: immediate success
 * - tap/hyperpay/paymob: returns redirectUrl placeholder until keys are set
 */
@Injectable()
export class PaymentsService {
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

    const base =
      this.config.get<string>('PAYMENT_REDIRECT_BASE') ??
      'https://pay.example.com/checkout';
    const redirectUrl = `${base}?orderId=${order.id}&ref=${providerRef}`;

    const payment = await this.prisma.payment.create({
      data: {
        userId,
        orderId: order.id,
        provider,
        method: body.paymentMethod,
        status: 'pending',
        amount: order.total,
        currency: order.currency,
        providerRef,
        redirectUrl,
      },
    });

    return {
      orderId: order.id,
      paymentId: payment.id,
      status: 'pending',
      provider,
      providerRef,
      redirectUrl,
      clientSecret: null,
    };
  }

  async confirm(
    userId: string,
    body: { orderId: string; providerRef: string },
  ) {
    const payment = await this.prisma.payment.findFirst({
      where: {
        orderId: body.orderId,
        userId,
        providerRef: body.providerRef,
      },
    });
    if (!payment) throw new NotFoundException('payment_not_found');

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

  /** Provider webhook stub — marks payment paid when signature/env allows. */
  async webhook(body: {
    orderId?: string;
    providerRef?: string;
    status?: string;
  }) {
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
