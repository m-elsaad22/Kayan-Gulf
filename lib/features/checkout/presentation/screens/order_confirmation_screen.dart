// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'تأكيد الطلب',
      titleEn: 'Order Confirmation',
      subtitleAr: 'راجع المنتجات والعنوان والدفع قبل الإرسال.',
      subtitleEn: 'Review products, address, and payment before placing order.',
      children: [
          Phase4CommerceCard(
            icon: Icons.shopping_bag_rounded,
            titleAr: 'ملخص المنتجات',
            titleEn: 'Products Summary',
            bodyAr: 'عدد المنتجات والإجمالي النهائي.',
            bodyEn: 'Items count and final total.',
          ),
          Phase4CommerceCard(
            icon: Icons.local_shipping_rounded,
            titleAr: 'الشحن',
            titleEn: 'Delivery',
            bodyAr: 'وقت التوصيل المتوقع وطريقة الشحن.',
            bodyEn: 'Expected delivery time and method.',
          ),
      ],
    );
  }
}
