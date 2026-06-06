// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class ExtraMaterialsScreen extends StatelessWidget {
  const ExtraMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'مواد إضافية',
      titleEn: 'Extra Materials',
      subtitleAr: 'أضف مواد أو قطع غيار مطلوبة للخدمة.',
      subtitleEn: 'Add required materials or spare parts for service.',
      children: [
          Phase3ServiceCard(
            icon: Icons.inventory_2_rounded,
            titleAr: 'قطع غيار',
            titleEn: 'Spare Parts',
            bodyAr: 'اختر القطع الشائعة حسب نوع الخدمة.',
            bodyEn: 'Choose common parts by service type.',
          ),
          Phase3ServiceCard(
            icon: Icons.add_shopping_cart_rounded,
            titleAr: 'إضافات اختيارية',
            titleEn: 'Optional Add-ons',
            bodyAr: 'راجع التكلفة قبل تأكيد الحجز.',
            bodyEn: 'Review cost before booking confirmation.',
          ),
      ],
    );
  }
}
