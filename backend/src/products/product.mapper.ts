import { Product, ProductImage, Vendor } from '@prisma/client';

type ProductWithRelations = Product & {
  images: ProductImage[];
  vendor: Vendor | null;
};

/** Maps DB product → Flutter ProductCardModel.fromJson shape. */
export function toProductCardJson(p: ProductWithRelations) {
  return {
    id: p.id,
    slug: p.slug,
    nameAr: p.nameAr,
    name: p.nameEn,
    price: p.price,
    compareAtPrice: p.compareAtPrice,
    images: p.images.map((img) => ({
      id: img.id,
      url: img.url,
      isMain: img.isMain,
      sortOrder: img.sortOrder,
    })),
    rating: p.rating,
    totalRatings: p.totalRatings,
    isFeatured: p.isFeatured,
    flashDeal: p.flashDealEndsAt
      ? { endsAt: p.flashDealEndsAt.toISOString() }
      : null,
    vendor: p.vendor ? { businessName: p.vendor.businessName } : null,
    stock: p.stock,
  };
}

/** Maps DB product → Flutter ProductDetailModel.fromJson shape. */
export function toProductDetailJson(p: ProductWithRelations) {
  let tags: string[] = [];
  try {
    tags = JSON.parse(p.tagsJson) as string[];
  } catch {
    tags = [];
  }

  return {
    id: p.id,
    slug: p.slug,
    nameAr: p.nameAr,
    name: p.nameEn,
    nameEn: p.nameEn,
    descriptionAr: p.descriptionAr,
    descriptionEn: p.descriptionEn,
    price: p.price,
    compareAtPrice: p.compareAtPrice,
    currency: p.currency,
    status: p.status,
    stock: p.stock,
    images: p.images.map((img) => ({
      id: img.id,
      url: img.url,
      isMain: img.isMain,
      sortOrder: img.sortOrder,
    })),
    rating: p.rating,
    totalRatings: p.totalRatings,
    ratingSummary: {
      avgRating: p.rating,
      totalReviews: p.totalRatings,
      breakdown: {
        '5': Math.round(p.totalRatings * 0.6),
        '4': Math.round(p.totalRatings * 0.25),
        '3': Math.round(p.totalRatings * 0.1),
        '2': Math.max(0, Math.round(p.totalRatings * 0.03)),
        '1': Math.max(0, Math.round(p.totalRatings * 0.02)),
      },
    },
    reviews: [],
    colorOptions: [],
    sizeOptions: [],
    modelOptions: [],
    vendorName: p.vendor?.businessName ?? null,
    vendorSlug: p.vendor?.slug ?? null,
    isFeatured: p.isFeatured,
    tags,
    freeShipping: p.freeShipping,
    deliveryDays: p.deliveryDays,
  };
}
