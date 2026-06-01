// ============================================================
// KAYAN — Product & Cart Providers
// lib/features/ecommerce/product/presentation/providers/product_providers.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_models.dart';
import '../../../../../features/home/data/models/home_models.dart';

// ──────────────────────────────────────────────────────────────
// FILTER STATE
// ──────────────────────────────────────────────────────────────

enum SortOption {
  newest, priceAsc, priceDesc, topRated, bestSeller
}

class ProductFilter {
  final String?  categorySlug;
  final String?  search;
  final double?  minPrice;
  final double?  maxPrice;
  final double?  minRating;
  final SortOption sort;
  final bool     inStockOnly;
  final bool     onSaleOnly;
  final int      page;

  const ProductFilter({
    this.categorySlug,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sort       = SortOption.newest,
    this.inStockOnly = false,
    this.onSaleOnly  = false,
    this.page       = 1,
  });

  ProductFilter copyWith({
    String?     categorySlug,
    String?     search,
    double?     minPrice,
    double?     maxPrice,
    double?     minRating,
    SortOption? sort,
    bool?       inStockOnly,
    bool?       onSaleOnly,
    int?        page,
  }) => ProductFilter(
    categorySlug: categorySlug ?? this.categorySlug,
    search:       search       ?? this.search,
    minPrice:     minPrice     ?? this.minPrice,
    maxPrice:     maxPrice     ?? this.maxPrice,
    minRating:    minRating    ?? this.minRating,
    sort:         sort         ?? this.sort,
    inStockOnly:  inStockOnly  ?? this.inStockOnly,
    onSaleOnly:   onSaleOnly   ?? this.onSaleOnly,
    page:         page         ?? this.page,
  );

  bool get hasActiveFilters =>
      minPrice != null || maxPrice != null || minRating != null ||
      inStockOnly || onSaleOnly || sort != SortOption.newest;

  int get activeFilterCount {
    int count = 0;
    if (minPrice != null || maxPrice != null) count++;
    if (minRating != null) count++;
    if (inStockOnly) count++;
    if (onSaleOnly)  count++;
    if (sort != SortOption.newest) count++;
    return count;
  }
}

// ──────────────────────────────────────────────────────────────
// FILTER NOTIFIER
// ──────────────────────────────────────────────────────────────

class ProductFilterNotifier extends Notifier<ProductFilter> {
  @override
  ProductFilter build() => const ProductFilter();

  void setCategory(String? slug) =>
      state = state.copyWith(categorySlug: slug, page: 1);

  void setSearch(String? q) =>
      state = state.copyWith(search: q, page: 1);

  void setSort(SortOption sort) =>
      state = state.copyWith(sort: sort, page: 1);

  void setPriceRange(double? min, double? max) =>
      state = state.copyWith(minPrice: min, maxPrice: max, page: 1);

  void setMinRating(double? r) =>
      state = state.copyWith(minRating: r, page: 1);

  void toggleInStock() =>
      state = state.copyWith(inStockOnly: !state.inStockOnly, page: 1);

  void toggleOnSale() =>
      state = state.copyWith(onSaleOnly: !state.onSaleOnly, page: 1);

  void nextPage() => state = state.copyWith(page: state.page + 1);

  void reset() => state = ProductFilter(categorySlug: state.categorySlug);
}

final productFilterProvider =
    NotifierProvider<ProductFilterNotifier, ProductFilter>(
        ProductFilterNotifier.new);

// ──────────────────────────────────────────────────────────────
// PRODUCT LIST PROVIDER
// ──────────────────────────────────────────────────────────────

final productListProvider =
    FutureProvider.autoDispose<List<ProductCardModel>>((ref) async {
  final filter = ref.watch(productFilterProvider);
  // TODO: inject ProductRepository
  await Future.delayed(const Duration(milliseconds: 500));
  return _mockProducts(filter);
});

