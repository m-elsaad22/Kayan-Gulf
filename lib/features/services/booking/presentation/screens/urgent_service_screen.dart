// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class UrgentServiceScreen extends StatelessWidget {
  const UrgentServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'خدمة عاجلة',
      titleEn: 'Urgent Service',
      subtitleAr: 'اطلب فني بشكل أسرع للحالات الطارئة.',
      subtitleEn: 'Request faster technician dispatch for urgent cases.',
      children: [
          Phase3ServiceCard(
            icon: Icons.emergency_rounded,
            titleAr: 'أولوية عالية',
            titleEn: 'High Priority',
            bodyAr: 'تظهر الطلبات العاجلة للفنيين المتاحين أولاً.',
            bodyEn: 'Urgent requests appear first to available technicians.',
          ),
          Phase3ServiceCard(
            icon: Icons.timer_rounded,
            titleAr: 'وقت وصول أسرع',
            titleEn: 'Faster ETA',
            bodyAr: 'يتم عرض أقرب وقت وصول متاح.',
            bodyEn: 'Nearest available arrival time is shown.',
          ),
      ],
    );
  }
}
