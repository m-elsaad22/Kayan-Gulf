// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase4_commerce_widgets.dart';

class ProductCompareScreen extends StatelessWidget {
  const ProductCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'مقارنة المنتجات',
      titleEn: 'Product Compare',
      subtitleAr: 'قارن المواصفات والأسعار قبل الشراء.',
      subtitleEn: 'Compare specs and prices before purchase.',
      children: [
          Phase4CommerceCard(
            icon: Icons.compare_arrows_rounded,
            titleAr: 'مقارنة ذكية',
            titleEn: 'Smart Comparison',
            bodyAr: 'اعرض الفروقات المهمة بين المنتجات.',
            bodyEn: 'Highlight key product differences.',
          ),
          Phase4CommerceCard(
            icon: Icons.price_check_rounded,
            titleAr: 'أفضل قيمة',
            titleEn: 'Best Value',
            bodyAr: 'اختر الأنسب حسب السعر والمزايا.',
            bodyEn: 'Choose by price and benefits.',
          ),
      ],
    );
  }
}
