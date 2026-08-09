import { Injectable } from '@nestjs/common';
import { toHomeAdCardJson } from '../classifieds/classifieds.mapper';
import { PrismaService } from '../prisma/prisma.service';
import { toProductCardJson } from '../products/product.mapper';
import { toServiceCardJson } from '../services/services.mapper';

@Injectable()
export class HomeService {
  constructor(private readonly prisma: PrismaService) {}

  async getHome() {
    const [
      banners,
      ecommerceCategories,
      serviceCategories,
      flashDealProducts,
      featuredProducts,
      recommendations,
      featuredServices,
      recentAds,
    ] = await Promise.all([
      this.prisma.banner.findMany({
        where: { isActive: true },
        orderBy: { sortOrder: 'asc' },
      }),
      this.prisma.category.findMany({
        where: { kind: 'ecommerce' },
        orderBy: { sortOrder: 'asc' },
      }),
      this.prisma.category.findMany({
        where: { kind: 'service' },
        orderBy: { sortOrder: 'asc' },
      }),
      this.prisma.product.findMany({
        where: { flashDealEndsAt: { gt: new Date() }, status: 'ACTIVE' },
        include: { images: true, vendor: true },
        take: 12,
        orderBy: { flashDealEndsAt: 'asc' },
      }),
      this.prisma.product.findMany({
        where: { isFeatured: true, status: 'ACTIVE' },
        include: { images: true, vendor: true },
        take: 12,
        orderBy: { rating: 'desc' },
      }),
      this.prisma.product.findMany({
        where: { status: 'ACTIVE' },
        include: { images: true, vendor: true },
        take: 12,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.service.findMany({
        where: { isFeatured: true, isAvailable: true },
        include: { category: true },
        take: 8,
        orderBy: { rating: 'desc' },
      }),
      this.prisma.classifiedAd.findMany({
        where: { status: 'ACTIVE' },
        orderBy: { createdAt: 'desc' },
        take: 12,
      }),
    ]);

    return {
      banners: banners.map((b) => ({
        id: b.id,
        imageUrl: b.imageUrl,
        titleAr: b.titleAr,
        titleEn: b.titleEn,
        subtitleAr: b.subtitleAr,
        subtitleEn: b.subtitleEn,
        actionRoute: b.actionRoute,
        actionParam: b.actionParam,
        sortOrder: b.sortOrder,
      })),
      ecommerceCategories: ecommerceCategories.map((c) => ({
        id: c.id,
        slug: c.slug,
        nameAr: c.nameAr,
        nameEn: c.nameEn,
        iconUrl: c.iconUrl,
        color: c.color,
        sortOrder: c.sortOrder,
        isEmergency: c.isEmergency,
      })),
      serviceCategories: serviceCategories.map((c) => ({
        id: c.id,
        slug: c.slug,
        nameAr: c.nameAr,
        nameEn: c.nameEn,
        iconUrl: c.iconUrl,
        color: c.color,
        sortOrder: c.sortOrder,
        isEmergency: c.isEmergency,
      })),
      flashDeals: flashDealProducts.map(toProductCardJson),
      featuredProducts: featuredProducts.map(toProductCardJson),
      recommendations: recommendations.map(toProductCardJson),
      featuredServices: featuredServices.map(toServiceCardJson),
      recentAds: recentAds.map(toHomeAdCardJson),
    };
  }
}
