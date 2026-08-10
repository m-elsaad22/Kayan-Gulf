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
import { LoginDto, SignUpDto, GoogleLoginDto } from './dto/auth.dto';
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
        data: {
          phone,
          isProfileComplete: false,
          role: 'user',
          authProvider: 'phone',
          status: 'active',
        },
      });
      isNewUser = true;
    }
    this.assertUserActive(user);
    return this.issueTokens(user, isNewUser);
  }

  async login(dto: LoginDto): Promise<AuthResultDto> {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email.toLowerCase() },
    });
    if (!user?.passwordHash) {
      throw new UnauthorizedException('invalid_credentials');
    }
    this.assertUserActive(user);
    const ok = await bcrypt.compare(dto.password, user.passwordHash);
    if (!ok) {
      throw new UnauthorizedException('invalid_credentials');
    }
    return this.issueTokens(user, false);
  }

  /**
   * Real Google Sign-In: idToken is verified with Google tokeninfo.
   * Identity is derived only from the verified token (sub + email).
   * Client-supplied email/googleId are never trusted in production.
   */
  async loginWithGoogle(dto: GoogleLoginDto): Promise<AuthResultDto> {
    const isProd = (process.env.NODE_ENV ?? 'development') === 'production';

    if (!dto.idToken) {
      if (isProd) {
        throw new UnauthorizedException('google_id_token_required');
      }
      // Dev-only fallback (never used by production APK).
      const email = (dto.email ?? '').toLowerCase().trim();
      if (!email) {
        throw new UnauthorizedException('google_id_token_required');
      }
      return this.upsertGoogleUser({
        email,
        googleSub: dto.googleId?.trim() || `dev-${email}`,
        name: dto.name,
        avatarUrl: null,
      });
    }

    const info = await this.verifyGoogleIdToken(dto.idToken);
    if (!info.email || !info.sub) {
      throw new UnauthorizedException('invalid_google_token');
    }
    if (info.email_verified === false) {
      throw new UnauthorizedException('google_email_unverified');
    }

    return this.upsertGoogleUser({
      email: info.email.toLowerCase(),
      googleSub: info.sub,
      name: info.name ?? dto.name,
      avatarUrl: info.picture ?? null,
    });
  }

  private async upsertGoogleUser(input: {
    email: string;
    googleSub: string;
    name?: string | null;
    avatarUrl?: string | null;
  }): Promise<AuthResultDto> {
    let user = await this.prisma.user.findUnique({
      where: { googleSub: input.googleSub },
    });
    let isNewUser = false;

    if (!user) {
      const byEmail = await this.prisma.user.findUnique({
        where: { email: input.email },
      });
      if (byEmail) {
        // Secure linking: only attach Google when the account has no googleSub yet.
        if (byEmail.googleSub && byEmail.googleSub !== input.googleSub) {
          throw new UnauthorizedException('google_account_mismatch');
        }
        this.assertUserActive(byEmail);
        user = await this.prisma.user.update({
          where: { id: byEmail.id },
          data: {
            googleSub: input.googleSub,
            authProvider:
              byEmail.authProvider === 'password'
                ? 'password'
                : 'google',
            avatarUrl: byEmail.avatarUrl ?? input.avatarUrl,
            name: byEmail.name ?? input.name ?? undefined,
            isProfileComplete: true,
          },
        });
      } else {
        user = await this.prisma.user.create({
          data: {
            email: input.email,
            googleSub: input.googleSub,
            name: input.name ?? input.email.split('@')[0],
            avatarUrl: input.avatarUrl,
            authProvider: 'google',
            isProfileComplete: true,
            role: 'user',
            status: 'active',
            passwordHash: null,
          },
        });
        isNewUser = true;
      }
    } else {
      this.assertUserActive(user);
      if (user.email && user.email !== input.email) {
        // Email on Google account changed — keep sub as source of truth.
        user = await this.prisma.user.update({
          where: { id: user.id },
          data: {
            email: input.email,
            avatarUrl: input.avatarUrl ?? user.avatarUrl,
            name: user.name ?? input.name ?? undefined,
          },
        });
      }
    }

    return this.issueTokens(user, isNewUser);
  }

  private async verifyGoogleIdToken(idToken: string): Promise<{
    email?: string;
    email_verified?: boolean;
    sub?: string;
    name?: string;
    picture?: string;
    aud?: string;
    azp?: string;
    iss?: string;
  }> {
    const url = `https://oauth2.googleapis.com/tokeninfo?id_token=${encodeURIComponent(idToken)}`;
    const res = await fetch(url);
    if (!res.ok) {
      throw new UnauthorizedException('invalid_google_token');
    }
    const json = (await res.json()) as {
      email?: string;
      email_verified?: string | boolean;
      sub?: string;
      name?: string;
      picture?: string;
      aud?: string;
      azp?: string;
      iss?: string;
      error?: string;
      error_description?: string;
    };

    if (json.error) {
      throw new UnauthorizedException('invalid_google_token');
    }

    const issuer = json.iss ?? '';
    if (
      issuer &&
      issuer !== 'accounts.google.com' &&
      issuer !== 'https://accounts.google.com'
    ) {
      throw new UnauthorizedException('invalid_google_issuer');
    }

    const allowed = this.allowedGoogleAudiences();
    if (allowed.length) {
      const aud = json.aud ?? '';
      const azp = json.azp ?? '';
      if (!allowed.includes(aud) && !allowed.includes(azp)) {
        throw new UnauthorizedException('invalid_google_audience');
      }
    } else if ((process.env.NODE_ENV ?? 'development') === 'production') {
      throw new UnauthorizedException('google_client_ids_not_configured');
    }

    return {
      email: json.email,
      email_verified:
        json.email_verified === true || json.email_verified === 'true',
      sub: json.sub,
      name: json.name,
      picture: json.picture,
      aud: json.aud,
      azp: json.azp,
      iss: json.iss,
    };
  }

  private allowedGoogleAudiences(): string[] {
    const raw =
      this.config.get<string>('GOOGLE_CLIENT_IDS') ??
      this.config.get<string>('GOOGLE_WEB_CLIENT_ID') ??
      '';
    return raw
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);
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
        authProvider: 'password',
        status: 'active',
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

    this.assertUserActive(stored.user);
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

  private assertUserActive(user: {
    status?: string;
    deletedAt?: Date | null;
  }): void {
    if (user.deletedAt || user.status === 'deleted') {
      throw new UnauthorizedException('account_deleted');
    }
    if (user.status === 'suspended') {
      throw new UnauthorizedException('account_suspended');
    }
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

    await this.prisma.$transaction([
      this.prisma.refreshToken.create({
        data: {
          token: this.hashToken(refreshToken),
          userId: user.id,
          expiresAt,
        },
      }),
      this.prisma.user.update({
        where: { id: user.id },
        data: { lastLoginAt: new Date() },
      }),
    ]);

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
