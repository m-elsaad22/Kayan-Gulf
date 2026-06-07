// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class CodDetailsScreen extends StatelessWidget {
  const CodDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'الدفع عند الاستلام',
      titleEn: 'Cash on Delivery',
      subtitleAr: 'تعليمات الدفع النقدي عند استلام الطلب.',
      subtitleEn: 'Cash payment instructions at delivery.',
      children: [
          Phase4CommerceCard(
            icon: Icons.payments_rounded,
            titleAr: 'المبلغ المطلوب',
            titleEn: 'Amount Due',
            bodyAr: 'جهّز المبلغ عند وصول المندوب.',
            bodyEn: 'Prepare amount when courier arrives.',
          ),
          Phase4CommerceCard(
            icon: Icons.info_outline_rounded,
            titleAr: 'الشروط',
            titleEn: 'Terms',
            bodyAr: 'قد تطبق رسوم خدمة بسيطة.',
            bodyEn: 'Small service fee may apply.',
          ),
      ],
    );
  }
}
