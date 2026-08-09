import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { createHash, randomBytes } from 'crypto';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto, SignUpDto } from './dto/auth.dto';
import { OtpService } from './otp.service';

export type AuthResultDto = {
  userId: string;
  accessToken: string;
  refreshToken: string;
  isProfileComplete: boolean;
  isNewUser: boolean;
  role: string;
};

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
    private readonly otp: OtpService,
  ) {}

  async sendOtp(phone: string): Promise<{ ok: true; provider: string }> {
    return this.otp.send(phone);
  }

  async verifyOtp(phone: string, code: string): Promise<AuthResultDto> {
    const valid = await this.otp.verify(phone, code);
    if (!valid) {
      throw new UnauthorizedException('invalid_or_expired_code');
    }

    let user = await this.prisma.user.findUnique({ where: { phone } });
    let isNewUser = false;
    if (!user) {
      user = await this.prisma.user.create({
        data: { phone, isProfileComplete: false, role: 'user' },
      });
      isNewUser = true;
    }

    return this.issueTokens(user, isNewUser);
  }

  async login(dto: LoginDto): Promise<AuthResultDto> {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email.toLowerCase() },
    });
    if (!user?.passwordHash) {
      throw new UnauthorizedException('invalid_credentials');
    }
    const ok = await bcrypt.compare(dto.password, user.passwordHash);
    if (!ok) {
      throw new UnauthorizedException('invalid_credentials');
    }
    return this.issueTokens(user, false);
  }

  async signUp(dto: SignUpDto): Promise<AuthResultDto> {
    const email = dto.email.toLowerCase();
    const existing = await this.prisma.user.findFirst({
      where: { OR: [{ email }, { phone: dto.phone }] },
    });
    if (existing) {
      throw new ConflictException('user_already_exists');
    }

    const passwordHash = await bcrypt.hash(dto.password, 10);
    const user = await this.prisma.user.create({
      data: {
        name: dto.name,
        email,
        phone: dto.phone,
        passwordHash,
        isProfileComplete: false,
        role: 'user',
      },
    });

    return this.issueTokens(user, true);
  }

  async refresh(refreshToken: string): Promise<AuthResultDto> {
    const hash = this.hashToken(refreshToken);
    const stored = await this.prisma.refreshToken.findUnique({
      where: { token: hash },
      include: { user: true },
    });
    if (!stored || stored.expiresAt < new Date()) {
      throw new UnauthorizedException('invalid_refresh_token');
    }

    await this.prisma.refreshToken.delete({ where: { id: stored.id } });
    return this.issueTokens(stored.user, false);
  }

  async logout(refreshToken?: string): Promise<{ ok: true }> {
    if (refreshToken) {
      const hash = this.hashToken(refreshToken);
      await this.prisma.refreshToken.deleteMany({ where: { token: hash } });
    }
    return { ok: true };
  }

  private async issueTokens(
    user: {
      id: string;
      isProfileComplete: boolean;
      role: string;
    },
    isNewUser: boolean,
  ): Promise<AuthResultDto> {
    const accessTtl = this.config.get<string>('JWT_ACCESS_TTL') ?? '15m';
    const refreshTtl = this.config.get<string>('JWT_REFRESH_TTL') ?? '30d';

    const accessToken = await this.jwt.signAsync(
      { sub: user.id, role: user.role },
      {
        secret: this.config.getOrThrow<string>('JWT_ACCESS_SECRET'),
        expiresIn: accessTtl as `${number}${'s' | 'm' | 'h' | 'd'}`,
      },
    );

    const refreshToken = randomBytes(48).toString('hex');
    const expiresAt = new Date(
      Date.now() + this.parseDurationMs(refreshTtl, 30 * 24 * 60 * 60 * 1000),
    );

    await this.prisma.refreshToken.create({
      data: {
        token: this.hashToken(refreshToken),
        userId: user.id,
        expiresAt,
      },
    });

    return {
      userId: user.id,
      accessToken,
      refreshToken,
      isProfileComplete: user.isProfileComplete,
      isNewUser,
      role: user.role,
    };
  }

  private hashToken(token: string): string {
    return createHash('sha256').update(token).digest('hex');
  }

  private parseDurationMs(value: string, fallback: number): number {
    const match = /^(\d+)([smhd])$/.exec(value.trim());
    if (!match) return fallback;
    const n = Number(match[1]);
    const unit = match[2];
    const mult =
      unit === 's' ? 1000 : unit === 'm' ? 60_000 : unit === 'h' ? 3_600_000 : 86_400_000;
    return n * mult;
  }
}
