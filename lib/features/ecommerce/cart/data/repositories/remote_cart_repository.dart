import '../../../../../core/network/api_client.dart';
import '../../../product/data/models/product_models.dart';
import 'cart_repository.dart';

class RemoteCartRepository implements CartRepository {
  const RemoteCartRepository(this._client);

  final ApiClient _client;

  @override
  Future<CartSnapshot> getCart() async {
    final json = await _client.getJson('/cart');
    return CartSnapshot.fromJson(json);
  }

  @override
  Future<CartSnapshot> addItem({
    required String productId,
    int quantity = 1,
    String? selectedColor,
    String? selectedSize,
  }) async {
    final json = await _client.postJson(
      '/cart/items',
      body: {
        'productId': productId,
        'quantity': quantity,
        if (selectedColor != null) 'selectedColor': selectedColor,
        if (selectedSize != null) 'selectedSize': selectedSize,
      },
    );
    return CartSnapshot.fromJson(json);
  }

  @override
  Future<CartSnapshot> updateQuantity(String cartItemId, int quantity) async {
    final json = await _client.patchJson(
      '/cart/items/$cartItemId',
      body: {'quantity': quantity},
    );
    return CartSnapshot.fromJson(json);
  }

  @override
  Future<CartSnapshot> removeItem(String cartItemId) async {
    final json = await _client.deleteJson('/cart/items/$cartItemId');
    return CartSnapshot.fromJson(json);
  }

  @override
  Future<CartSnapshot> clear() async {
    final json = await _client.deleteJson('/cart');
    return CartSnapshot.fromJson(json);
  }

  @override
  Future<CartSnapshot> applyCoupon(String code) async {
    final json = await _client.postJson(
      '/cart/coupon',
      body: {'code': code},
    );
    return CartSnapshot.fromJson(json);
  }

  @override
  Future<CartSnapshot> removeCoupon() async {
    final json = await _client.deleteJson('/cart/coupon');
    return CartSnapshot.fromJson(json);
  }
}
