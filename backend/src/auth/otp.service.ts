import {
  HttpException,
  HttpStatus,
  Injectable,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createHash, randomInt } from 'crypto';
import { PrismaService } from '../prisma/prisma.service';
import { DevOtpProvider } from './otp/dev-otp.provider';
import { OtpSmsProvider } from './otp/otp-provider';
import { TwilioOtpProvider } from './otp/twilio-otp.provider';
import { UnifonicOtpProvider } from './otp/unifonic-otp.provider';

/**
 * OTP orchestration.
 * Providers: `dev` | `unifonic` | `twilio`
 *
 * Codes are stored as SHA-256 hashes (column `code`).
 * - `dev`: logs SMS; accepts any 6-digit code unless OTP_STRICT=true
 * - production providers: verify against stored hash only
 */
@Injectable()
export class OtpService {
  private readonly logger = new Logger(OtpService.name);
  private readonly provider: OtpSmsProvider;

  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
  ) {
    this.provider = this.buildProvider();
    this.logger.log(`OTP provider: ${this.provider.name}`);
  }

  async send(phone: string): Promise<{ ok: true; provider: string }> {
    await this.enforceRateLimit(phone);

    const code = this.generateCode();
    const codeHash = this.hashCode(code);
    const ttl = Number(this.config.get('OTP_TTL_MINUTES') ?? 10);
    const expiresAt = new Date(Date.now() + ttl * 60_000);

    await this.prisma.otpCode.create({
      data: { phone, code: codeHash, expiresAt },
    });

    const message =
      this.config.get<string>('OTP_MESSAGE_TEMPLATE')?.replace('{code}', code) ??
      `رمز كيان: ${code}\nKAYAN code: ${code}`;

    try {
      await this.provider.sendSms(phone, message);
    } catch (err) {
      this.logger.error(`SMS send failed via ${this.provider.name}`, err);
      throw new HttpException(
        {
          statusCode: HttpStatus.BAD_GATEWAY,
          message: 'otp_send_failed',
          provider: this.provider.name,
        },
        HttpStatus.BAD_GATEWAY,
      );
    }

    return { ok: true, provider: this.provider.name };
  }

  async verify(phone: string, code: string): Promise<boolean> {
    const providerName = this.provider.name;
    const strict =
      (this.config.get<string>('OTP_STRICT') ??
        (providerName === 'dev' ? 'false' : 'true')) === 'true';

    if (
      !strict &&
      providerName === 'dev' &&
      /^\d{6}$/.test(code) &&
      code !== '000000'
    ) {
      return true;
    }

    const codeHash = this.hashCode(code);
    const record = await this.prisma.otpCode.findFirst({
      where: {
        phone,
        code: codeHash,
        consumed: false,
        expiresAt: { gt: new Date() },
      },
      orderBy: { createdAt: 'desc' },
    });

    if (!record) return false;

    await this.prisma.otpCode.update({
      where: { id: record.id },
      data: { consumed: true },
    });
    return true;
  }

  private hashCode(code: string): string {
    return createHash('sha256').update(code).digest('hex');
  }

  private async enforceRateLimit(phone: string): Promise<void> {
    const maxPerHour = Number(this.config.get('OTP_MAX_PER_HOUR') ?? 5);
    const since = new Date(Date.now() - 60 * 60_000);
    const count = await this.prisma.otpCode.count({
      where: { phone, createdAt: { gte: since } },
    });
    if (count >= maxPerHour) {
      throw new HttpException(
        { statusCode: HttpStatus.TOO_MANY_REQUESTS, message: 'otp_rate_limited' },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const cooldownSec = Number(this.config.get('OTP_COOLDOWN_SECONDS') ?? 30);
    const latest = await this.prisma.otpCode.findFirst({
      where: { phone },
      orderBy: { createdAt: 'desc' },
    });
    if (
      latest &&
      Date.now() - latest.createdAt.getTime() < cooldownSec * 1000
    ) {
      throw new HttpException(
        { statusCode: HttpStatus.TOO_MANY_REQUESTS, message: 'otp_cooldown' },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }
  }

  private buildProvider(): OtpSmsProvider {
    const name = (this.config.get<string>('OTP_PROVIDER') ?? 'dev').toLowerCase();
    switch (name) {
      case 'unifonic':
        return new UnifonicOtpProvider(
          this.config.get<string>('UNIFONIC_APP_SID') ?? '',
          this.config.get<string>('UNIFONIC_SENDER_ID') ?? 'KAYAN',
          this.config.get<string>('UNIFONIC_BASE_URL') ??
            'https://el.cloud.unifonic.com',
        );
      case 'twilio':
        return new TwilioOtpProvider(
          this.config.get<string>('TWILIO_ACCOUNT_SID') ?? '',
          this.config.get<string>('TWILIO_AUTH_TOKEN') ?? '',
          this.config.get<string>('TWILIO_FROM_NUMBER') ?? '',
        );
      case 'dev':
      default:
        return new DevOtpProvider();
    }
  }

  private generateCode(): string {
    return String(randomInt(100000, 1000000));
  }
}
