import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { toProductCardJson } from '../products/product.mapper';
import { toServiceDetailJson } from '../services/services.mapper';
import { toMyAdJson } from '../classifieds/classifieds.mapper';

@Injectable()
export class AdminService {
  constructor(private readonly prisma: PrismaService) {}

  async stats() {
    const [
      users,
      products,
      orders,
      services,
      bookings,
      ads,
      banners,
    ] = await Promise.all([
      this.prisma.user.count(),
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

  async listUsers() {
    const users = await this.prisma.user.findMany({
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        email: true,
        phone: true,
        name: true,
        role: true,
        isProfileComplete: true,
        createdAt: true,
      },
    });
    return {
      items: users.map((u) => ({
        ...u,
        createdAt: u.createdAt.toISOString(),
      })),
    };
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
