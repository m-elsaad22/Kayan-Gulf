// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class RateAppScreen extends StatelessWidget {
  const RateAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'قيّم التطبيق',
      titleEn: 'Rate App',
      subtitleAr: 'رأيك يساعدنا على تحسين كيان.',
      subtitleEn: 'Your feedback helps us improve KAYAN.',
      children: [
          Phase2InfoCard(
            icon: Icons.star_rate_rounded,
            titleAr: 'تقييم التجربة',
            titleEn: 'Experience Rating',
            bodyAr: 'اختر تقييمك من المتجر لاحقاً.',
            bodyEn: 'Choose your app-store rating later.',
          ),
          Phase2InfoCard(
            icon: Icons.feedback_rounded,
            titleAr: 'ملاحظاتك',
            titleEn: 'Your Feedback',
            bodyAr: 'شاركنا اقتراحاتك لتطوير التجربة.',
            bodyEn: 'Share suggestions to improve the experience.',
          ),
      ],
    );
  }
}
