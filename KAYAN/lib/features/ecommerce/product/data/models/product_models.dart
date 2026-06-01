// ============================================================
// KAYAN — Product Detail Models
// lib/features/ecommerce/product/data/models/product_models.dart
// ============================================================

// ── Product Image ─────────────────────────────────────────────
class ProductImage {
  final String id;
  final String url;
  final bool   isMain;
  final int    sortOrder;
  const ProductImage({
    required this.id,
    required this.url,
    this.isMain   = false,
    this.sortOrder = 0,
  });
  factory ProductImage.fromJson(Map<String, dynamic> j) => ProductImage(
    id:        j['id'] as String,
    url:       j['url'] as String,
    isMain:    j['isMain'] as bool? ?? false,
    sortOrder: j['sortOrder'] as int? ?? 0,
  );
}

// ── Variant Option ────────────────────────────────────────────
class VariantOption {
  final String id;
  final String type;     // 'color' | 'size' | 'model'
  final String valueAr;
  final String valueEn;
  final String? colorHex;
  final double? priceModifier;
  final int    stock;
  final bool   isAvailable;

  const VariantOption({
    required this.id,
    required this.type,
    required this.valueAr,
    required this.valueEn,
    this.colorHex,
    this.priceModifier,
    this.stock      = 0,
    this.isAvailable = true,
  });

  factory VariantOption.fromJson(Map<String, dynamic> j) => VariantOption(
    id:            j['id'] as String,
    type:          j['type'] as String,
    valueAr:       j['valueAr'] as String,
    valueEn:       j['value'] as String? ?? '',
    colorHex:      j['colorHex'] as String?,
    priceModifier: (j['priceModifier'] as num?)?.toDouble(),
    stock:         j['stock'] as int? ?? 0,
    isAvailable:   j['isAvailable'] as bool? ?? true,
  );
}

// ── Review ────────────────────────────────────────────────────
class ReviewModel {
  final String id;
  final String? userFirstName;
  final String? userAvatarUrl;
  final double  rating;
  final String? comment;
  final bool    isVerifiedPurchase;
  final int     helpfulCount;
  final DateTime createdAt;
  final List<String> images;

  const ReviewModel({
    required this.id,
    this.userFirstName,
    this.userAvatarUrl,
    required this.rating,
    this.comment,
    this.isVerifiedPurchase = false,
    this.helpfulCount       = 0,
    required this.createdAt,
    this.images             = const [],
  });

  factory ReviewModel.fromJson(Map<String, dynamic> j) => ReviewModel(
    id:                  j['id'] as String,
    userFirstName:       j['user']?['firstName'] as String?,
    userAvatarUrl:       j['user']?['avatarUrl'] as String?,
    rating:              (j['rating'] as num).toDouble(),
    comment:             j['comment'] as String?,
    isVerifiedPurchase:  j['isVerifiedPurchase'] as bool? ?? false,
    helpfulCount:        j['helpfulCount'] as int? ?? 0,
    createdAt:           DateTime.tryParse(j['createdAt'] as String) ?? DateTime.now(),
    images:              (j['images'] as List?)?.cast<String>() ?? [],
  );
}

// ── Rating Summary ────────────────────────────────────────────
class RatingSummary {
  final double avgRating;
  final int    totalReviews;
  final Map<int, int> breakdown; // {5: 120, 4: 45, 3: 12, 2: 3, 1: 2}

  const RatingSummary({
    required this.avgRating,
    required this.totalReviews,
    required this.breakdown,
  });

  double percentFor(int star) {
    if (totalReviews == 0) return 0;
    return (breakdown[star] ?? 0) / totalReviews;
  }
}

