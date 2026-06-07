// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_wallet_widgets.dart';

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2WalletScaffold(
      titleAr: 'إيصال الدفع',
      titleEn: 'Payment Receipt',
      subtitleAr: 'تفاصيل عملية الدفع الأخيرة.',
      subtitleEn: 'Details of your latest payment.',
      children: [
          Phase2WalletCard(
            icon: Icons.receipt_long_rounded,
            titleAr: 'رقم العملية',
            titleEn: 'Transaction ID',
            value: 'KYN-884201',
            captionAr: 'احتفظ بهذا الرقم للرجوع إليه.',
            captionEn: 'Keep this ID for reference.',
          ),
          Phase2WalletCard(
            icon: Icons.check_circle_rounded,
            titleAr: 'حالة الدفع',
            titleEn: 'Payment Status',
            value: 'مدفوع',
            captionAr: 'تمت العملية بنجاح.',
            captionEn: 'Payment completed successfully.',
          ),
      ],
    );
  }
}
