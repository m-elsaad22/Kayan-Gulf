import '../../../../../core/network/api_client.dart';
import '../../../../checkout/presentation/providers/checkout_providers.dart';
import '../models/order_models.dart';
import 'order_repository.dart';

class RemoteOrderRepository implements OrderRepository {
  const RemoteOrderRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<DeliveryAddress>> getAddresses() async {
    final json = await _client.getJson('/addresses');
    final items = json['items'] as List? ?? [];
    return items
        .map((e) => DeliveryAddress.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DeliveryAddress> createAddress(DeliveryAddress address) async {
    final json = await _client.postJson('/addresses', body: address.toJson());
    return DeliveryAddress.fromJson(json);
  }

  @override
  Future<OrderModel> placeOrder({
    required String addressId,
    required PaymentMethod paymentMethod,
    String? couponCode,
    bool agreeToTerms = true,
  }) async {
    final json = await _client.postJson(
      '/orders',
      body: {
        'addressId': addressId,
        'paymentMethod': paymentMethod.name,
        if (couponCode != null) 'couponCode': couponCode,
        'agreeToTerms': agreeToTerms,
      },
    );
    return OrderModel.fromJson(json);
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final json = await _client.getJson('/orders');
    final items = json['items'] as List? ?? [];
    return items
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrderModel> getOrder(String id) async {
    final json = await _client.getJson('/orders/$id');
    return OrderModel.fromJson(json);
  }

  @override
  Future<PaymentIntentResult> createPaymentIntent({
    required String orderId,
    required PaymentMethod paymentMethod,
  }) async {
    final json = await _client.postJson(
      '/payments/intent',
      body: {
        'orderId': orderId,
        'paymentMethod': paymentMethod.name,
      },
    );
    return PaymentIntentResult.fromJson(json);
  }

  @override
  Future<PaymentIntentResult> confirmPayment({
    required String orderId,
    required String providerRef,
  }) async {
    final json = await _client.postJson(
      '/payments/confirm',
      body: {
        'orderId': orderId,
        'providerRef': providerRef,
      },
    );
    return PaymentIntentResult.fromJson(json);
  }
}
