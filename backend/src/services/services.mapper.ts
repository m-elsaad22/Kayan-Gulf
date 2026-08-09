import { Category, Service } from '@prisma/client';

function parseJsonArray<T = unknown>(raw: string): T[] {
  try {
    const v = JSON.parse(raw) as T[];
    return Array.isArray(v) ? v : [];
  } catch {
    return [];
  }
}

export function toServiceCategoryJson(
  c: Category & { _count?: { services: number } },
) {
  return {
    id: c.id,
    slug: c.slug,
    nameAr: c.nameAr,
    name: c.nameEn,
    nameEn: c.nameEn,
    emoji: c.emoji ?? '🔧',
    colorHex: c.color ?? '#3B82F6',
    serviceCount: c._count?.services ?? 0,
    isEmergency: c.isEmergency,
  };
}

export function toServiceDetailJson(
  s: Service & { category: Category | null },
) {
  return {
    id: s.id,
    slug: s.slug,
    nameAr: s.nameAr,
    name: s.nameEn,
    nameEn: s.nameEn,
    descriptionAr: s.descriptionAr,
    descriptionEn: s.descriptionEn,
    basePrice: s.basePrice,
    discountedPrice: s.discountedPrice,
    pricingType: s.pricingType,
    currency: s.currency,
    imageUrl: s.imageUrl,
    galleryUrls: parseJsonArray<string>(s.galleryUrlsJson),
    rating: s.rating,
    totalRatings: s.totalRatings,
    totalBookings: s.totalBookings,
    isEmergency: s.isEmergency,
    isAvailable: s.isAvailable,
    categoryNameAr: s.category?.nameAr ?? null,
    categorySlug: s.category?.slug ?? null,
    estimatedDurationMin: s.estimatedDurationMin,
    features: parseJsonArray(s.featuresJson),
    whatToExpect: parseJsonArray<string>(s.whatToExpectJson),
    faqs: parseJsonArray(s.faqsJson),
    technicians: [],
    reviews: [],
  };
}

export function toServiceCardJson(
  s: Service & { category: Category | null },
) {
  return {
    id: s.id,
    slug: s.slug,
    nameAr: s.nameAr,
    name: s.nameEn,
    basePrice: s.basePrice,
    imageUrl: s.imageUrl,
    rating: s.rating,
    totalBookings: s.totalBookings,
    category: s.category ? { nameAr: s.category.nameAr } : null,
    isEmergency: s.isEmergency,
    pricingType: s.pricingType,
  };
}
