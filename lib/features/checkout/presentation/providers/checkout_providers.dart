// ============================================================
// KAYAN — Checkout Providers
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/di/repository_providers.dart';
import '../../domain/checkout_models.dart';

export '../../domain/checkout_models.dart';

enum CheckoutStep { address, payment, review }
enum OrderStatus { idle, placing, success, failed }

class CheckoutState {
  final CheckoutStep step;
  final DeliveryAddress? selectedAddress;
  final PaymentMethod paymentMethod;
  final OrderStatus orderStatus;
  final String? orderId;
  final String? errorMessage;
  final bool agreeToTerms;
  final String? redirectUrl;

  const CheckoutState({
    this.step = CheckoutStep.address,
    this.selectedAddress,
    this.paymentMethod = PaymentMethod.cod,
    this.orderStatus = OrderStatus.idle,
    this.orderId,
    this.errorMessage,
    this.agreeToTerms = false,
    this.redirectUrl,
  });

  bool get canProceed => selectedAddress != null;

  CheckoutState copyWith({
    CheckoutStep? step,
    DeliveryAddress? selectedAddress,
    PaymentMethod? paymentMethod,
    OrderStatus? orderStatus,
    String? orderId,
    String? errorMessage,
    bool? agreeToTerms,
    String? redirectUrl,
    bool clearError = false,
    bool clearRedirect = false,
  }) =>
      CheckoutState(
        step: step ?? this.step,
        selectedAddress: selectedAddress ?? this.selectedAddress,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        orderStatus: orderStatus ?? this.orderStatus,
        orderId: orderId ?? this.orderId,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        agreeToTerms: agreeToTerms ?? this.agreeToTerms,
        redirectUrl:
            clearRedirect ? null : (redirectUrl ?? this.redirectUrl),
      );
}

class CheckoutNotifier extends AutoDisposeNotifier<CheckoutState> {
  @override
  CheckoutState build() {
    if (!AppConfig.useMockData) {
      Future.microtask(_loadAddresses);
      return const CheckoutState();
    }
    return CheckoutState(
      selectedAddress: _mockAddresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => _mockAddresses.first,
      ),
    );
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses =
          await ref.read(orderRepositoryProvider).getAddresses();
      if (addresses.isEmpty) return;
      final preferred = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );
      state = state.copyWith(selectedAddress: preferred);
    } catch (_) {
      // Keep null; placeOrder will surface the error.
    }
  }

  void selectAddress(DeliveryAddress address) {
    state = state.copyWith(selectedAddress: address);
  }

  void selectPayment(PaymentMethod method) {
    state = state.copyWith(paymentMethod: method);
  }

  void setStep(CheckoutStep step) {
    state = state.copyWith(step: step);
  }

  void toggleTerms() {
    state = state.copyWith(agreeToTerms: !state.agreeToTerms);
  }

  Future<bool> placeOrder({PaymentMethod? method}) async {
    final pay = method ?? state.paymentMethod;
    state = state.copyWith(
      orderStatus: OrderStatus.placing,
      paymentMethod: pay,
      clearError: true,
      clearRedirect: true,
    );

    if (AppConfig.useMockData) {
      await Future.delayed(const Duration(seconds: 1));
      final orderId =
          'KYN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      state = state.copyWith(
        orderStatus: OrderStatus.success,
        orderId: orderId,
      );
      return true;
    }

    final address = state.selectedAddress;
    if (address == null || address.id.isEmpty) {
      state = state.copyWith(
        orderStatus: OrderStatus.failed,
        errorMessage: 'no_delivery_address',
      );
      return false;
    }

    try {
      final orders = ref.read(orderRepositoryProvider);
      final order = await orders.placeOrder(
        addressId: address.id,
        paymentMethod: pay,
        agreeToTerms: true,
      );

      final intent = await orders.createPaymentIntent(
        orderId: order.id,
        paymentMethod: pay,
      );

      final ok = intent.status == 'success' ||
          (intent.status == 'pending' && pay == PaymentMethod.cod);

      state = state.copyWith(
        orderStatus: ok || intent.redirectUrl != null
            ? OrderStatus.success
            : OrderStatus.failed,
        orderId: order.id,
        redirectUrl: intent.redirectUrl,
        errorMessage:
            ok || intent.redirectUrl != null ? null : 'payment_failed',
      );
      return state.orderStatus == OrderStatus.success;
    } catch (e) {
      state = state.copyWith(
        orderStatus: OrderStatus.failed,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() => state = build();
}

final checkoutProvider =
    AutoDisposeNotifierProvider<CheckoutNotifier, CheckoutState>(
  CheckoutNotifier.new,
);

final savedAddressesProvider =
    FutureProvider.autoDispose<List<DeliveryAddress>>((ref) async {
  if (AppConfig.useMockData) return _mockAddresses;
  return ref.watch(orderRepositoryProvider).getAddresses();
});

final _mockAddresses = [
  const DeliveryAddress(
    id: 'addr1',
    label: 'المنزل 🏠',
    recipientName: 'محمود السعد',
    phone: '+966 50 123 4567',
    country: 'SA',
    city: 'الرياض',
    district: 'حي النخيل',
    streetLine1: 'شارع الملك فهد، مبنى 24، شقة 5',
    isDefault: true,
  ),
  const DeliveryAddress(
    id: 'addr2',
    label: 'العمل 🏢',
    recipientName: 'محمود السعد',
    phone: '+966 50 123 4567',
    country: 'SA',
    city: 'الرياض',
    district: 'حي العليا',
    streetLine1: 'برج المملكة، الطابق 15، مكتب 1503',
  ),
  const DeliveryAddress(
    id: 'addr3',
    label: 'دبي 🇦🇪',
    recipientName: 'محمود السعد',
    phone: '+971 50 123 4567',
    country: 'AE',
    city: 'دبي',
    district: 'الخليج التجاري',
    streetLine1: 'برج داماك، الطابق 8، شقة 801',
  ),
];
