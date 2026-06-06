// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class TechnicianArrivalScreen extends StatelessWidget {
  const TechnicianArrivalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'وصول الفني',
      titleEn: 'Technician Arrival',
      subtitleAr: 'تابع وصول الفني وتحقق من بياناته.',
      subtitleEn: 'Track technician arrival and verify details.',
      children: [
          Phase3ServiceCard(
            icon: Icons.badge_rounded,
            titleAr: 'هوية الفني',
            titleEn: 'Technician ID',
            bodyAr: 'تحقق من الاسم والتقييم قبل بدء الخدمة.',
            bodyEn: 'Verify name and rating before service starts.',
          ),
          Phase3ServiceCard(
            icon: Icons.qr_code_rounded,
            titleAr: 'رمز التحقق',
            titleEn: 'Verification Code',
            bodyAr: 'استخدم الرمز لتأكيد وصول الفني.',
            bodyEn: 'Use the code to confirm arrival.',
          ),
      ],
    );
  }
}
