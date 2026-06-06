// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class DigitalWalletScreen extends StatelessWidget {
  const DigitalWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'المحفظة الرقمية',
      titleEn: 'Digital Wallet',
      subtitleAr: 'استخدم المحافظ الرقمية للدفع السريع.',
      subtitleEn: 'Use digital wallets for fast checkout.',
      children: [
          Phase4CommerceCard(
            icon: Icons.phone_iphone_rounded,
            titleAr: 'Apple Pay',
            titleEn: 'Apple Pay',
            bodyAr: 'دفع سريع عبر جهازك.',
            bodyEn: 'Fast payment through your device.',
          ),
          Phase4CommerceCard(
            icon: Icons.account_balance_wallet_rounded,
            titleAr: 'محفظة كيان',
            titleEn: 'KAYAN Wallet',
            bodyAr: 'استخدم الرصيد والنقاط.',
            bodyEn: 'Use balance and points.',
          ),
      ],
    );
  }
}
