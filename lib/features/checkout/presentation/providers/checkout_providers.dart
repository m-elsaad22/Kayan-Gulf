// ============================================================
// KAYAN — Checkout Providers
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/di/repository_providers.dart';

// ──────────────────────────────────────────────────────────────
// PAYMENT METHOD
// ──────────────────────────────────────────────────────────────

enum PaymentMethod {
  cod,
  tabby,
  tamara,
  card,
  applepay,
  wallet,
}

extension PaymentMethodX on PaymentMethod {
  String get labelAr => switch (this) {
        PaymentMethod.cod => 'الدفع عند الاستلام',
        PaymentMethod.tabby => 'تابي — 4 دفعات بدون فوائد',
        PaymentMethod.tamara => 'تمارا — 3 دفعات',
        PaymentMethod.card => 'بطاقة بنكية',
        PaymentMethod.applepay => 'Apple Pay',
        PaymentMethod.wallet => 'محفظة كيان',
      };

  String get labelEn => switch (this) {
        PaymentMethod.cod => 'Cash on Delivery',
        PaymentMethod.tabby => 'Tabby — 4 payments, 0% interest',
        PaymentMethod.tamara => 'Tamara — Split in 3',
        PaymentMethod.card => 'Credit / Debit Card',
        PaymentMethod.applepay => 'Apple Pay',
        PaymentMethod.wallet => 'KAYAN Wallet',
      };

  String get iconEmoji => switch (this) {
        PaymentMethod.cod => '💵',
        PaymentMethod.tabby => '🔵',
        PaymentMethod.tamara => '🟢',
        PaymentMethod.card => '💳',
        PaymentMethod.applepay => '🍎',
        PaymentMethod.wallet => '👛',
      };

  bool get isBnpl =>
      this == PaymentMethod.tabby || this == PaymentMethod.tamara;
}

// ──────────────────────────────────────────────────────────────
// ADDRESS MODEL
// ──────────────────────────────────────────────────────────────

class DeliveryAddress {
  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String country;
  final String city;
  final String district;
  final String streetLine1;
  final String? streetLine2;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.country,
    required this.city,
    required this.district,
    required this.streetLine1,
    this.streetLine2,
    this.isDefault = false,
  });

  String get fullAddress => '$streetLine1، $district، $city';

  factory DeliveryAddress.fromJson(Map<String, dynamic> j) => DeliveryAddress(
        id: j['id'] as String,
        label: j['label'] as String,
        recipientName: j['recipientName'] as String,
        phone: j['phone'] as String,
        country: j['country'] as String? ?? 'SA',
        city: j['city'] as String,
        district: j['district'] as String,
        streetLine1: j['streetLine1'] as String,
        streetLine2: j['streetLine2'] as String?,
        isDefault: j['isDefault'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'recipientName': recipientName,
        'phone': phone,
        'country': country,
        'city': city,
        'district': district,
        'streetLine1': streetLine1,
        if (streetLine2 != null) 'streetLine2': streetLine2,
        'isDefault': isDefault,
      };
}

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

  /// Places order via API when mock is off; otherwise simulates success.
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
        errorMessage: ok || intent.redirectUrl != null
            ? null
            : 'payment_failed',
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
