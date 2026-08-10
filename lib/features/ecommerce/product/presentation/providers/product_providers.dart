// ============================================================
// KAYAN — Product & Cart Providers
// lib/features/ecommerce/product/presentation/providers/product_providers.dart
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/app_config.dart';
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
  final String?  lastError;
  /// Prefer server totals when cart is synced with API.
  final CartSummary? serverSummary;

  const CartState({
    this.items            = const [],
    this.couponCode,
    this.couponDiscount   = 0,
    this.isApplyingCoupon = false,
    this.couponError,
    this.isLoading        = false,
    this.lastError,
    this.serverSummary,
  });

  CartSummary get summary {
    if (serverSummary != null) return serverSummary!;
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
    String?              lastError,
    CartSummary?         serverSummary,
    bool                 clearCouponError = false,
    bool                 clearLastError = false,
    bool                 clearServerSummary = false,
  }) => CartState(
    items:            items             ?? this.items,
    couponCode:       couponCode        ?? this.couponCode,
    couponDiscount:   couponDiscount    ?? this.couponDiscount,
    isApplyingCoupon: isApplyingCoupon  ?? this.isApplyingCoupon,
    couponError:      clearCouponError  ? null : (couponError ?? this.couponError),
    isLoading:        isLoading         ?? this.isLoading,
    lastError:        clearLastError    ? null : (lastError ?? this.lastError),
    serverSummary:    clearServerSummary
        ? null
        : (serverSummary ?? this.serverSummary),
  );
}

// ──────────────────────────────────────────────────────────────
// CART NOTIFIER
// ──────────────────────────────────────────────────────────────

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    if (!AppConfig.useMockData) {
      Future.microtask(load);
      return const CartState(isLoading: true);
    }
    return CartState(items: _mockCartItems());
  }

  void _applySnapshot(CartSnapshot snap) {
    state = CartState(
      items: snap.items,
      couponCode: snap.summary.couponCode,
      couponDiscount: snap.summary.couponDiscount,
      serverSummary: snap.summary,
    );
  }

  Future<void> load() async {
    if (AppConfig.useMockData) return;
    state = state.copyWith(isLoading: true, clearLastError: true);
    try {
      final snap = await ref.read(cartRepositoryProvider).getCart();
      _applySnapshot(snap);
    } catch (e) {
      if (kDebugMode) debugPrint('cart load failed: $e');
      state = state.copyWith(
        isLoading: false,
        lastError: e.toString(),
        items: const [],
        clearServerSummary: true,
      );
    }
  }

  Future<void> addItem(CartItemModel item) async {
    if (AppConfig.useMockData) {
      final idx = state.items.indexWhere((i) => i.productId == item.productId);
      if (idx >= 0) {
        final updated = List<CartItemModel>.from(state.items);
        final existing = updated[idx];
        final newQty =
            (existing.quantity + item.quantity).clamp(1, existing.maxStock);
        updated[idx] = existing.copyWith(quantity: newQty);
        state = state.copyWith(items: updated);
      } else {
        state = state.copyWith(items: [...state.items, item]);
      }
      return;
    }

    try {
      final snap = await ref.read(cartRepositoryProvider).addItem(
            productId: item.productId,
            quantity: item.quantity,
            selectedColor: item.selectedColor,
            selectedSize: item.selectedSize,
          );
      _applySnapshot(snap);
    } catch (e) {
      state = state.copyWith(lastError: e.toString());
      rethrow;
    }
  }

  Future<void> updateQuantity(String cartItemId, int qty) async {
    if (AppConfig.useMockData) {
      final updated = state.items
          .map(
            (i) => i.cartItemId == cartItemId
                ? i.copyWith(quantity: qty.clamp(1, i.maxStock))
                : i,
          )
          .toList();
      state = state.copyWith(items: updated);
      return;
    }
    final snap =
        await ref.read(cartRepositoryProvider).updateQuantity(cartItemId, qty);
    _applySnapshot(snap);
  }

  Future<void> removeItem(String cartItemId) async {
    if (AppConfig.useMockData) {
      state = state.copyWith(
        items: state.items.where((i) => i.cartItemId != cartItemId).toList(),
      );
      return;
    }
    final snap = await ref.read(cartRepositoryProvider).removeItem(cartItemId);
    _applySnapshot(snap);
  }

  Future<void> applyCoupon(String code) async {
    state = state.copyWith(isApplyingCoupon: true, clearCouponError: true);
    if (AppConfig.useMockData) {
      await Future.delayed(const Duration(seconds: 1));
      if (code.toUpperCase() == 'KAYAN10') {
        final discount = state.summary.subtotal * 0.10;
        state = state.copyWith(
          isApplyingCoupon: false,
          couponCode: code.toUpperCase(),
          couponDiscount: discount,
        );
      } else if (code.toUpperCase() == 'KAYAN50') {
        state = state.copyWith(
          isApplyingCoupon: false,
          couponCode: code.toUpperCase(),
          couponDiscount: 50,
        );
      } else {
        state = state.copyWith(
          isApplyingCoupon: false,
          couponError: 'كود الخصم غير صحيح أو منتهي الصلاحية',
        );
      }
      return;
    }

    try {
      final snap = await ref.read(cartRepositoryProvider).applyCoupon(code);
      _applySnapshot(snap);
      state = state.copyWith(isApplyingCoupon: false);
    } catch (e) {
      state = state.copyWith(
        isApplyingCoupon: false,
        couponError: 'كود الخصم غير صحيح أو منتهي الصلاحية',
      );
    }
  }

  Future<void> removeCoupon() async {
    if (AppConfig.useMockData) {
      state = state.copyWith(
        couponCode: '',
        couponDiscount: 0,
        clearCouponError: true,
      );
      return;
    }
    final snap = await ref.read(cartRepositoryProvider).removeCoupon();
    _applySnapshot(snap);
  }

  Future<void> clear() async {
    if (AppConfig.useMockData) {
      state = const CartState();
      return;
    }
    try {
      final snap = await ref.read(cartRepositoryProvider).clear();
      _applySnapshot(snap);
    } catch (_) {
      state = const CartState();
    }
  }
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
