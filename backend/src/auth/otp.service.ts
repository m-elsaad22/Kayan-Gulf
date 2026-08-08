import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';

/**
 * OTP provider abstraction.
 * Phase 1: `dev` (logs code; accepts any 6 digits unless OTP_STRICT=true).
 * Phase 3: wire Unifonic / Twilio via OTP_PROVIDER.
 */
@Injectable()
export class OtpService {
  private readonly logger = new Logger(OtpService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
  ) {}

  async send(phone: string): Promise<void> {
    const code = this.generateCode();
    const ttl = Number(this.config.get('OTP_TTL_MINUTES') ?? 10);
    const expiresAt = new Date(Date.now() + ttl * 60_000);

    await this.prisma.otpCode.create({
      data: { phone, code, expiresAt },
    });

    const provider = this.config.get<string>('OTP_PROVIDER') ?? 'dev';
    if (provider === 'dev') {
      this.logger.log(`[dev OTP] phone=${phone} code=${code}`);
      return;
    }

    // Placeholders for Phase 3 — keep interface stable.
    if (provider === 'unifonic') {
      this.logger.warn(
        'OTP_PROVIDER=unifonic configured but SMS send not implemented yet; code stored only.',
      );
      return;
    }
    if (provider === 'twilio') {
      this.logger.warn(
        'OTP_PROVIDER=twilio configured but SMS send not implemented yet; code stored only.',
      );
      return;
    }

    throw new Error(`Unsupported OTP_PROVIDER: ${provider}`);
  }

  async verify(phone: string, code: string): Promise<boolean> {
    const strict = (this.config.get<string>('OTP_STRICT') ?? 'false') === 'true';
    const provider = this.config.get<string>('OTP_PROVIDER') ?? 'dev';

    if (!strict && provider === 'dev' && /^\d{6}$/.test(code) && code !== '000000') {
      return true;
    }

    const record = await this.prisma.otpCode.findFirst({
      where: {
        phone,
        code,
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

  private generateCode(): string {
    return String(Math.floor(100000 + Math.random() * 900000));
  }
}
