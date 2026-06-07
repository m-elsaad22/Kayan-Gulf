// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class LoyaltyCardsScreen extends StatelessWidget {
  const LoyaltyCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'بطاقات الولاء',
      titleEn: 'Loyalty Cards',
      subtitleAr: 'بطاقات ومزايا حسب نقاطك.',
      subtitleEn: 'Cards and benefits based on your points.',
      children: [
          Phase2InfoCard(
            icon: Icons.workspace_premium_rounded,
            titleAr: 'ذهبي',
            titleEn: 'Gold',
            bodyAr: 'خصومات وخدمات أولوية.',
            bodyEn: 'Discounts and priority services.',
          ),
          Phase2InfoCard(
            icon: Icons.diamond_rounded,
            titleAr: 'بلاتيني',
            titleEn: 'Platinum',
            bodyAr: 'مزايا حصرية للعملاء المميزين.',
            bodyEn: 'Exclusive benefits for premium customers.',
          ),
      ],
    );
  }
}
