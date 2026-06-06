// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class ServiceInvoiceScreen extends StatelessWidget {
  const ServiceInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'فاتورة الخدمة',
      titleEn: 'Service Invoice',
      subtitleAr: 'تفاصيل تكلفة الخدمة والمواد والضريبة.',
      subtitleEn: 'Breakdown of service, materials, and tax.',
      children: [
          Phase3ServiceCard(
            icon: Icons.receipt_long_rounded,
            titleAr: 'ملخص الفاتورة',
            titleEn: 'Invoice Summary',
            bodyAr: 'الخدمة والمواد والخصومات.',
            bodyEn: 'Service, materials, and discounts.',
          ),
          Phase3ServiceCard(
            icon: Icons.download_rounded,
            titleAr: 'تحميل PDF',
            titleEn: 'Download PDF',
            bodyAr: 'احتفظ بنسخة من الفاتورة.',
            bodyEn: 'Keep a copy of the invoice.',
          ),
      ],
    );
  }
}
