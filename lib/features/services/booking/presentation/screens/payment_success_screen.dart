// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'نجاح الدفع',
      titleEn: 'Payment Success',
      subtitleAr: 'تم تأكيد الدفع وحجز الخدمة بنجاح.',
      subtitleEn: 'Payment confirmed and service booked successfully.',
      children: [
          Phase3ServiceCard(
            icon: Icons.check_circle_rounded,
            titleAr: 'تمت العملية',
            titleEn: 'Completed',
            bodyAr: 'ستصلك تفاصيل الحجز عبر الإشعارات.',
            bodyEn: 'Booking details will arrive via notifications.',
          ),
          Phase3ServiceCard(
            icon: Icons.receipt_long_rounded,
            titleAr: 'الإيصال',
            titleEn: 'Receipt',
            bodyAr: 'يمكنك مراجعة الفاتورة في أي وقت.',
            bodyEn: 'You can review the invoice anytime.',
          ),
      ],
    );
  }
}
