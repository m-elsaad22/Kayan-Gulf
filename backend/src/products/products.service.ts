import { Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { toProductCardJson, toProductDetailJson } from './product.mapper';

export type ProductQuery = {
  categorySlug?: string;
  search?: string;
  minPrice?: number;
  maxPrice?: number;
  minRating?: number;
  sort?: string;
  inStockOnly?: boolean | string;
  onSaleOnly?: boolean | string;
  page?: number | string;
};

@Injectable()
export class ProductsService {
  constructor(private readonly prisma: PrismaService) {}

  async list(query: ProductQuery) {
    const page = Math.max(1, Number(query.page ?? 1));
    const take = 24;
    const skip = (page - 1) * take;

    const where: Prisma.ProductWhereInput = {
      status: 'ACTIVE',
    };

    if (query.categorySlug) {
      where.category = { slug: query.categorySlug };
    }
    if (query.search) {
      where.OR = [
        { nameAr: { contains: query.search } },
        { nameEn: { contains: query.search } },
      ];
    }
    if (query.minPrice != null) {
      where.price = { ...(where.price as object), gte: Number(query.minPrice) };
    }
    if (query.maxPrice != null) {
      where.price = { ...(where.price as object), lte: Number(query.maxPrice) };
    }
    if (query.minRating != null) {
      where.rating = { gte: Number(query.minRating) };
    }
    if (query.inStockOnly === true || query.inStockOnly === 'true') {
      where.stock = { gt: 0 };
    }
    if (query.onSaleOnly === true || query.onSaleOnly === 'true') {
      where.compareAtPrice = { not: null };
    }

    const orderBy = this.resolveSort(query.sort);

    const products = await this.prisma.product.findMany({
      where,
      include: { images: { orderBy: { sortOrder: 'asc' } }, vendor: true },
      orderBy,
      skip,
      take,
    });

    return {
      items: products.map(toProductCardJson),
      page,
      pageSize: take,
    };
  }

  async detail(slug: string) {
    const product = await this.prisma.product.findUnique({
      where: { slug },
      include: { images: { orderBy: { sortOrder: 'asc' } }, vendor: true },
    });
    if (!product) {
      throw new NotFoundException('product_not_found');
    }
    return { product: toProductDetailJson(product) };
  }

  private resolveSort(
    sort?: string,
  ): Prisma.ProductOrderByWithRelationInput | Prisma.ProductOrderByWithRelationInput[] {
    switch (sort) {
      case 'priceAsc':
        return { price: 'asc' };
      case 'priceDesc':
        return { price: 'desc' };
      case 'topRated':
        return { rating: 'desc' };
      case 'bestSeller':
        return { totalRatings: 'desc' };
      case 'newest':
      default:
        return { createdAt: 'desc' };
    }
  }
}
