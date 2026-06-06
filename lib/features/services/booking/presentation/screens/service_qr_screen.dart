// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class ServiceQrScreen extends StatelessWidget {
  const ServiceQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'رمز الخدمة',
      titleEn: 'Service QR',
      subtitleAr: 'رمز آمن للتحقق من الحجز والفني.',
      subtitleEn: 'Secure code to verify booking and technician.',
      children: [
          Phase3ServiceCard(
            icon: Icons.qr_code_2_rounded,
            titleAr: 'QR الحجز',
            titleEn: 'Booking QR',
            bodyAr: 'اعرض الرمز للفني عند الوصول.',
            bodyEn: 'Show the code to the technician on arrival.',
          ),
          Phase3ServiceCard(
            icon: Icons.verified_rounded,
            titleAr: 'التحقق',
            titleEn: 'Verification',
            bodyAr: 'يساعد على حماية العميل والفني.',
            bodyEn: 'Protects both customer and technician.',
          ),
      ],
    );
  }
}
