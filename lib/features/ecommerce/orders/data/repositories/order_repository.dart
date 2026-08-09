import '../../../../checkout/presentation/providers/checkout_providers.dart';
import '../models/order_models.dart';

abstract class OrderRepository {
  Future<List<DeliveryAddress>> getAddresses();

  Future<DeliveryAddress> createAddress(DeliveryAddress address);

  Future<OrderModel> placeOrder({
    required String addressId,
    required PaymentMethod paymentMethod,
    String? couponCode,
    bool agreeToTerms = true,
  });

  Future<List<OrderModel>> getOrders();

  Future<OrderModel> getOrder(String id);

  Future<PaymentIntentResult> createPaymentIntent({
    required String orderId,
    required PaymentMethod paymentMethod,
  });

  Future<PaymentIntentResult> confirmPayment({
    required String orderId,
    required String providerRef,
  });
}
