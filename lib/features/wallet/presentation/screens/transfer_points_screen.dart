// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_wallet_widgets.dart';

class TransferPointsScreen extends StatelessWidget {
  const TransferPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2WalletScaffold(
      titleAr: 'تحويل النقاط',
      titleEn: 'Transfer Points',
      subtitleAr: 'حوّل نقاط الولاء لأصدقائك وعائلتك.',
      subtitleEn: 'Transfer loyalty points to friends and family.',
      children: [
          Phase2WalletCard(
            icon: Icons.swap_horiz_rounded,
            titleAr: 'رصيد النقاط',
            titleEn: 'Points Balance',
            value: '1840',
            captionAr: 'يمكن تحويل حتى 500 نقطة يومياً.',
            captionEn: 'Transfer up to 500 points daily.',
          ),
          Phase2WalletCard(
            icon: Icons.person_add_alt_rounded,
            titleAr: 'المستفيد',
            titleEn: 'Recipient',
            value: '+966 5X XXX XXXX',
            captionAr: 'أدخل رقم جوال المستفيد.',
            captionEn: 'Enter recipient phone number.',
          ),
      ],
    );
  }
}
