// ============================================================
// KAYAN — Home Screen Data Models
// lib/features/home/data/models/home_models.dart
// ============================================================

class BannerModel {
  final String id;
  final String imageUrl;
  final String? titleAr;
  final String? titleEn;
  final String? subtitleAr;
  final String? subtitleEn;
  final String? actionRoute;
  final String? actionParam;
  final int sortOrder;

  const BannerModel({
    required this.id,
    required this.imageUrl,
    this.titleAr,
    this.titleEn,
    this.subtitleAr,
    this.subtitleEn,
    this.actionRoute,
    this.actionParam,
    this.sortOrder = 0,
  });

  factory BannerModel.fromJson(Map<String, dynamic> j) => BannerModel(
    id:           j['id'] as String,
    imageUrl:     j['imageUrl'] as String,
    titleAr:      j['titleAr'] as String?,
    titleEn:      j['titleEn'] as String?,
    subtitleAr:   j['subtitleAr'] as String?,
    subtitleEn:   j['subtitleEn'] as String?,
    actionRoute:  j['actionRoute'] as String?,
    actionParam:  j['actionParam'] as String?,
    sortOrder:    j['sortOrder'] as int? ?? 0,
  );
}

class CategoryModel {
  final String id;
  final String slug;
  final String nameAr;
  final String nameEn;
  final String? iconUrl;
  final String? color;    // hex: #4169E1
  final int sortOrder;
  final bool isEmergency;

  const CategoryModel({
    required this.id,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    this.iconUrl,
    this.color,
    this.sortOrder = 0,
    this.isEmergency = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
    id:          j['id'] as String,
    slug:        j['slug'] as String,
    nameAr:      j['nameAr'] as String,
    nameEn:      j['nameEn'] as String? ?? '',
    iconUrl:     j['iconUrl'] as String?,
    color:       j['color'] as String?,
    sortOrder:   j['sortOrder'] as int? ?? 0,
    isEmergency: j['isEmergency'] as bool? ?? false,
  );
}

class ProductCardModel {
  final String id;
  final String slug;
  final String nameAr;
  final String nameEn;
  final double price;
  final double? originalPrice;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool hasFlashDeal;
  final DateTime? flashDealEndsAt;
  final String? vendorName;
  final int stock;

  const ProductCardModel({
    required this.id,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.rating = 0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.hasFlashDeal = false,
    this.flashDealEndsAt,
    this.vendorName,
    this.stock = 99,
  });

  double get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  bool get isOutOfStock => stock <= 0;

  factory ProductCardModel.fromJson(Map<String, dynamic> j) => ProductCardModel(
    id:            j['id'] as String,
    slug:          j['slug'] as String,
    nameAr:        j['nameAr'] as String,
    nameEn:        j['name'] as String? ?? '',
    price:         (j['price'] as num).toDouble(),
    originalPrice: (j['compareAtPrice'] as num?)?.toDouble(),
    imageUrl:      (j['images'] as List?)
        ?.firstWhere((i) => i['isMain'] == true, orElse: () => {'url': null})?['url'] as String?,
    rating:        (j['rating'] as num?)?.toDouble() ?? 0,
    reviewCount:   j['totalRatings'] as int? ?? 0,
    isFeatured:    j['isFeatured'] as bool? ?? false,
    hasFlashDeal:  j['flashDeal'] != null,
    flashDealEndsAt: j['flashDeal']?['endsAt'] != null
        ? DateTime.tryParse(j['flashDeal']['endsAt'] as String)
        : null,
    vendorName:    j['vendor']?['businessName'] as String?,
    stock:         j['stock'] as int? ?? 0,
  );
}

class ServiceCardModel {
  final String id;
  final String slug;
  final String nameAr;
  final String nameEn;
  final double basePrice;
  final String? imageUrl;
  final double rating;
  final int bookingCount;
  final String? categoryNameAr;
  final bool isEmergency;
  final String pricingType; // FIXED, HOURLY, DYNAMIC

  const ServiceCardModel({
    required this.id,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    required this.basePrice,
    this.imageUrl,
    this.rating = 0,
    this.bookingCount = 0,
    this.categoryNameAr,
    this.isEmergency = false,
    this.pricingType = 'FIXED',
  });

  factory ServiceCardModel.fromJson(Map<String, dynamic> j) => ServiceCardModel(
    id:              j['id'] as String,
    slug:            j['slug'] as String,
    nameAr:          j['nameAr'] as String,
    nameEn:          j['name'] as String? ?? '',
    basePrice:       (j['basePrice'] as num).toDouble(),
    imageUrl:        j['imageUrl'] as String?,
    rating:          (j['rating'] as num?)?.toDouble() ?? 0,
    bookingCount:    j['totalBookings'] as int? ?? 0,
    categoryNameAr:  j['category']?['nameAr'] as String?,
    isEmergency:     j['isEmergency'] as bool? ?? false,
    pricingType:     j['pricingType'] as String? ?? 'FIXED',
  );
}

class AdCardModel {
  final String id;
  final String slug;
  final String title;
  final double? price;
  final String? imageUrl;
  final String city;
  final DateTime createdAt;
  final bool isBoosted;
  final bool isFree;

  const AdCardModel({
    required this.id,
    required this.slug,
    required this.title,
    this.price,
    this.imageUrl,
    required this.city,
    required this.createdAt,
    this.isBoosted = false,
    this.isFree = false,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24)   return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7)     return 'منذ ${diff.inDays} يوم';
    return 'منذ ${diff.inDays ~/ 7} أسبوع';
  }

  factory AdCardModel.fromJson(Map<String, dynamic> j) => AdCardModel(
    id:        j['id'] as String,
    slug:      j['slug'] as String,
    title:     j['title'] as String,
    price:     (j['price'] as num?)?.toDouble(),
    imageUrl:  j['thumbnailUrl'] as String?,
    city:      j['city'] as String? ?? '',
    createdAt: DateTime.tryParse(j['createdAt'] as String) ?? DateTime.now(),
    isBoosted: j['isBoosted'] as bool? ?? false,
    isFree:    j['isFree'] as bool? ?? false,
  );
}

// Home sections aggregate model
class HomeData {
  final List<BannerModel>      banners;
  final List<CategoryModel>    ecommerceCategories;
  final List<CategoryModel>    serviceCategories;
  final List<ProductCardModel> flashDeals;
  final List<ProductCardModel> featuredProducts;
  final List<ProductCardModel> recommendations;
  final List<ServiceCardModel> featuredServices;
  final List<AdCardModel>      recentAds;

  const HomeData({
    this.banners              = const [],
    this.ecommerceCategories  = const [],
    this.serviceCategories    = const [],
    this.flashDeals           = const [],
    this.featuredProducts     = const [],
    this.recommendations      = const [],
    this.featuredServices     = const [],
    this.recentAds            = const [],
  });
}