List<ProductCardModel> _mockProducts(ProductFilter f) {
  final all = List.generate(24, (i) => ProductCardModel(
    id:            'p$i',
    slug:          'product-$i',
    nameAr:        _arabicNames[i % _arabicNames.length],
    nameEn:        'Product ${i + 1}',
    price:         (100 + i * 45).toDouble(),
    originalPrice: i % 3 == 0 ? (150 + i * 45).toDouble() : null,
    imageUrl:      'https://picsum.photos/300/300?random=${i + 60}',
    rating:        3.5 + (i % 5) * 0.3,
    reviewCount:   20 + i * 7,
    isFeatured:    i % 5 == 0,
    stock:         i % 7 == 0 ? 0 : 10 + i,
  ));

  var filtered = all.where((p) {
    if (f.minPrice != null && p.price < f.minPrice!) return false;
    if (f.maxPrice != null && p.price > f.maxPrice!) return false;
    if (f.inStockOnly && p.isOutOfStock) return false;
    if (f.onSaleOnly && p.originalPrice == null) return false;
    if (f.minRating != null && p.rating < f.minRating!) return false;
    if (f.search != null && f.search!.isNotEmpty) {
      final q = f.search!.toLowerCase();
      if (!p.nameAr.contains(q) && !p.nameEn.toLowerCase().contains(q)) {
        return false;
      }
    }
    return true;
  }).toList();

  switch (f.sort) {
    case SortOption.priceAsc:  filtered.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceDesc: filtered.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.topRated:  filtered.sort((a, b) => b.rating.compareTo(a.rating));
    default: break;
  }

  final start = (f.page - 1) * 12;
  final end   = (start + 12).clamp(0, filtered.length);
  return start >= filtered.length ? [] : filtered.sublist(start, end);
}

const _arabicNames = [
  'سماعات لاسلكية فاخرة',
  'جوال سامسونج جالاكسي',
  'لابتوب آبل ماك بوك',
  'ساعة ذكية سيلفر',
  'تابلت iPad Pro',
  'كاميرا كانون احترافية',
  'شاشة 4K Ultra HD',
  'مكيف سبليت انفرتر',
  'ثلاجة ستانلس ستيل',
  'غسالة أتوماتيك',
  'مكنسة روبوت ذكية',
  'طقم أواني مطبخ',
];

// ──────────────────────────────────────────────────────────────
// PRODUCT DETAIL PROVIDER
// ──────────────────────────────────────────────────────────────

final productDetailProvider = FutureProvider.autoDispose
    .family<ProductDetailModel, String>((ref, slug) async {
  await Future.delayed(const Duration(milliseconds: 700));
  return _mockProductDetail(slug);
});

