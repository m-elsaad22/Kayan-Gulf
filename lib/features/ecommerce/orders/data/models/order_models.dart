import '../../../checkout/presentation/providers/checkout_providers.dart';

class OrderLineModel {
  final String productId;
  final String slug;
  final String nameAr;
  final String nameEn;
  final String? imageUrl;
  final double unitPrice;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;

  const OrderLineModel({
    required this.productId,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  factory OrderLineModel.fromJson(Map<String, dynamic> j) => OrderLineModel(
        productId: j['productId'] as String,
        slug: j['slug'] as String,
        nameAr: j['nameAr'] as String,
        nameEn: j['nameEn'] as String? ?? '',
        imageUrl: j['imageUrl'] as String?,
        unitPrice: (j['unitPrice'] as num).toDouble(),
        quantity: j['quantity'] as int? ?? 1,
        selectedColor: j['selectedColor'] as String?,
        selectedSize: j['selectedSize'] as String?,
      );
}

class OrderModel {
  final String id;
  final String? titleAr;
  final String? titleEn;
  final String status;
  final String statusAr;
  final String statusEn;
  final List<OrderLineModel> items;
  final int itemCount;
  final double subtotal;
  final double discount;
  final double shipping;
  final double vat;
  final double total;
  final String currency;
  final String paymentMethod;
  final String? couponCode;
  final DeliveryAddress? address;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    this.titleAr,
    this.titleEn,
    required this.status,
    required this.statusAr,
    required this.statusEn,
    this.items = const [],
    this.itemCount = 0,
    required this.subtotal,
    this.discount = 0,
    this.shipping = 0,
    required this.vat,
    required this.total,
    this.currency = 'SAR',
    required this.paymentMethod,
    this.couponCode,
    this.address,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
        id: j['id'] as String,
        titleAr: j['titleAr'] as String?,
        titleEn: j['titleEn'] as String?,
        status: j['status'] as String? ?? 'pending',
        statusAr: j['statusAr'] as String? ?? '',
        statusEn: j['statusEn'] as String? ?? '',
        items: (j['items'] as List? ?? [])
            .map((e) => OrderLineModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        itemCount: j['itemCount'] as int? ?? 0,
        subtotal: (j['subtotal'] as num?)?.toDouble() ?? 0,
        discount: (j['discount'] as num?)?.toDouble() ?? 0,
        shipping: (j['shipping'] as num?)?.toDouble() ?? 0,
        vat: (j['vat'] as num?)?.toDouble() ?? 0,
        total: (j['total'] as num).toDouble(),
        currency: j['currency'] as String? ?? 'SAR',
        paymentMethod: j['paymentMethod'] as String? ?? 'cod',
        couponCode: j['couponCode'] as String?,
        address: j['address'] != null
            ? DeliveryAddress.fromJson(j['address'] as Map<String, dynamic>)
            : null,
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

class PaymentIntentResult {
  final String orderId;
  final String status;
  final String? provider;
  final String? providerRef;
  final String? redirectUrl;
  final String? paymentId;

  const PaymentIntentResult({
    required this.orderId,
    required this.status,
    this.provider,
    this.providerRef,
    this.redirectUrl,
    this.paymentId,
  });

  factory PaymentIntentResult.fromJson(Map<String, dynamic> j) =>
      PaymentIntentResult(
        orderId: j['orderId'] as String,
        status: j['status'] as String? ?? 'pending',
        provider: j['provider'] as String?,
        providerRef: j['providerRef'] as String?,
        redirectUrl: j['redirectUrl'] as String?,
        paymentId: j['paymentId'] as String?,
      );
}
