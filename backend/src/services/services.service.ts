import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  toServiceCategoryJson,
  toServiceDetailJson,
} from './services.mapper';

@Injectable()
export class ServicesService {
  constructor(private readonly prisma: PrismaService) {}

  async categories() {
    const rows = await this.prisma.category.findMany({
      where: { kind: 'service' },
      orderBy: { sortOrder: 'asc' },
      include: { _count: { select: { services: true } } },
    });
    return { items: rows.map(toServiceCategoryJson) };
  }

  async list(categorySlug?: string) {
    const services = await this.prisma.service.findMany({
      where: {
        isAvailable: true,
        ...(categorySlug
          ? { category: { slug: categorySlug } }
          : {}),
      },
      include: { category: true },
      orderBy: [{ isFeatured: 'desc' }, { rating: 'desc' }],
    });
    return { items: services.map(toServiceDetailJson) };
  }

  async detail(slug: string) {
    const service = await this.prisma.service.findUnique({
      where: { slug },
      include: { category: true },
    });
    if (!service) throw new NotFoundException('service_not_found');
    return { service: toServiceDetailJson(service) };
  }
}