ProductDetailModel _mockProductDetail(String slug) => ProductDetailModel(
  id:            'detail-$slug',
  slug:          slug,
  nameAr:        'سماعات سوني WH-1000XM5 اللاسلكية بإلغاء الضوضاء',
  nameEn:        'Sony WH-1000XM5 Wireless Noise Cancelling Headphones',
  descriptionAr: 'سماعات رأس لاسلكية فائقة الجودة مع تقنية إلغاء الضوضاء الاحترافية. '
      'بطارية تدوم حتى 30 ساعة متواصلة، وتصميم أنيق خفيف الوزن. '
      'جودة صوت استثنائية مع برنامج LDAC لصوت عالي الدقة. '
      'مثالية للعمل من المنزل والسفر والاستماع اليومي.',
  descriptionEn: 'Industry-leading noise canceling headphones with Auto NC Optimizer. '
      '30-hour battery life, lightweight design, and exceptional sound quality.',
  price:         1299,
  compareAtPrice: 1899,
  currency:      'SAR',
  stock:         15,
  isFeatured:    true,
  freeShipping:  true,
  deliveryDays:  2,
  rating:        4.7,
  totalRatings:  847,
  ratingSummary: const RatingSummary(
    avgRating:    4.7,
    totalReviews: 847,
    breakdown:    {5: 612, 4: 158, 3: 52, 2: 18, 1: 7},
  ),
  images: [
    const ProductImage(id: '1', url: 'https://picsum.photos/600/600?random=71', isMain: true, sortOrder: 0),
    const ProductImage(id: '2', url: 'https://picsum.photos/600/600?random=72', sortOrder: 1),
    const ProductImage(id: '3', url: 'https://picsum.photos/600/600?random=73', sortOrder: 2),
    const ProductImage(id: '4', url: 'https://picsum.photos/600/600?random=74', sortOrder: 3),
  ],
  colorOptions: const [
    VariantOption(id: 'c1', type: 'color', valueAr: 'أسود',  valueEn: 'Black',  colorHex: '#1A1A1A', stock: 10, isAvailable: true),
    VariantOption(id: 'c2', type: 'color', valueAr: 'فضي',   valueEn: 'Silver', colorHex: '#C0C0C0', stock: 5,  isAvailable: true),
    VariantOption(id: 'c3', type: 'color', valueAr: 'أزرق',  valueEn: 'Blue',   colorHex: '#4169E1', stock: 0,  isAvailable: false),
  ],
  modelOptions: const [
    VariantOption(id: 'm1', type: 'model', valueAr: 'XM5 Standard',  valueEn: 'XM5 Standard', stock: 10),
    VariantOption(id: 'm2', type: 'model', valueAr: 'XM5 Pro',       valueEn: 'XM5 Pro',      stock: 5, priceModifier: 200),
  ],
  vendorName: 'متجر سوني الرسمي',
  vendorSlug: 'sony-official',
  tags: ['سماعات', 'سوني', 'لاسلكية', 'بلوتوث'],
  reviews: [
    ReviewModel(
      id: 'r1',
      userFirstName: 'محمد',
      rating: 5.0,
      comment: 'منتج رائع، جودة صوت ممتازة وإلغاء ضوضاء مذهل. أنصح به بشدة.',
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
    ProductCardSimple(id: 'u1', slug: 'sony-earbuds',     nameAr: 'سماعات سوني TWS',    imageUrl: 'https://picsum.photos/200?random=81', price: 499, rating: 4.5),
    ProductCardSimple(id: 'u2', slug: 'sony-speaker',     nameAr: 'سبيكر سوني محمول',  imageUrl: 'https://picsum.photos/200?random=82', price: 349, rating: 4.3),
    ProductCardSimple(id: 'u3', slug: 'headphone-stand',  nameAr: 'حامل سماعات',        imageUrl: 'https://picsum.photos/200?random=83', price: 89,  rating: 4.1),
    ProductCardSimple(id: 'u4', slug: 'audio-cable',      nameAr: 'كابل صوت 3.5mm',     imageUrl: 'https://picsum.photos/200?random=84', price: 29,  rating: 4.0),
  ],
);

// ──────────────────────────────────────────────────────────────
// CART STATE
// ──────────────────────────────────────────────────────────────

class CartState {
  final List<CartItemModel> items;
  final String?  couponCode;
  final double   couponDiscount;
  final bool     isApplyingCoupon;
  final String?  couponError;
  final bool     isLoading;

  const CartState({
    this.items            = const [],
    this.couponCode,
    this.couponDiscount   = 0,
    this.isApplyingCoupon = false,
    this.couponError,
    this.isLoading        = false,
  });

  CartSummary get summary {
    final subtotal = items.fold(0.0, (s, i) => s + i.totalPrice);
    const vatRate  = 0.15; // 15% Saudi VAT
    final afterCoupon = (subtotal - couponDiscount).clamp(0, double.infinity);
    final shipping = afterCoupon >= 200 ? 0.0 : 25.0; // Free over 200 SAR
    final vat      = afterCoupon * vatRate;
    return CartSummary(
      subtotal:       subtotal,
      discount:       couponDiscount,
      shipping:       shipping,
      vat:            vat,
      total:          afterCoupon + shipping + vat,
      currency:       'SAR',
      couponCode:     couponCode,
      couponDiscount: couponDiscount,
      itemCount:      items.fold(0, (s, i) => s + i.quantity),
    );
  }

  CartState copyWith({
    List<CartItemModel>? items,
    String?              couponCode,
    double?              couponDiscount,
    bool?                isApplyingCoupon,
    String?              couponError,
    bool?                isLoading,
    bool                 clearCouponError = false,
  }) => CartState(
    items:            items             ?? this.items,
    couponCode:       couponCode        ?? this.couponCode,
    couponDiscount:   couponDiscount    ?? this.couponDiscount,
    isApplyingCoupon: isApplyingCoupon  ?? this.isApplyingCoupon,
    couponError:      clearCouponError  ? null : (couponError ?? this.couponError),
    isLoading:        isLoading         ?? this.isLoading,
  );
}

// ──────────────────────────────────────────────────────────────
// CART NOTIFIER
// ──────────────────────────────────────────────────────────────

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => CartState(items: _mockCartItems());

  // Add item
  void addItem(CartItemModel item) {
    final idx = state.items.indexWhere((i) => i.productId == item.productId);
    if (idx >= 0) {
      final updated = List<CartItemModel>.from(state.items);
      final existing = updated[idx];
      final newQty = (existing.quantity + item.quantity)
          .clamp(1, existing.maxStock);
      updated[idx] = existing.copyWith(quantity: newQty);
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  // Update quantity
  void updateQuantity(String cartItemId, int qty) {
    final updated = state.items.map((i) =>
        i.cartItemId == cartItemId
            ? i.copyWith(quantity: qty.clamp(1, i.maxStock))
            : i).toList();
    state = state.copyWith(items: updated);
  }

  // Remove item
  void removeItem(String cartItemId) {
    state = state.copyWith(
      items: state.items.where((i) => i.cartItemId != cartItemId).toList(),
    );
  }

  // Apply coupon
  Future<void> applyCoupon(String code) async {
    state = state.copyWith(isApplyingCoupon: true, clearCouponError: true);
    await Future.delayed(const Duration(seconds: 1));

    // Mock: KAYAN10 = 10%, KAYAN50 = fixed 50 SAR
    if (code.toUpperCase() == 'KAYAN10') {
      final discount = state.summary.subtotal * 0.10;
      state = state.copyWith(
        isApplyingCoupon: false,
        couponCode:       code.toUpperCase(),
        couponDiscount:   discount,
      );
    } else if (code.toUpperCase() == 'KAYAN50') {
      state = state.copyWith(
        isApplyingCoupon: false,
        couponCode:       code.toUpperCase(),
        couponDiscount:   50,
      );
    } else {
      state = state.copyWith(
        isApplyingCoupon: false,
        couponError:      'كود الخصم غير صحيح أو منتهي الصلاحية',
      );
    }
  }

  // Remove coupon
  void removeCoupon() {
    state = state.copyWith(
      couponCode:     '',
      couponDiscount: 0,
      clearCouponError: true,
    );
  }

  // Clear cart after checkout
  void clear() => state = const CartState();
}

final cartProvider =
    NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).summary.itemCount;
});

