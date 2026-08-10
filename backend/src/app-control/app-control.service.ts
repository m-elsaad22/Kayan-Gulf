import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export type AppControlDto = {
  enabled: boolean;
  maintenanceMode: boolean;
  messageAr: string;
  messageEn: string;
  minVersion: string;
  latestVersion: string;
  forceUpdate: boolean;
  supportUrl: string;
  websiteUrl: string;
  apkUrl: string | null;
  playStoreUrl: string | null;
  updatedAt: string;
  source: 'api';
};

export type UpdateAppControlInput = Partial<{
  enabled: boolean;
  maintenanceMode: boolean;
  messageAr: string;
  messageEn: string;
  minVersion: string;
  latestVersion: string;
  forceUpdate: boolean;
  supportUrl: string;
  websiteUrl: string;
  apkUrl: string | null;
  playStoreUrl: string | null;
}>;

@Injectable()
export class AppControlService {
  constructor(private readonly prisma: PrismaService) {}

  async ensureDefault() {
    return this.prisma.appControl.upsert({
      where: { id: 'default' },
      create: { id: 'default' },
      update: {},
    });
  }

  async getPublicStatus(): Promise<AppControlDto> {
    const row = await this.ensureDefault();
    return this.toDto(row);
  }

  async update(
    input: UpdateAppControlInput,
    actorId?: string,
  ): Promise<AppControlDto> {
    await this.ensureDefault();
    const row = await this.prisma.appControl.update({
      where: { id: 'default' },
      data: {
        ...input,
        updatedById: actorId,
      },
    });

    await this.prisma.auditLog.create({
      data: {
        actorId: actorId ?? null,
        action: 'app_control.update',
        resource: 'AppControl',
        resourceId: 'default',
        metaJson: JSON.stringify(input),
        success: true,
      },
    });

    return this.toDto(row);
  }

  private toDto(row: {
    enabled: boolean;
    maintenanceMode: boolean;
    messageAr: string;
    messageEn: string;
    minVersion: string;
    latestVersion: string;
    forceUpdate: boolean;
    supportUrl: string;
    websiteUrl: string;
    apkUrl: string | null;
    playStoreUrl: string | null;
    updatedAt: Date;
  }): AppControlDto {
    return {
      enabled: row.enabled,
      maintenanceMode: row.maintenanceMode,
      messageAr: row.messageAr,
      messageEn: row.messageEn,
      minVersion: row.minVersion,
      latestVersion: row.latestVersion,
      forceUpdate: row.forceUpdate,
      supportUrl: row.supportUrl,
      websiteUrl: row.websiteUrl,
      apkUrl: row.apkUrl,
      playStoreUrl: row.playStoreUrl,
      updatedAt: row.updatedAt.toISOString(),
      source: 'api',
    };
  }
}
