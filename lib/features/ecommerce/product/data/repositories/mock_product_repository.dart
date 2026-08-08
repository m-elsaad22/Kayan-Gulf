import '../../../../../core/services/admin_data_service.dart';
import '../../../../home/data/models/home_models.dart';
import '../../data/models/product_models.dart';
import '../../domain/product_filter.dart';
import 'product_repository.dart';

/// Local mock implementation — swap for [RemoteProductRepository] when API is ready.
class MockProductRepository implements ProductRepository {
  const MockProductRepository();

  @override
  Future<List<ProductCardModel>> getProducts(ProductFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProducts(filter);
  }

  @override
  Future<ProductDetailModel> getProductDetail(String slug) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _productDetailFromAdmin(slug);
  }
}

List<ProductCardModel> _mockProducts(ProductFilter f) {
  final adminProducts = AdminDataService.instance.getProducts();
  final all = adminProducts
      .where((p) => p.isActive)
      .map(
        (p) => ProductCardModel(
          id: p.id,
          slug: p.id,
          nameAr: p.titleAr,
          nameEn: p.titleEn,
          price: p.salePrice,
          originalPrice: p.originalPrice > p.salePrice ? p.originalPrice : null,
          imageUrl: p.imageUrl,
          rating: p.rating,
          reviewCount: 20 + p.id.hashCode.abs() % 200,
          isFeatured: p.isFeatured,
          stock: 10 + p.id.hashCode.abs() % 50,
        ),
      )
      .toList();

  var filtered = all.where((p) {
    if (f.minPrice != null && p.price < f.minPrice!) return false;
    if (f.maxPrice != null && p.price > f.maxPrice!) return false;
    if (f.inStockOnly && p.isOutOfStock) return false;
    if (f.onSaleOnly && p.originalPrice == null) return false;
    if (f.minRating != null && p.rating < f.minRating!) return false;
    if (f.categorySlug != null && f.categorySlug!.isNotEmpty) {
      final product = adminProducts.firstWhere(
        (ap) => ap.id == p.id,
        orElse: () => adminProducts.first,
      );
      if (product.categoryId != f.categorySlug) return false;
    }
    if (f.search != null && f.search!.isNotEmpty) {
      final q = f.search!.toLowerCase();
      if (!p.nameAr.contains(q) && !p.nameEn.toLowerCase().contains(q)) {
        return false;
      }
    }
    return true;
  }).toList();

  switch (f.sort) {
    case SortOption.priceAsc:
      filtered.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceDesc:
      filtered.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.topRated:
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    default:
      break;
  }

  final start = (f.page - 1) * 12;
  final end = (start + 12).clamp(0, filtered.length);
  return start >= filtered.length ? [] : filtered.sublist(start, end);
}

ProductDetailModel _productDetailFromAdmin(String slug) {
  final products = AdminDataService.instance.getProducts();
  final match = products.where((p) => p.id == slug).firstOrNull;
  if (match != null) {
    final reviewCount = 20 + match.id.hashCode.abs() % 200;
    return ProductDetailModel(
      id: match.id,
      slug: match.id,
      nameAr: match.titleAr,
      nameEn: match.titleEn,
      descriptionAr: match.descriptionAr,
      descriptionEn: match.titleEn,
      price: match.salePrice,
      compareAtPrice:
          match.originalPrice > match.salePrice ? match.originalPrice : null,
      currency: 'SAR',
      stock: 10 + match.id.hashCode.abs() % 50,
      isFeatured: match.isFeatured,
      freeShipping: match.salePrice >= 200,
      deliveryDays: 2,
      rating: match.rating,
      totalRatings: reviewCount,
      ratingSummary: RatingSummary(
        avgRating: match.rating,
        totalReviews: reviewCount,
        breakdown: {
          5: (reviewCount * 0.7).round(),
          4: (reviewCount * 0.2).round(),
          3: (reviewCount * 0.07).round(),
          2: (reviewCount * 0.02).round(),
          1: (reviewCount * 0.01).round(),
        },
      ),
      images: [
        ProductImage(
          id: '1',
          url: match.imageUrl,
          isMain: true,
          sortOrder: 0,
        ),
      ],
      vendorName: 'متجر كيان',
      vendorSlug: 'kayan-store',
      tags: [match.categoryId],
    );
  }
  return _fallbackProductDetail(slug);
}

