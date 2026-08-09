import '../../../product/data/models/product_models.dart';
import 'cart_repository.dart';

/// In-memory cart for mock mode — mirrors Nest pricing rules.
class MockCartRepository implements CartRepository {
  MockCartRepository();

  final List<CartItemModel> _items = [
    const CartItemModel(
      cartItemId: 'ci1',
      productId: 'p1',
      slug: 'sony-headphones',
      nameAr: 'سماعات سوني WH-1000XM5',
      nameEn: 'Sony WH-1000XM5',
      imageUrl: 'https://picsum.photos/200?random=71',
      unitPrice: 1299,
      quantity: 1,
      selectedColor: 'أسود',
      maxStock: 15,
    ),
  ];
  String? _couponCode;
  double _couponDiscount = 0;

  CartSnapshot _snapshot() {
    final subtotal = _items.fold(0.0, (s, i) => s + i.totalPrice);
    final after = (subtotal - _couponDiscount).clamp(0, double.infinity);
    final shipping = after >= 200 ? 0.0 : 25.0;
    final vat = after * 0.15;
    return CartSnapshot(
      items: List.unmodifiable(_items),
      summary: CartSummary(
        subtotal: subtotal,
        discount: _couponDiscount,
        shipping: shipping,
        vat: vat,
        total: after + shipping + vat,
        couponCode: _couponCode,
        couponDiscount: _couponDiscount,
        itemCount: _items.fold(0, (s, i) => s + i.quantity),
      ),
    );
  }

  @override
  Future<CartSnapshot> getCart() async => _snapshot();

  @override
  Future<CartSnapshot> addItem({
    required String productId,
    int quantity = 1,
    String? selectedColor,
    String? selectedSize,
  }) async {
    final idx = _items.indexWhere((i) => i.productId == productId);
    if (idx >= 0) {
      final e = _items[idx];
      _items[idx] = e.copyWith(
        quantity: (e.quantity + quantity).clamp(1, e.maxStock),
      );
    } else {
      _items.add(
        CartItemModel(
          cartItemId: 'ci-${DateTime.now().millisecondsSinceEpoch}',
          productId: productId,
          slug: productId,
          nameAr: 'منتج',
          nameEn: 'Product',
          unitPrice: 100,
          quantity: quantity,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
        ),
      );
    }
    return _snapshot();
  }

  @override
  Future<CartSnapshot> updateQuantity(String cartItemId, int quantity) async {
    final idx = _items.indexWhere((i) => i.cartItemId == cartItemId);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(
        quantity: quantity.clamp(1, _items[idx].maxStock),
      );
    }
    return _snapshot();
  }

  @override
  Future<CartSnapshot> removeItem(String cartItemId) async {
    _items.removeWhere((i) => i.cartItemId == cartItemId);
    return _snapshot();
  }

  @override
  Future<CartSnapshot> clear() async {
    _items.clear();
    _couponCode = null;
    _couponDiscount = 0;
    return _snapshot();
  }

  @override
  Future<CartSnapshot> applyCoupon(String code) async {
    final upper = code.toUpperCase();
    final subtotal = _items.fold(0.0, (s, i) => s + i.totalPrice);
    if (upper == 'KAYAN10') {
      _couponCode = upper;
      _couponDiscount = subtotal * 0.1;
    } else if (upper == 'KAYAN50') {
      _couponCode = upper;
      _couponDiscount = 50;
    } else {
      throw Exception('invalid_coupon');
    }
    return _snapshot();
  }

  @override
  Future<CartSnapshot> removeCoupon() async {
    _couponCode = null;
    _couponDiscount = 0;
    return _snapshot();
  }
}
