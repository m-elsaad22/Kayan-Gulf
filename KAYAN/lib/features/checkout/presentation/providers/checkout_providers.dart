// ============================================================
// KAYAN — Checkout Providers
// lib/features/checkout/presentation/providers/checkout_providers.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ──────────────────────────────────────────────────────────────
// PAYMENT METHOD
// ──────────────────────────────────────────────────────────────

enum PaymentMethod {
  cod,      // Cash on Delivery
  tabby,    // Tabby — Buy Now Pay Later (4 installments)
  tamara,   // Tamara — Buy Now Pay Later (3 installments)
  card,     // Credit/Debit Card (Stripe)
  applepay, // Apple Pay
  wallet,   // KAYAN Wallet
}

extension PaymentMethodX on PaymentMethod {
  String get labelAr => switch (this) {
    PaymentMethod.cod      => 'الدفع عند الاستلام',
    PaymentMethod.tabby    => 'تابي — 4 دفعات بدون فوائد',
    PaymentMethod.tamara   => 'تمارا — 3 دفعات',
    PaymentMethod.card     => 'بطاقة بنكية',
    PaymentMethod.applepay => 'Apple Pay',
    PaymentMethod.wallet   => 'محفظة كيان',
  };

  String get labelEn => switch (this) {
    PaymentMethod.cod      => 'Cash on Delivery',
    PaymentMethod.tabby    => 'Tabby — 4 payments, 0% interest',
    PaymentMethod.tamara   => 'Tamara — Split in 3',
    PaymentMethod.card     => 'Credit / Debit Card',
    PaymentMethod.applepay => 'Apple Pay',
    PaymentMethod.wallet   => 'KAYAN Wallet',
  };

  String get iconEmoji => switch (this) {
    PaymentMethod.cod      => '💵',
    PaymentMethod.tabby    => '🔵',
    PaymentMethod.tamara   => '🟢',
    PaymentMethod.card     => '💳',
    PaymentMethod.applepay => '🍎',
    PaymentMethod.wallet   => '👛',
  };

  bool get isBnpl => this == PaymentMethod.tabby || this == PaymentMethod.tamara;
}

// ──────────────────────────────────────────────────────────────
// ADDRESS MODEL
// ──────────────────────────────────────────────────────────────

class DeliveryAddress {
  final String  id;
  final String  label;         // "المنزل" / "العمل"
  final String  recipientName;
  final String  phone;
  final String  country;
  final String  city;
  final String  district;
  final String  streetLine1;
  final String? streetLine2;
  final bool    isDefault;

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
}

// ──────────────────────────────────────────────────────────────
// CHECKOUT STATE
// ──────────────────────────────────────────────────────────────

enum CheckoutStep { address, payment, review }
enum OrderStatus  { idle, placing, success, failed }

class CheckoutState {
  final CheckoutStep    step;
  final DeliveryAddress? selectedAddress;
  final PaymentMethod   paymentMethod;
  final OrderStatus     orderStatus;
  final String?         orderId;
  final String?         errorMessage;
  final bool            agreeToTerms;

  const CheckoutState({
    this.step          = CheckoutStep.address,
    this.selectedAddress,
    this.paymentMethod = PaymentMethod.cod,
    this.orderStatus   = OrderStatus.idle,
    this.orderId,
    this.errorMessage,
    this.agreeToTerms  = false,
  });

  bool get canProceed => selectedAddress != null;

  CheckoutState copyWith({
    CheckoutStep?    step,
    DeliveryAddress? selectedAddress,
    PaymentMethod?   paymentMethod,
    OrderStatus?     orderStatus,
    String?          orderId,
    String?          errorMessage,
    bool?            agreeToTerms,
  }) => CheckoutState(
    step:            step            ?? this.step,
    selectedAddress: selectedAddress ?? this.selectedAddress,
    paymentMethod:   paymentMethod   ?? this.paymentMethod,
    orderStatus:     orderStatus     ?? this.orderStatus,
    orderId:         orderId         ?? this.orderId,
    errorMessage:    errorMessage    ?? this.errorMessage,
    agreeToTerms:    agreeToTerms    ?? this.agreeToTerms,
  );
}

// ──────────────────────────────────────────────────────────────
// CHECKOUT NOTIFIER
// ──────────────────────────────────────────────────────────────

class CheckoutNotifier extends AutoDisposeNotifier<CheckoutState> {
  @override
  CheckoutState build() => CheckoutState(
    // Pre-select default address
    selectedAddress: _mockAddresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _mockAddresses.first,
    ),
  );

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

  Future<bool> placeOrder() async {
    state = state.copyWith(orderStatus: OrderStatus.placing);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // 95% success rate for demo
    final success = true;

    if (success) {
      final orderId = 'KYN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      state = state.copyWith(
        orderStatus: OrderStatus.success,
        orderId:     orderId,
      );
      return true;
    } else {
      state = state.copyWith(
        orderStatus:  OrderStatus.failed,
        errorMessage: 'فشلت عملية الدفع. يرجى المحاولة مجدداً.',
      );
      return false;
    }
  }

  void reset() => state = build();
}

final checkoutProvider =
    AutoDisposeNotifierProvider<CheckoutNotifier, CheckoutState>(
        CheckoutNotifier.new);

// ──────────────────────────────────────────────────────────────
// ADDRESSES PROVIDER
// ──────────────────────────────────────────────────────────────

final savedAddressesProvider = Provider.autoDispose<List<DeliveryAddress>>(
  (_) => _mockAddresses,
);

final _mockAddresses = [
  const DeliveryAddress(
    id:            'addr1',
    label:         'المنزل 🏠',
    recipientName: 'محمود السعد',
    phone:         '+966 50 123 4567',
    country:       'SA',
    city:          'الرياض',
    district:      'حي النخيل',
    streetLine1:   'شارع الملك فهد، مبنى 24، شقة 5',
    isDefault:     true,
  ),
  const DeliveryAddress(
    id:            'addr2',
    label:         'العمل 🏢',
    recipientName: 'محمود السعد',
    phone:         '+966 50 123 4567',
    country:       'SA',
    city:          'الرياض',
    district:      'حي العليا',
    streetLine1:   'برج المملكة، الطابق 15، مكتب 1503',
  ),
  const DeliveryAddress(
    id:            'addr3',
    label:         'دبي 🇦🇪',
    recipientName: 'محمود السعد',
    phone:         '+971 50 123 4567',
    country:       'AE',
    city:          'دبي',
    district:      'الخليج التجاري',
    streetLine1:   'برج داماك، الطابق 8، شقة 801',
  ),
];