ProductDetailModel _fallbackProductDetail(String slug) => ProductDetailModel(
      id: 'detail-$slug',
      slug: slug,
      nameAr: 'سماعات سوني WH-1000XM5 اللاسلكية بإلغاء الضوضاء',
      nameEn: 'Sony WH-1000XM5 Wireless Noise Cancelling Headphones',
      descriptionAr:
          'سماعات رأس لاسلكية فائقة الجودة مع تقنية إلغاء الضوضاء الاحترافية. '
          'بطارية تدوم حتى 30 ساعة متواصلة، وتصميم أنيق خفيف الوزن. '
          'جودة صوت استثنائية مع برنامج LDAC لصوت عالي الدقة. '
          'مثالية للعمل من المنزل والسفر والاستماع اليومي.',
      descriptionEn:
          'Industry-leading noise canceling headphones with Auto NC Optimizer. '
          '30-hour battery life, lightweight design, and exceptional sound quality.',
      price: 1299,
      compareAtPrice: 1899,
      currency: 'SAR',
      stock: 15,
      isFeatured: true,
      freeShipping: true,
      deliveryDays: 2,
      rating: 4.7,
      totalRatings: 847,
      ratingSummary: const RatingSummary(
        avgRating: 4.7,
        totalReviews: 847,
        breakdown: {5: 612, 4: 158, 3: 52, 2: 18, 1: 7},
      ),
      images: [
        const ProductImage(
          id: '1',
          url: 'https://picsum.photos/600/600?random=71',
          isMain: true,
          sortOrder: 0,
        ),
        const ProductImage(
          id: '2',
          url: 'https://picsum.photos/600/600?random=72',
          sortOrder: 1,
        ),
        const ProductImage(
          id: '3',
          url: 'https://picsum.photos/600/600?random=73',
          sortOrder: 2,
        ),
        const ProductImage(
          id: '4',
          url: 'https://picsum.photos/600/600?random=74',
          sortOrder: 3,
        ),
      ],
      colorOptions: const [
        VariantOption(
          id: 'c1',
          type: 'color',
          valueAr: 'أسود',
          valueEn: 'Black',
          colorHex: '#1A1A1A',
          stock: 10,
          isAvailable: true,
        ),
        VariantOption(
          id: 'c2',
          type: 'color',
          valueAr: 'فضي',
          valueEn: 'Silver',
          colorHex: '#C0C0C0',
          stock: 5,
          isAvailable: true,
        ),
        VariantOption(
          id: 'c3',
          type: 'color',
          valueAr: 'أزرق',
          valueEn: 'Blue',
          colorHex: '#4169E1',
          stock: 0,
          isAvailable: false,
        ),
      ],
      modelOptions: const [
        VariantOption(
          id: 'm1',
          type: 'model',
          valueAr: 'XM5 Standard',
          valueEn: 'XM5 Standard',
          stock: 10,
        ),
        VariantOption(
          id: 'm2',
          type: 'model',
          valueAr: 'XM5 Pro',
          valueEn: 'XM5 Pro',
          stock: 5,
          priceModifier: 200,
        ),
      ],
      vendorName: 'متجر سوني الرسمي',
      vendorSlug: 'sony-official',
      tags: ['سماعات', 'سوني', 'لاسلكية', 'بلوتوث'],
      reviews: [
        ReviewModel(
          id: 'r1',
          userFirstName: 'محمد',
          rating: 5.0,
          comment:
              'منتج رائع، جودة صوت ممتازة وإلغاء ضوضاء مذهل. أنصح به بشدة.',
          isVerifiedPurchase: true,
          helpfulCount: 42,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ReviewModel(
          id: 'r2',
          userFirstName: 'فاطمة',
          rating: 4.5,
          comment: 'جودة عالية جداً، البطارية تدوم وقت طويل. التغليف ممتاز.',
          isVerifiedPurchase: true,
          helpfulCount: 28,
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
        ReviewModel(
          id: 'r3',
          userFirstName: 'أحمد',
          rating: 4.0,
          comment: 'ممتاز لكن السعر مرتفع قليلاً. جودة الصوت لا تُضاهى.',
          isVerifiedPurchase: false,
          helpfulCount: 15,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
      upsells: const [
        ProductCardSimple(
          id: 'u1',
          slug: 'sony-earbuds',
          nameAr: 'سماعات سوني TWS',
          imageUrl: 'https://picsum.photos/200?random=81',
          price: 499,
          rating: 4.5,
        ),
        ProductCardSimple(
          id: 'u2',
          slug: 'sony-speaker',
          nameAr: 'سبيكر سوني محمول',
          imageUrl: 'https://picsum.photos/200?random=82',
          price: 349,
          rating: 4.3,
        ),
        ProductCardSimple(
          id: 'u3',
          slug: 'headphone-stand',
          nameAr: 'حامل سماعات',
          imageUrl: 'https://picsum.photos/200?random=83',
          price: 89,
          rating: 4.1,
        ),
        ProductCardSimple(
          id: 'u4',
          slug: 'audio-cable',
          nameAr: 'كابل صوت 3.5mm',
          imageUrl: 'https://picsum.photos/200?random=84',
          price: 29,
          rating: 4.0,
        ),
      ],
    );
