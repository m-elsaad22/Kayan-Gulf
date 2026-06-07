// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase4_commerce_widgets.dart';

class ExclusiveOffersScreen extends StatelessWidget {
  const ExclusiveOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'عروض حصرية',
      titleEn: 'Exclusive Offers',
      subtitleAr: 'خصومات ومزايا خاصة لعملاء كيان.',
      subtitleEn: 'Special discounts and perks for KAYAN customers.',
      children: [
          Phase4CommerceCard(
            icon: Icons.discount_rounded,
            titleAr: 'خصومات فورية',
            titleEn: 'Instant Discounts',
            bodyAr: 'عروض محدودة على منتجات مختارة.',
            bodyEn: 'Limited offers on selected products.',
          ),
          Phase4CommerceCard(
            icon: Icons.card_giftcard_rounded,
            titleAr: 'هدايا ومكافآت',
            titleEn: 'Gifts & Rewards',
            bodyAr: 'مكافآت إضافية مع بعض الطلبات.',
            bodyEn: 'Extra rewards with selected orders.',
          ),
      ],
    );
  }
}
