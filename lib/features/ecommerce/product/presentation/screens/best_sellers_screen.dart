// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase4_commerce_widgets.dart';

class BestSellersScreen extends StatelessWidget {
  const BestSellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'الأكثر مبيعاً',
      titleEn: 'Best Sellers',
      subtitleAr: 'منتجات يثق بها عملاء كيان.',
      subtitleEn: 'Products trusted by KAYAN customers.',
      children: [
          Phase4CommerceCard(
            icon: Icons.local_fire_department_rounded,
            titleAr: 'رائج الآن',
            titleEn: 'Trending Now',
            bodyAr: 'منتجات ذات طلب مرتفع هذا الأسبوع.',
            bodyEn: 'High-demand products this week.',
          ),
          Phase4CommerceCard(
            icon: Icons.workspace_premium_rounded,
            titleAr: 'مختارات مميزة',
            titleEn: 'Premium Picks',
            bodyAr: 'منتجات مختارة بعناية للسوق الخليجي.',
            bodyEn: 'Curated for GCC customers.',
          ),
      ],
    );
  }
}
