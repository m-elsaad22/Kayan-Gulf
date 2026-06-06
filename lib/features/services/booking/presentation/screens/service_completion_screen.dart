// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class ServiceCompletionScreen extends StatelessWidget {
  const ServiceCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'إكمال الخدمة',
      titleEn: 'Service Completion',
      subtitleAr: 'أكد إنجاز الخدمة وقيّم التجربة.',
      subtitleEn: 'Confirm completion and rate the experience.',
      children: [
          Phase3ServiceCard(
            icon: Icons.task_alt_rounded,
            titleAr: 'تأكيد الإنجاز',
            titleEn: 'Confirm Completion',
            bodyAr: 'راجع ملخص العمل قبل الإغلاق.',
            bodyEn: 'Review work summary before closing.',
          ),
          Phase3ServiceCard(
            icon: Icons.rate_review_rounded,
            titleAr: 'التقييم',
            titleEn: 'Rating',
            bodyAr: 'قيّم الفني وجودة الخدمة.',
            bodyEn: 'Rate technician and service quality.',
          ),
      ],
    );
  }
}
