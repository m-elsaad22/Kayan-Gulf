import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/features/checkout/presentation/providers/checkout_providers.dart';
import 'package:kayan/features/ecommerce/cart/data/repositories/mock_cart_repository.dart';
import 'package:kayan/features/ecommerce/orders/data/repositories/mock_order_repository.dart';

void main() {
  test('MockCartRepository applies KAYAN10 coupon', () async {
    final repo = MockCartRepository();
    final before = await repo.getCart();
    expect(before.items, isNotEmpty);

    final after = await repo.applyCoupon('kayan10');
    expect(after.summary.couponCode, 'KAYAN10');
    expect(after.summary.couponDiscount, greaterThan(0));
  });

  test('MockOrderRepository places COD order', () async {
    final repo = MockOrderRepository();
    final addresses = await repo.getAddresses();
    final order = await repo.placeOrder(
      addressId: addresses.first.id,
      paymentMethod: PaymentMethod.cod,
    );
    expect(order.id, startsWith('KYN-'));
    expect(order.paymentMethod, 'cod');

    final list = await repo.getOrders();
    expect(list, isNotEmpty);
  });
}
