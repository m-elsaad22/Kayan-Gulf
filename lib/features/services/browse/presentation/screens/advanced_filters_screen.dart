// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class AdvancedFiltersScreen extends StatelessWidget {
  const AdvancedFiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'فلترة متقدمة',
      titleEn: 'Advanced Filters',
      subtitleAr: 'تحكم دقيق في نتائج الخدمات حسب السعر والتقييم والمدينة.',
      subtitleEn: 'Refine service results by price, rating, and city.',
      children: [
          Phase3ServiceCard(
            icon: Icons.tune_rounded,
            titleAr: 'نطاق السعر',
            titleEn: 'Price Range',
            bodyAr: 'اختر الحد الأدنى والأعلى للميزانية.',
            bodyEn: 'Choose minimum and maximum budget.',
          ),
          Phase3ServiceCard(
            icon: Icons.star_rounded,
            titleAr: 'التقييم',
            titleEn: 'Rating',
            bodyAr: 'اعرض مزودي الخدمة الأعلى تقييماً.',
            bodyEn: 'Show top-rated providers.',
          ),
          Phase3ServiceCard(
            icon: Icons.location_city_rounded,
            titleAr: 'المدينة',
            titleEn: 'City',
            bodyAr: 'فلترة حسب المدن الخليجية المدعومة.',
            bodyEn: 'Filter by supported GCC cities.',
          ),
      ],
    );
  }
}
