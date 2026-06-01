// ============================================================
// KAYAN — Home Screen Providers
// lib/features/home/presentation/providers/home_providers.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/home_models.dart';

// ──────────────────────────────────────────────────────────────
// HOME DATA PROVIDER
// Fetches all home sections in parallel.
// Returns mock data until API is wired up.
// ──────────────────────────────────────────────────────────────

final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  // TODO: inject HomeRepository and call API
  // final repo = ref.read(homeRepositoryProvider);
  // return repo.getHomeData();
  await Future.delayed(const Duration(milliseconds: 600));
  return _mockHomeData();
});

// ──────────────────────────────────────────────────────────────
// MOCK DATA — remove when API is ready
// ──────────────────────────────────────────────────────────────

HomeData _mockHomeData() => HomeData(
  banners: [
    BannerModel(
      id: '1',
      imageUrl: 'https://picsum.photos/800/400?random=1',
      titleAr: 'خصومات تصل إلى ٥٠٪',
      titleEn: 'Up to 50% Off',
      subtitleAr: 'على آلاف المنتجات',
      subtitleEn: 'On thousands of products',
      actionRoute: '/shop/flash-deals',
    ),
    BannerModel(
      id: '2',
      imageUrl: 'https://picsum.photos/800/400?random=2',
      titleAr: 'خدمات منزلية',
      titleEn: 'Home Services',
      subtitleAr: '٢٤/٧ فنيون معتمدون',
      subtitleEn: '24/7 Certified Technicians',
      actionRoute: '/services',
    ),
    BannerModel(
      id: '3',
      imageUrl: 'https://picsum.photos/800/400?random=3',
      titleAr: 'إعلانك هنا',
      titleEn: 'Advertise Here',
      subtitleAr: 'انشر إعلانك مجاناً',
      subtitleEn: 'Post your ad for free',
      actionRoute: '/classifieds/post',
    ),
  ],
  ecommerceCategories: [
    CategoryModel(id: '1', slug: 'electronics', nameAr: 'إلكترونيات', nameEn: 'Electronics', color: '#4169E1'),
    CategoryModel(id: '2', slug: 'fashion',     nameAr: 'أزياء',       nameEn: 'Fashion',      color: '#EC4899'),
    CategoryModel(id: '3', slug: 'home',        nameAr: 'المنزل',      nameEn: 'Home',         color: '#10B981'),
    CategoryModel(id: '4', slug: 'beauty',      nameAr: 'جمال',        nameEn: 'Beauty',       color: '#F97316'),
    CategoryModel(id: '5', slug: 'sports',      nameAr: 'رياضة',       nameEn: 'Sports',       color: '#6366F1'),
    CategoryModel(id: '6', slug: 'toys',        nameAr: 'ألعاب',       nameEn: 'Toys',         color: '#F59E0B'),
    CategoryModel(id: '7', slug: 'food',        nameAr: 'طعام',        nameEn: 'Food',         color: '#14B8A6'),
    CategoryModel(id: '8', slug: 'automotive',  nameAr: 'سيارات',      nameEn: 'Automotive',   color: '#64748B'),
  ],
  serviceCategories: [
    CategoryModel(id: 's1', slug: 'plumbing',  nameAr: 'سباكة',     nameEn: 'Plumbing',   color: '#3B82F6'),
    CategoryModel(id: 's2', slug: 'electrical',nameAr: 'كهرباء',    nameEn: 'Electrical', color: '#F59E0B', isEmergency: true),
    CategoryModel(id: 's3', slug: 'ac',        nameAr: 'تكييف',     nameEn: 'AC',         color: '#06B6D4'),
    CategoryModel(id: 's4', slug: 'cleaning',  nameAr: 'تنظيف',     nameEn: 'Cleaning',   color: '#10B981'),
    CategoryModel(id: 's5', slug: 'painting',  nameAr: 'دهان',      nameEn: 'Painting',   color: '#8B5CF6'),
    CategoryModel(id: 's6', slug: 'movers',    nameAr: 'نقل عفش',   nameEn: 'Movers',     color: '#F97316'),
  ],
  flashDeals: List.generate(6, (i) => ProductCardModel(
    id: 'fd$i', slug: 'flash-$i',
    nameAr: ['سماعات سوني', 'جوال سامسونج', 'لابتوب آبل', 'ساعة ذكية', 'تابلت', 'كاميرا'][i],
    nameEn: ['Sony Headphones', 'Samsung Phone', 'Apple Laptop', 'Smart Watch', 'Tablet', 'Camera'][i],
    price: [299, 1899, 4999, 799, 1299, 999][i].toDouble(),
    originalPrice: [599, 2999, 7999, 1299, 1999, 1599][i].toDouble(),
    imageUrl: 'https://picsum.photos/300/300?random=${i + 10}',
    rating: 4.2 + i * 0.1,
    reviewCount: 120 + i * 30,
    hasFlashDeal: true,
    flashDealEndsAt: DateTime.now().add(Duration(hours: 2 + i)),
    stock: 5 + i,
  )),
  featuredProducts: List.generate(8, (i) => ProductCardModel(
    id: 'fp$i', slug: 'product-$i',
    nameAr: 'منتج مميز ${i + 1}',
    nameEn: 'Featured Product ${i + 1}',
    price: 100.0 + i * 50,
    originalPrice: i % 2 == 0 ? 150.0 + i * 50 : null,
    imageUrl: 'https://picsum.photos/300/300?random=${i + 20}',
    rating: 3.8 + i * 0.15,
    reviewCount: 40 + i * 10,
    isFeatured: true,
  )),
  recommendations: List.generate(8, (i) => ProductCardModel(
    id: 'rec$i', slug: 'rec-product-$i',
    nameAr: 'مقترح لك ${i + 1}',
    nameEn: 'Recommended ${i + 1}',
    price: 80.0 + i * 40,
    imageUrl: 'https://picsum.photos/300/300?random=${i + 30}',
    rating: 4.0 + i * 0.1,
    reviewCount: 20 + i * 5,
  )),
  featuredServices: List.generate(4, (i) => ServiceCardModel(
    id: 'svc$i', slug: 'service-$i',
    nameAr: ['تركيب تكييف', 'تسليك مجاري', 'دهان منزل', 'نظافة شاملة'][i],
    nameEn: ['AC Installation', 'Drain Cleaning', 'House Painting', 'Deep Cleaning'][i],
    basePrice: [150, 80, 500, 200][i].toDouble(),
    imageUrl: 'https://picsum.photos/300/200?random=${i + 40}',
    rating: 4.3 + i * 0.1,
    bookingCount: 200 + i * 50,
    categoryNameAr: ['تكييف', 'سباكة', 'دهان', 'تنظيف'][i],
  )),
  recentAds: List.generate(6, (i) => AdCardModel(
    id: 'ad$i', slug: 'ad-$i',
    title: ['آيفون ١٥ برو', 'سيارة كامري', 'شقة للإيجار', 'أريكة جديدة', 'لابتوب ديل', 'دراجة هوائية'][i],
    price: [3200, 45000, 3500, 800, 1200, 350][i].toDouble(),
    imageUrl: 'https://picsum.photos/300/200?random=${i + 50}',
    city: ['الرياض', 'جدة', 'أبوظبي', 'دبي', 'الدوحة', 'الرياض'][i],
    createdAt: DateTime.now().subtract(Duration(hours: i * 3 + 1)),
    isBoosted: i % 3 == 0,
  )),
);
