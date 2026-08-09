import '../../../product/data/models/product_models.dart';

abstract class CartRepository {
  Future<CartSnapshot> getCart();

  Future<CartSnapshot> addItem({
    required String productId,
    int quantity = 1,
    String? selectedColor,
    String? selectedSize,
  });

  Future<CartSnapshot> updateQuantity(String cartItemId, int quantity);

  Future<CartSnapshot> removeItem(String cartItemId);

  Future<CartSnapshot> clear();

  Future<CartSnapshot> applyCoupon(String code);

  Future<CartSnapshot> removeCoupon();
}
