// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class PaypalPaymentScreen extends StatelessWidget {
  const PaypalPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'دفع PayPal',
      titleEn: 'PayPal Payment',
      subtitleAr: 'أكمل الدفع عبر حساب PayPal بأمان.',
      subtitleEn: 'Complete payment securely through PayPal.',
      children: [
          Phase4CommerceCard(
            icon: Icons.account_balance_wallet_rounded,
            titleAr: 'ربط الحساب',
            titleEn: 'Account Link',
            bodyAr: 'سيتم فتح بوابة PayPal الآمنة.',
            bodyEn: 'Secure PayPal gateway will open.',
          ),
          Phase4CommerceCard(
            icon: Icons.verified_user_rounded,
            titleAr: 'حماية المشتري',
            titleEn: 'Buyer Protection',
            bodyAr: 'مزايا حماية حسب سياسات PayPal.',
            bodyEn: 'Protection according to PayPal policies.',
          ),
      ],
    );
  }
}