// ── Full Product Detail ───────────────────────────────────────
class ProductDetailModel {
  final String             id;
  final String             slug;
  final String             nameAr;
  final String             nameEn;
  final String?            descriptionAr;
  final String?            descriptionEn;
  final double             price;
  final double?            compareAtPrice;
  final String             currency;
  final String             status;
  final int                stock;
  final List<ProductImage> images;
  final double             rating;
  final int                totalRatings;
  final RatingSummary?     ratingSummary;
  final List<ReviewModel>  reviews;
  // Variants grouped by type
  final List<VariantOption> colorOptions;
  final List<VariantOption> sizeOptions;
  final List<VariantOption> modelOptions;
  // Related
  final List<ProductCardSimple> upsells;
  final String?             vendorName;
  final String?             vendorSlug;
  final bool                isFeatured;
  final List<String>        tags;
  // Shipping
  final bool                freeShipping;
  final int?                deliveryDays;

  const ProductDetailModel({
    required this.id,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.price,
    this.compareAtPrice,
    this.currency      = 'SAR',
    this.status        = 'ACTIVE',
    this.stock         = 0,
    this.images        = const [],
    this.rating        = 0,
    this.totalRatings  = 0,
    this.ratingSummary,
    this.reviews       = const [],
    this.colorOptions  = const [],
    this.sizeOptions   = const [],
    this.modelOptions  = const [],
    this.upsells       = const [],
    this.vendorName,
    this.vendorSlug,
    this.isFeatured    = false,
    this.tags          = const [],
    this.freeShipping  = false,
    this.deliveryDays,
  });

  double get discountPercent {
    if (compareAtPrice == null || compareAtPrice! <= price) return 0;
    return ((compareAtPrice! - price) / compareAtPrice! * 100);
  }

  bool get isOutOfStock => stock <= 0;
  bool get hasVariants =>
      colorOptions.isNotEmpty || sizeOptions.isNotEmpty || modelOptions.isNotEmpty;

  String get mainImageUrl =>
      images.firstWhere((i) => i.isMain, orElse: () =>
        images.isNotEmpty ? images.first : const ProductImage(id: '', url: '')).url;
}

// Simplified product for upsells list
class ProductCardSimple {
  final String  id;
  final String  slug;
  final String  nameAr;
  final String? imageUrl;
  final double  price;
  final double  rating;
  const ProductCardSimple({
    required this.id,
    required this.slug,
    required this.nameAr,
    this.imageUrl,
    required this.price,
    this.rating = 0,
  });
}

// ── Cart Item ─────────────────────────────────────────────────
class CartItemModel {
  final String  cartItemId;
  final String  productId;
  final String  slug;
  final String  nameAr;
  final String  nameEn;
  final String? imageUrl;
  final double  unitPrice;
  final int     quantity;
  final String? selectedColor;
  final String? selectedSize;
  final int     maxStock;

  const CartItemModel({
    required this.cartItemId,
    required this.productId,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    this.maxStock = 99,
  });

  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({int? quantity}) => CartItemModel(
    cartItemId:    cartItemId,
    productId:     productId,
    slug:          slug,
    nameAr:        nameAr,
    nameEn:        nameEn,
    imageUrl:      imageUrl,
    unitPrice:     unitPrice,
    quantity:      quantity ?? this.quantity,
    selectedColor: selectedColor,
    selectedSize:  selectedSize,
    maxStock:      maxStock,
  );
}

// ── Cart Summary ──────────────────────────────────────────────
class CartSummary {
  final double subtotal;
  final double discount;
  final double shipping;
  final double vat;
  final double total;
  final String currency;
  final String? couponCode;
  final double  couponDiscount;
  final int     itemCount;

  const CartSummary({
    required this.subtotal,
    this.discount       = 0,
    this.shipping       = 0,
    required this.vat,
    required this.total,
    this.currency       = 'SAR',
    this.couponCode,
    this.couponDiscount = 0,
    required this.itemCount,
  });

  bool get hasCoupon => couponCode != null && couponCode!.isNotEmpty;
  bool get isFreeShipping => shipping == 0;
}
