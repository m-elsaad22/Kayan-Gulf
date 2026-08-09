import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import {
  toAdCategoryJson,
  toAdJson,
  toMyAdJson,
} from './classifieds.mapper';

export type AdsQuery = {
  categorySlug?: string;
  search?: string;
  sort?: string;
  featuredOnly?: boolean | string;
  page?: number | string;
};

@Injectable()
export class ClassifiedsService {
  constructor(private readonly prisma: PrismaService) {}

  async categories() {
    const rows = await this.prisma.category.findMany({
      where: { kind: 'classified' },
      orderBy: { sortOrder: 'asc' },
      include: { _count: { select: { classifiedAds: true } } },
    });
    return { items: rows.map(toAdCategoryJson) };
  }

  async listAds(query: AdsQuery) {
    const page = Math.max(1, Number(query.page ?? 1));
    const take = 24;
    const skip = (page - 1) * take;

    const where: Prisma.ClassifiedAdWhereInput = {
      status: 'ACTIVE',
    };
    if (query.categorySlug) {
      where.category = { slug: query.categorySlug };
    }
    if (query.search) {
      where.OR = [
        { title: { contains: query.search } },
        { description: { contains: query.search } },
      ];
    }
    if (query.featuredOnly === true || query.featuredOnly === 'true') {
      where.isFeatured = true;
    }

    let orderBy: Prisma.ClassifiedAdOrderByWithRelationInput = {
      createdAt: 'desc',
    };
    if (query.sort === 'priceAsc') orderBy = { price: 'asc' };
    if (query.sort === 'priceDesc') orderBy = { price: 'desc' };

    const ads = await this.prisma.classifiedAd.findMany({
      where,
      include: { category: true, owner: true },
      orderBy,
      skip,
      take,
    });
    return { items: ads.map(toAdJson), page, pageSize: take };
  }

  async featured() {
    const ads = await this.prisma.classifiedAd.findMany({
      where: {
        status: 'ACTIVE',
        OR: [{ isFeatured: true }, { isBoosted: true }],
      },
      include: { category: true, owner: true },
      orderBy: { createdAt: 'desc' },
      take: 20,
    });
    return { items: ads.map(toAdJson) };
  }

  async detail(slug: string) {
    const ad = await this.prisma.classifiedAd.findUnique({
      where: { slug },
      include: { category: true, owner: true },
    });
    if (!ad) throw new NotFoundException('ad_not_found');

    await this.prisma.classifiedAd.update({
      where: { id: ad.id },
      data: { viewCount: { increment: 1 } },
    });

    return { ad: toAdJson({ ...ad, viewCount: ad.viewCount + 1 }) };
  }

  async myAds(userId: string) {
    const ads = await this.prisma.classifiedAd.findMany({
      where: { ownerId: userId },
      include: { category: true, owner: true },
      orderBy: { createdAt: 'desc' },
    });
    return { items: ads.map(toMyAdJson) };
  }

  async create(
    userId: string,
    body: {
      title: string;
      description?: string;
      price?: number;
      isFree?: boolean;
      isNegotiable?: boolean;
      city: string;
      district?: string;
      categorySlug: string;
      condition?: string;
      imageUrls?: string[];
    },
  ) {
    const category = await this.prisma.category.findFirst({
      where: { slug: body.categorySlug, kind: 'classified' },
    });
    if (!category) throw new NotFoundException('category_not_found');

    const baseSlug = body.title
      .toLowerCase()
      .replace(/[^\w\u0600-\u06FF]+/g, '-')
      .replace(/^-|-$/g, '')
      .slice(0, 40);
    const slug = `${baseSlug || 'ad'}-${Date.now().toString(36)}`;

    const ad = await this.prisma.classifiedAd.create({
      data: {
        slug,
        title: body.title,
        description: body.description,
        price: body.isFree ? null : body.price,
        isFree: body.isFree ?? false,
        isNegotiable: body.isNegotiable ?? false,
        city: body.city,
        district: body.district ?? '',
        condition: body.condition ?? 'good',
        imageUrlsJson: JSON.stringify(body.imageUrls ?? []),
        categoryId: category.id,
        ownerId: userId,
        status: 'ACTIVE',
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      },
      include: { category: true, owner: true },
    });
    return { ad: toAdJson(ad) };
  }

  async updateStatus(userId: string, id: string, status: string) {
    const allowed = ['ACTIVE', 'PAUSED', 'SOLD', 'EXPIRED'];
    if (!allowed.includes(status)) {
      throw new BadRequestException('invalid_status');
    }
    const existing = await this.prisma.classifiedAd.findFirst({
      where: { id, ownerId: userId },
    });
    if (!existing) throw new NotFoundException('ad_not_found');

    const ad = await this.prisma.classifiedAd.update({
      where: { id },
      data: { status },
      include: { category: true, owner: true },
    });
    return toMyAdJson(ad);
  }
}
