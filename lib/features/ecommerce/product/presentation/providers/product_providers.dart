// ============================================================
// KAYAN — Product & Cart Providers
// lib/features/ecommerce/product/presentation/providers/product_providers.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/repository_providers.dart';
import '../../../../../features/home/data/models/home_models.dart';
import '../../data/models/product_models.dart';
import '../../domain/product_filter.dart';

export '../../domain/product_filter.dart';

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
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProducts(filter);
});

// ──────────────────────────────────────────────────────────────
// PRODUCT DETAIL PROVIDER
// ──────────────────────────────────────────────────────────────

final productDetailProvider = FutureProvider.autoDispose
    .family<ProductDetailModel, String>((ref, slug) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductDetail(slug);
});

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
