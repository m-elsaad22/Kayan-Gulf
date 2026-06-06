// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_wallet_widgets.dart';

class RedeemPointsScreen extends StatelessWidget {
  const RedeemPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2WalletScaffold(
      titleAr: 'استبدال النقاط',
      titleEn: 'Redeem Points',
      subtitleAr: 'حوّل نقاطك إلى خصومات ومزايا.',
      subtitleEn: 'Turn points into discounts and perks.',
      children: [
          Phase2WalletCard(
            icon: Icons.local_offer_rounded,
            titleAr: 'قسيمة خصم',
            titleEn: 'Discount Voucher',
            value: '500 نقطة',
            captionAr: 'خصم 50 ر.س على طلبك القادم.',
            captionEn: '50 SAR off your next order.',
          ),
          Phase2WalletCard(
            icon: Icons.workspace_premium_rounded,
            titleAr: 'ترقية مميزة',
            titleEn: 'Premium Upgrade',
            value: '1200 نقطة',
            captionAr: 'مزايا حصرية لمدة شهر.',
            captionEn: 'Exclusive perks for one month.',
          ),
      ],
    );
  }
}
