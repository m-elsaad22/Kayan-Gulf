// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class ReturnSelectProductScreen extends StatelessWidget {
  const ReturnSelectProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'اختيار منتج للإرجاع',
      titleEn: 'Select Product to Return',
      subtitleAr: 'اختر المنتج الذي تريد إرجاعه من طلباتك.',
      subtitleEn: 'Choose the product you want to return from your orders.',
      children: [
          Phase4CommerceCard(
            icon: Icons.shopping_bag_rounded,
            titleAr: 'طلب حديث',
            titleEn: 'Recent Order',
            bodyAr: 'منتج مؤهل للإرجاع خلال مدة السياسة.',
            bodyEn: 'Product eligible within return policy.',
          ),
          Phase4CommerceCard(
            icon: Icons.assignment_return_rounded,
            titleAr: 'سبب الإرجاع',
            titleEn: 'Return Reason',
            bodyAr: 'سيتم طلب السبب في الخطوة التالية.',
            bodyEn: 'Reason is requested in the next step.',
          ),
      ],
    );
  }
}
