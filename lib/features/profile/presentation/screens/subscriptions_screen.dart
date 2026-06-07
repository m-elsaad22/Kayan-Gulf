// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'الاشتراكات',
      titleEn: 'Subscriptions',
      subtitleAr: 'خطط اشتراك لخدمات أكثر قيمة.',
      subtitleEn: 'Subscription plans for more value.',
      children: [
          Phase2InfoCard(
            icon: Icons.star_rounded,
            titleAr: 'KAYAN Plus',
            titleEn: 'KAYAN Plus',
            bodyAr: 'مزايا شهرية وخدمات أولوية.',
            bodyEn: 'Monthly perks and priority services.',
          ),
          Phase2InfoCard(
            icon: Icons.business_center_rounded,
            titleAr: 'KAYAN Business',
            titleEn: 'KAYAN Business',
            bodyAr: 'حلول للشركات والمكاتب.',
            bodyEn: 'Solutions for companies and offices.',
          ),
      ],
    );
  }
}
