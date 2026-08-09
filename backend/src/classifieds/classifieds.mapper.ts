import { Category, ClassifiedAd, User } from '@prisma/client';

function parseImages(raw: string): string[] {
  try {
    const v = JSON.parse(raw) as string[];
    return Array.isArray(v) ? v : [];
  } catch {
    return [];
  }
}

export function toAdCategoryJson(
  c: Category & { _count?: { classifiedAds: number } },
) {
  return {
    id: c.id,
    slug: c.slug,
    nameAr: c.nameAr,
    name: c.nameEn,
    nameEn: c.nameEn,
    emoji: c.emoji ?? '📦',
    adCount: c._count?.classifiedAds ?? 0,
  };
}

export function toAdJson(
  ad: ClassifiedAd & { category: Category | null; owner?: User | null },
) {
  const imageUrls = parseImages(ad.imageUrlsJson);
  return {
    id: ad.id,
    slug: ad.slug,
    title: ad.title,
    description: ad.description,
    price: ad.price,
    isFree: ad.isFree,
    isNegotiable: ad.isNegotiable,
    city: ad.city,
    district: ad.district,
    categoryId: ad.categoryId ?? '',
    categorySlug: ad.category?.slug ?? '',
    categoryNameAr: ad.category?.nameAr ?? null,
    categoryNameEn: ad.category?.nameEn ?? null,
    condition: ad.condition,
    imageUrls,
    createdAt: ad.createdAt.toISOString(),
    viewCount: ad.viewCount,
    favoriteCount: ad.favoriteCount,
    isBoosted: ad.isBoosted,
    isFeatured: ad.isFeatured,
    isFavorited: false,
    seller: ad.owner
      ? {
          id: ad.owner.id,
          name: ad.owner.name ?? 'مستخدم كيان',
          totalAds: 0,
          memberDays: 0,
          rating: 0,
          isVerified: false,
        }
      : null,
  };
}

export function toMyAdJson(
  ad: ClassifiedAd & { category: Category | null; owner?: User | null },
) {
  const daysLeft = ad.expiresAt
    ? Math.max(
        0,
        Math.ceil(
          (ad.expiresAt.getTime() - Date.now()) / (24 * 60 * 60 * 1000),
        ),
      )
    : 30;
  return {
    ad: toAdJson(ad),
    status: ad.status,
    daysLeft,
    canBoost: ad.status === 'ACTIVE' && !ad.isBoosted,
  };
}

export function toHomeAdCardJson(ad: ClassifiedAd) {
  const imageUrls = parseImages(ad.imageUrlsJson);
  return {
    id: ad.id,
    slug: ad.slug,
    title: ad.title,
    price: ad.price,
    thumbnailUrl: imageUrls[0] ?? null,
    city: ad.city,
    createdAt: ad.createdAt.toISOString(),
    isBoosted: ad.isBoosted,
    isFree: ad.isFree,
  };
}
