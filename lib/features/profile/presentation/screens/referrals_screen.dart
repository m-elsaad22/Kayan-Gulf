// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class ReferralsScreen extends StatelessWidget {
  const ReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'الإحالات',
      titleEn: 'Referrals',
      subtitleAr: 'ادعُ أصدقاءك واربح نقاطاً.',
      subtitleEn: 'Invite friends and earn points.',
      children: [
          Phase2InfoCard(
            icon: Icons.share_rounded,
            titleAr: 'رمز الإحالة',
            titleEn: 'Referral Code',
            bodyAr: 'KAYAN-GCC-2026',
            bodyEn: 'KAYAN-GCC-2026',
          ),
          Phase2InfoCard(
            icon: Icons.card_giftcard_rounded,
            titleAr: 'مكافأة',
            titleEn: 'Reward',
            bodyAr: '100 نقطة لكل صديق مؤهل.',
            bodyEn: '100 points for each eligible friend.',
          ),
      ],
    );
  }
}
