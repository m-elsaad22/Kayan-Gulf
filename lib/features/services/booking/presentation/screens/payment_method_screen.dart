// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'طريقة الدفع',
      titleEn: 'Payment Method',
      subtitleAr: 'اختر وسيلة الدفع المناسبة لحجز الخدمة.',
      subtitleEn: 'Choose the preferred payment method for booking.',
      children: [
          Phase3ServiceCard(
            icon: Icons.credit_card_rounded,
            titleAr: 'بطاقة بنكية',
            titleEn: 'Card',
            bodyAr: 'ادفع بأمان عبر بطاقة محفوظة أو جديدة.',
            bodyEn: 'Pay securely with saved or new card.',
          ),
          Phase3ServiceCard(
            icon: Icons.account_balance_wallet_rounded,
            titleAr: 'محفظة كيان',
            titleEn: 'KAYAN Wallet',
            bodyAr: 'استخدم رصيد محفظتك ونقاطك.',
            bodyEn: 'Use wallet balance and points.',
          ),
          Phase3ServiceCard(
            icon: Icons.payments_rounded,
            titleAr: 'الدفع عند الإنجاز',
            titleEn: 'Pay on Completion',
            bodyAr: 'متاح لبعض الخدمات المؤهلة.',
            bodyEn: 'Available for eligible services.',
          ),
      ],
    );
  }
}
