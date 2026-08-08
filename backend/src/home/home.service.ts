import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { toProductCardJson } from '../products/product.mapper';

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
      this.prisma.serviceCard.findMany({
        where: { isFeatured: true },
        take: 8,
      }),
      this.prisma.adCard.findMany({
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
      featuredServices: featuredServices.map((s) => ({
        id: s.id,
        slug: s.slug,
        nameAr: s.nameAr,
        name: s.nameEn,
        basePrice: s.basePrice,
        imageUrl: s.imageUrl,
        rating: s.rating,
        totalBookings: s.totalBookings,
        category: s.categoryNameAr
          ? { nameAr: s.categoryNameAr }
          : null,
        isEmergency: s.isEmergency,
        pricingType: s.pricingType,
      })),
      recentAds: recentAds.map((a) => ({
        id: a.id,
        slug: a.slug,
        title: a.title,
        price: a.price,
        thumbnailUrl: a.thumbnailUrl,
        city: a.city,
        createdAt: a.createdAt.toISOString(),
        isBoosted: a.isBoosted,
        isFree: a.isFree,
      })),
    };
  }
}
