// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_wallet_widgets.dart';

class EarnPointsScreen extends StatelessWidget {
  const EarnPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2WalletScaffold(
      titleAr: 'اكسب نقاط',
      titleEn: 'Earn Points',
      subtitleAr: 'طرق سهلة لزيادة رصيدك في كيان.',
      subtitleEn: 'Easy ways to grow your KAYAN balance.',
      children: [
          Phase2WalletCard(
            icon: Icons.shopping_bag_rounded,
            titleAr: 'التسوق',
            titleEn: 'Shopping',
            value: '1 نقطة / 10 ر.س',
            captionAr: 'اكسب مع كل عملية شراء.',
            captionEn: 'Earn on every purchase.',
          ),
          Phase2WalletCard(
            icon: Icons.home_repair_service_rounded,
            titleAr: 'الخدمات',
            titleEn: 'Services',
            value: '2 نقطة / 10 ر.س',
            captionAr: 'احجز خدمات منزلية واكسب أكثر.',
            captionEn: 'Book services and earn more.',
          ),
      ],
    );
  }
}
