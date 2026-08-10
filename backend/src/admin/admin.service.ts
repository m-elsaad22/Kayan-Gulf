import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AppControlService, UpdateAppControlInput } from '../app-control/app-control.service';
import { toProductCardJson } from '../products/product.mapper';
import { toServiceDetailJson } from '../services/services.mapper';
import { toMyAdJson } from '../classifieds/classifieds.mapper';
import { isPrivilegedAdmin } from '../auth/admin.guard';

const USER_ROLES = ['user', 'support', 'moderator', 'admin', 'super_admin'] as const;
const USER_STATUSES = ['active', 'suspended', 'deleted'] as const;

@Injectable()
export class AdminService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly appControl: AppControlService,
  ) {}

  async stats() {
    const [users, products, orders, services, bookings, ads, banners] =
      await Promise.all([
        this.prisma.user.count({ where: { status: { not: 'deleted' } } }),
        this.prisma.product.count(),
        this.prisma.order.count(),
        this.prisma.service.count(),
        this.prisma.booking.count(),
        this.prisma.classifiedAd.count(),
        this.prisma.banner.count(),
      ]);

    const recentOrders = await this.prisma.order.findMany({
      take: 5,
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        status: true,
        total: true,
        currency: true,
        createdAt: true,
        paymentMethod: true,
      },
    });

    return {
      counts: {
        users,
        products,
        orders,
        services,
        bookings,
        ads,
        banners,
      },
      recentOrders: recentOrders.map((o) => ({
        ...o,
        createdAt: o.createdAt.toISOString(),
      })),
    };
  }

  async listUsers(query?: { q?: string; status?: string; role?: string }) {
    const where: Record<string, unknown> = {};
    if (query?.status) where.status = query.status;
    if (query?.role) where.role = query.role;
    if (query?.q?.trim()) {
      const q = query.q.trim();
      where.OR = [
        { email: { contains: q, mode: 'insensitive' } },
        { phone: { contains: q } },
        { name: { contains: q, mode: 'insensitive' } },
      ];
    }

    const users = await this.prisma.user.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      take: 200,
      select: {
        id: true,
        email: true,
        phone: true,
        name: true,
        role: true,
        status: true,
        authProvider: true,
        googleSub: true,
        isProfileComplete: true,
        lastLoginAt: true,
        createdAt: true,
        deletedAt: true,
        _count: {
          select: {
            orders: true,
            bookings: true,
            deviceTokens: true,
            classifiedAds: true,
          },
        },
      },
    });
    return {
      items: users.map((u) => ({
        id: u.id,
        email: u.email,
        phone: u.phone,
        name: u.name,
        role: u.role,
        status: u.status,
        authProvider: u.authProvider,
        hasGoogle: !!u.googleSub,
        isProfileComplete: u.isProfileComplete,
        lastLoginAt: u.lastLoginAt?.toISOString() ?? null,
        createdAt: u.createdAt.toISOString(),
        deletedAt: u.deletedAt?.toISOString() ?? null,
        counts: {
          orders: u._count.orders,
          bookings: u._count.bookings,
          devices: u._count.deviceTokens,
          ads: u._count.classifiedAds,
        },
      })),
    };
  }

  async getUser(id: string) {
    const u = await this.prisma.user.findUnique({
      where: { id },
      include: {
        deviceTokens: { orderBy: { lastSeenAt: 'desc' } },
        orders: { take: 20, orderBy: { createdAt: 'desc' } },
        bookings: { take: 20, orderBy: { createdAt: 'desc' } },
        classifiedAds: { take: 20, orderBy: { createdAt: 'desc' } },
      },
    });
    if (!u) throw new NotFoundException('user_not_found');
    return {
      id: u.id,
      email: u.email,
      phone: u.phone,
      name: u.name,
      avatarUrl: u.avatarUrl,
      role: u.role,
      status: u.status,
      authProvider: u.authProvider,
      googleSub: u.googleSub,
      isProfileComplete: u.isProfileComplete,
      lastLoginAt: u.lastLoginAt?.toISOString() ?? null,
      createdAt: u.createdAt.toISOString(),
      deletedAt: u.deletedAt?.toISOString() ?? null,
      devices: u.deviceTokens.map((d) => ({
        id: d.id,
        platform: d.platform,
        appVersion: d.appVersion,
        deviceName: d.deviceName,
        status: d.status,
        lastSeenAt: d.lastSeenAt.toISOString(),
        createdAt: d.createdAt.toISOString(),
      })),
      orders: u.orders.map((o) => ({
        id: o.id,
        status: o.status,
        total: o.total,
        createdAt: o.createdAt.toISOString(),
      })),
      bookings: u.bookings.map((b) => ({
        id: b.id,
        bookingNumber: b.bookingNumber,
        status: b.status,
        scheduledAt: b.scheduledAt.toISOString(),
      })),
      ads: u.classifiedAds.map((a) => ({
        id: a.id,
        title: a.title,
        status: a.status,
      })),
    };
  }

  async updateUser(
    id: string,
    input: { role?: string; status?: string; name?: string },
    actor: { userId: string; role: string },
  ) {
    const existing = await this.prisma.user.findUnique({ where: { id } });
    if (!existing) throw new NotFoundException('user_not_found');

    if (input.role !== undefined) {
      if (!isPrivilegedAdmin(actor.role)) {
        throw new ForbiddenException('privileged_admin_required');
      }
      if (!USER_ROLES.includes(input.role as (typeof USER_ROLES)[number])) {
        throw new BadRequestException('invalid_role');
      }
      if (
        existing.role === 'super_admin' &&
        input.role !== 'super_admin' &&
        actor.role !== 'super_admin'
      ) {
        throw new ForbiddenException('cannot_demote_super_admin');
      }
    }

    if (input.status !== undefined) {
      if (!isPrivilegedAdmin(actor.role)) {
        throw new ForbiddenException('privileged_admin_required');
      }
      if (
        !USER_STATUSES.includes(input.status as (typeof USER_STATUSES)[number])
      ) {
        throw new BadRequestException('invalid_status');
      }
    }

    const data: {
      role?: string;
      status?: string;
      name?: string;
      deletedAt?: Date | null;
    } = {};
    if (input.role !== undefined) data.role = input.role;
    if (input.name !== undefined) data.name = input.name;
    if (input.status !== undefined) {
      data.status = input.status;
      data.deletedAt = input.status === 'deleted' ? new Date() : null;
    }

    const updated = await this.prisma.user.update({
      where: { id },
      data,
    });

    await this.prisma.auditLog.create({
      data: {
        actorId: actor.userId,
        action: 'user.update',
        resource: 'User',
        resourceId: id,
        metaJson: JSON.stringify(input),
        success: true,
      },
    });

    // Soft-delete / suspend → revoke refresh tokens
    if (input.status === 'suspended' || input.status === 'deleted') {
      await this.prisma.refreshToken.deleteMany({ where: { userId: id } });
    }

    return {
      id: updated.id,
      role: updated.role,
      status: updated.status,
      name: updated.name,
    };
  }

  async setDeviceStatus(
    userId: string,
    deviceId: string,
    status: string,
    actorId: string,
  ) {
    if (!['active', 'inactive'].includes(status)) {
      throw new BadRequestException('invalid_device_status');
    }
    const device = await this.prisma.deviceToken.findFirst({
      where: { id: deviceId, userId },
    });
    if (!device) throw new NotFoundException('device_not_found');
    const updated = await this.prisma.deviceToken.update({
      where: { id: deviceId },
      data: { status },
    });
    await this.prisma.auditLog.create({
      data: {
        actorId,
        action: 'device.status',
        resource: 'DeviceToken',
        resourceId: deviceId,
        metaJson: JSON.stringify({ status }),
        success: true,
      },
    });
    return {
      id: updated.id,
      status: updated.status,
    };
  }

  async listAuditLogs(take = 50) {
    const rows = await this.prisma.auditLog.findMany({
      orderBy: { createdAt: 'desc' },
      take,
      include: { actor: { select: { email: true, name: true } } },
    });
    return {
      items: rows.map((r) => ({
        id: r.id,
        action: r.action,
        resource: r.resource,
        resourceId: r.resourceId,
        success: r.success,
        actorEmail: r.actor?.email ?? null,
        actorName: r.actor?.name ?? null,
        createdAt: r.createdAt.toISOString(),
        metaJson: r.metaJson,
      })),
    };
  }

  getAppControl() {
    return this.appControl.getPublicStatus();
  }

  updateAppControl(input: UpdateAppControlInput, actorId: string) {
    return this.appControl.update(input, actorId);
  }

  async listProducts() {
    const products = await this.prisma.product.findMany({
      include: { images: true, vendor: true, category: true },
      orderBy: { createdAt: 'desc' },
    });
    return {
      items: products.map((p) => ({
        ...toProductCardJson(p),
        status: p.status,
        categorySlug: p.category?.slug ?? null,
      })),
    };
  }

  async updateProductStatus(id: string, status: string) {
    const allowed = ['ACTIVE', 'DRAFT', 'ARCHIVED'];
    if (!allowed.includes(status)) {
      throw new BadRequestException('invalid_status');
    }
    const product = await this.prisma.product.findUnique({ where: { id } });
    if (!product) throw new NotFoundException('product_not_found');
    const updated = await this.prisma.product.update({
      where: { id },
      data: { status },
      include: { images: true, vendor: true },
    });
    return toProductCardJson(updated);
  }

  async listOrders() {
    const orders = await this.prisma.order.findMany({
      include: { items: true, address: true, user: true },
      orderBy: { createdAt: 'desc' },
      take: 100,
    });
    return {
      items: orders.map((o) => ({
        id: o.id,
        status: o.status,
        total: o.total,
        currency: o.currency,
        paymentMethod: o.paymentMethod,
        itemCount: o.items.reduce((s, i) => s + i.quantity, 0),
        userEmail: o.user.email,
        userName: o.user.name,
        createdAt: o.createdAt.toISOString(),
      })),
    };
  }

  async updateOrderStatus(id: string, status: string) {
    const allowed = [
      'pending',
      'paid',
      'shipping',
      'delivered',
      'cancelled',
    ];
    if (!allowed.includes(status)) {
      throw new BadRequestException('invalid_status');
    }
    const existing = await this.prisma.order.findUnique({ where: { id } });
    if (!existing) throw new NotFoundException('order_not_found');
    const order = await this.prisma.order.update({
      where: { id },
      data: { status },
    });
    return {
      id: order.id,
      status: order.status,
      total: order.total,
    };
  }

  async listServices() {
    const services = await this.prisma.service.findMany({
      include: { category: true },
      orderBy: { createdAt: 'desc' },
    });
    return { items: services.map(toServiceDetailJson) };
  }

  async listAds() {
    const ads = await this.prisma.classifiedAd.findMany({
      include: { category: true, owner: true },
      orderBy: { createdAt: 'desc' },
      take: 100,
    });
    return { items: ads.map(toMyAdJson) };
  }

  async updateAdStatus(id: string, status: string) {
    const allowed = ['ACTIVE', 'PAUSED', 'SOLD', 'EXPIRED'];
    if (!allowed.includes(status)) {
      throw new BadRequestException('invalid_status');
    }
    const existing = await this.prisma.classifiedAd.findUnique({
      where: { id },
    });
    if (!existing) throw new NotFoundException('ad_not_found');
    const ad = await this.prisma.classifiedAd.update({
      where: { id },
      data: { status },
      include: { category: true, owner: true },
    });
    return toMyAdJson(ad);
  }

  async listBanners() {
    const banners = await this.prisma.banner.findMany({
      orderBy: { sortOrder: 'asc' },
    });
    return { items: banners };
  }

  async listBookings() {
    const bookings = await this.prisma.booking.findMany({
      include: { service: true, user: true },
      orderBy: { createdAt: 'desc' },
      take: 100,
    });
    return {
      items: bookings.map((b) => ({
        id: b.id,
        bookingNumber: b.bookingNumber,
        status: b.status,
        price: b.price,
        currency: b.currency,
        scheduledAt: b.scheduledAt.toISOString(),
        addressLine: b.addressLine,
        serviceNameAr: b.service.nameAr,
        userEmail: b.user.email,
        userName: b.user.name,
      })),
    };
  }
}
