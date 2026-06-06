// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase4_commerce_widgets.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'تقييمات المنتج',
      titleEn: 'Product Reviews',
      subtitleAr: 'آراء العملاء وتقييماتهم حول المنتج.',
      subtitleEn: 'Customer feedback and product ratings.',
      children: [
          Phase4CommerceCard(
            icon: Icons.star_rate_rounded,
            titleAr: 'متوسط التقييم',
            titleEn: 'Average Rating',
            bodyAr: '4.8 من 5 بناءً على تقييمات العملاء.',
            bodyEn: '4.8 of 5 based on customer reviews.',
          ),
          Phase4CommerceCard(
            icon: Icons.verified_rounded,
            titleAr: 'مراجعات موثقة',
            titleEn: 'Verified Reviews',
            bodyAr: 'تظهر مراجعات المشترين الحقيقيين أولاً.',
            bodyEn: 'Real buyer reviews appear first.',
          ),
      ],
    );
  }
}
