/// Shared checkout models (kept free of Riverpod to avoid import cycles).

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