// Mock cart data
List<CartItemModel> _mockCartItems() => [
  const CartItemModel(
    cartItemId: 'ci1', productId: 'p1', slug: 'product-1',
    nameAr: 'سماعات سوني WH-1000XM5',
    nameEn:  'Sony WH-1000XM5',
    imageUrl: 'https://picsum.photos/200?random=71',
    unitPrice: 1299, quantity: 1,
    selectedColor: 'أسود', maxStock: 15,
  ),
  const CartItemModel(
    cartItemId: 'ci2', productId: 'p2', slug: 'product-2',
    nameAr: 'كابل USB-C أصلي',
    nameEn:  'Original USB-C Cable',
    imageUrl: 'https://picsum.photos/200?random=72',
    unitPrice: 49, quantity: 2, maxStock: 99,
  ),
];

// ──────────────────────────────────────────────────────────────
// SELECTED VARIANTS STATE
// ──────────────────────────────────────────────────────────────

class SelectedVariants {
  final String? colorId;
  final String? sizeId;
  final String? modelId;
  const SelectedVariants({this.colorId, this.sizeId, this.modelId});
  SelectedVariants copyWith({String? colorId, String? sizeId, String? modelId}) =>
      SelectedVariants(
        colorId: colorId ?? this.colorId,
        sizeId:  sizeId  ?? this.sizeId,
        modelId: modelId ?? this.modelId,
      );
}

final selectedVariantsProvider =
    StateProvider.autoDispose<SelectedVariants>((_) => const SelectedVariants());

// Favorites
final favoritesProvider = StateProvider<Set<String>>((_) => {});
