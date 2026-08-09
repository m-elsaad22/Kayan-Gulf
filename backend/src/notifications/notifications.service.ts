import { Injectable, NotFoundException } from '@nestjs/common';
import { DevicesService } from '../devices/devices.service';
import { PrismaService } from '../prisma/prisma.service';
import { FcmService } from './fcm.service';

@Injectable()
export class NotificationsService {
  constructor(
    private readonly fcm: FcmService,
    private readonly devices: DevicesService,
    private readonly prisma: PrismaService,
  ) {}

  async pushToUser(
    userId: string,
    body: { title: string; body: string; data?: Record<string, string> },
  ) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundException('user_not_found');

    const tokens = await this.devices.listTokensForUser(userId);
    const result = await this.fcm.sendToTokens(tokens, body);
    return {
      userId,
      tokens: tokens.length,
      ...result,
    };
  }

  async pushToTokens(body: {
    tokens: string[];
    title: string;
    body: string;
    data?: Record<string, string>;
  }) {
    return this.fcm.sendToTokens(body.tokens, {
      title: body.title,
      body: body.body,
      data: body.data,
    });
  }
}
