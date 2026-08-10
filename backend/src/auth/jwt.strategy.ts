import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PrismaService } from '../prisma/prisma.service';

export type JwtPayload = { sub: string; role?: string };

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    private readonly prisma: PrismaService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.getOrThrow<string>('JWT_ACCESS_SECRET'),
    });
  }

  async validate(payload: JwtPayload) {
    const user = await this.prisma.user.findUnique({
      where: { id: payload.sub },
    });
    if (!user || user.deletedAt || user.status === 'deleted') {
      throw new UnauthorizedException('invalid_token');
    }
    if (user.status === 'suspended') {
      throw new UnauthorizedException('account_suspended');
    }
    if (user.status !== 'active') {
      throw new UnauthorizedException('account_inactive');
    }
    return {
      userId: user.id,
      email: user.email,
      phone: user.phone,
      role: user.role,
    };
  }
}
