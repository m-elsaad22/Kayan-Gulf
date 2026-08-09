import '../../../../checkout/presentation/providers/checkout_providers.dart';
import '../models/order_models.dart';
import 'order_repository.dart';

class MockOrderRepository implements OrderRepository {
  final List<DeliveryAddress> _addresses = [
    const DeliveryAddress(
      id: 'addr-1',
      label: 'المنزل',
      recipientName: 'مستخدم كيان',
      phone: '+966500000001',
      country: 'SA',
      city: 'الرياض',
      district: 'العليا',
      streetLine1: 'طريق الملك فهد',
      isDefault: true,
    ),
  ];

  final List<OrderModel> _orders = [];

  @override
  Future<List<DeliveryAddress>> getAddresses() async =>
      List.unmodifiable(_addresses);

  @override
  Future<DeliveryAddress> createAddress(DeliveryAddress address) async {
    final created = DeliveryAddress(
      id: 'addr-${DateTime.now().millisecondsSinceEpoch}',
      label: address.label,
      recipientName: address.recipientName,
      phone: address.phone,
      country: address.country,
      city: address.city,
      district: address.district,
      streetLine1: address.streetLine1,
      streetLine2: address.streetLine2,
      isDefault: address.isDefault,
    );
    _addresses.add(created);
    return created;
  }

  @override
  Future<OrderModel> placeOrder({
    required String addressId,
    required PaymentMethod paymentMethod,
    String? couponCode,
    bool agreeToTerms = true,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final address = _addresses.firstWhere((a) => a.id == addressId);
    final order = OrderModel(
      id: 'KYN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      titleAr: 'طلب تجريبي',
      titleEn: 'Demo order',
      status: paymentMethod == PaymentMethod.cod ? 'pending' : 'paid',
      statusAr: paymentMethod == PaymentMethod.cod ? 'قيد الانتظار' : 'تم الدفع',
      statusEn: paymentMethod == PaymentMethod.cod ? 'Pending' : 'Paid',
      itemCount: 1,
      subtotal: 299,
      discount: 0,
      shipping: 25,
      vat: 44.85,
      total: 368.85,
      paymentMethod: paymentMethod.name,
      couponCode: couponCode,
      address: address,
      createdAt: DateTime.now(),
      items: const [
        OrderLineModel(
          productId: 'p1',
          slug: 'sony-headphones',
          nameAr: 'سماعات سوني',
          nameEn: 'Sony Headphones',
          unitPrice: 299,
          quantity: 1,
        ),
      ],
    );
    _orders.insert(0, order);
    return order;
  }

  @override
  Future<List<OrderModel>> getOrders() async => List.unmodifiable(_orders);

  @override
  Future<OrderModel> getOrder(String id) async =>
      _orders.firstWhere((o) => o.id == id);

  @override
  Future<PaymentIntentResult> createPaymentIntent({
    required String orderId,
    required PaymentMethod paymentMethod,
  }) async {
    return PaymentIntentResult(
      orderId: orderId,
      status: paymentMethod == PaymentMethod.cod ? 'pending' : 'success',
      provider: paymentMethod == PaymentMethod.cod ? 'cod' : 'mock',
      providerRef: 'mock_$orderId',
    );
  }

  @override
  Future<PaymentIntentResult> confirmPayment({
    required String orderId,
    required String providerRef,
  }) async {
    return PaymentIntentResult(
      orderId: orderId,
      status: 'success',
      providerRef: providerRef,
    );
  }
}
