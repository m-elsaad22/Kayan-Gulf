import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/features/checkout/presentation/providers/checkout_providers.dart';

void main() {
  group('PaymentMethod', () {
    test('Arabic and English labels are defined', () {
      expect(PaymentMethod.cod.labelAr, contains('الدفع'));
      expect(PaymentMethod.wallet.labelEn, contains('Wallet'));
    });

    test('BNPL methods are identified', () {
      expect(PaymentMethod.tabby.isBnpl, isTrue);
      expect(PaymentMethod.tamara.isBnpl, isTrue);
      expect(PaymentMethod.cod.isBnpl, isFalse);
    });
  });

  group('DeliveryAddress', () {
    test('fullAddress joins street, district, and city', () {
      const address = DeliveryAddress(
        id: '1',
        label: 'المنزل',
        recipientName: 'أحمد',
        phone: '+966500000000',
        country: 'SA',
        city: 'الرياض',
        district: 'النخيل',
        streetLine1: 'شارع الملك فهد',
      );
      expect(address.fullAddress, 'شارع الملك فهد، النخيل، الرياض');
    });
  });

  group('CheckoutNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('starts with default address selected', () {
      final state = container.read(checkoutProvider);
      expect(state.selectedAddress, isNotNull);
      expect(state.canProceed, isTrue);
    });

    test('selectPayment updates payment method', () {
      container.read(checkoutProvider.notifier).selectPayment(PaymentMethod.wallet);
      expect(container.read(checkoutProvider).paymentMethod, PaymentMethod.wallet);
    });

    test('toggleTerms flips agreement flag', () {
      final notifier = container.read(checkoutProvider.notifier);
      expect(container.read(checkoutProvider).agreeToTerms, isFalse);
      notifier.toggleTerms();
      expect(container.read(checkoutProvider).agreeToTerms, isTrue);
      notifier.toggleTerms();
      expect(container.read(checkoutProvider).agreeToTerms, isFalse);
    });

    test('placeOrder succeeds in demo mode', () async {
      final sub = container.listen(checkoutProvider, (_, __) {});
      addTearDown(sub.close);

      final notifier = container.read(checkoutProvider.notifier);
      final ok = await notifier.placeOrder();
      expect(ok, isTrue);
      expect(container.read(checkoutProvider).orderStatus, OrderStatus.success);
      expect(container.read(checkoutProvider).orderId, isNotNull);
    });
  });
}
