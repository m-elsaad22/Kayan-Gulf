import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DevicesService {
  constructor(private readonly prisma: PrismaService) {}

  async register(
    userId: string,
    body: { token: string; platform?: string; locale?: string },
  ) {
    const token = body.token.trim();
    const platform = (body.platform ?? 'android').toLowerCase();
    const locale = body.locale;

    const row = await this.prisma.deviceToken.upsert({
      where: { userId_token: { userId, token } },
      create: { userId, token, platform, locale },
      update: { platform, locale, updatedAt: new Date() },
    });

    return {
      id: row.id,
      token: row.token,
      platform: row.platform,
      locale: row.locale,
      ok: true,
    };
  }

  async unregister(userId: string, token: string) {
    await this.prisma.deviceToken.deleteMany({
      where: { userId, token },
    });
    return { ok: true };
  }

  async listTokensForUser(userId: string): Promise<string[]> {
    const rows = await this.prisma.deviceToken.findMany({
      where: { userId },
      select: { token: true },
    });
    return rows.map((r) => r.token);
  }
}
