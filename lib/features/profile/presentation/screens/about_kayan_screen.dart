// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class AboutKayanScreen extends StatelessWidget {
  const AboutKayanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'عن كيان',
      titleEn: 'About KAYAN',
      subtitleAr: 'كيان منصة خليجية تجمع الخدمات والتسوق والإعلانات.',
      subtitleEn: 'KAYAN is a GCC super app for services, shopping, and classifieds.',
      children: [
          Phase2InfoCard(
            icon: Icons.verified_rounded,
            titleAr: 'ثقة وموثوقية',
            titleEn: 'Trust',
            bodyAr: 'تجربة مصممة لمتطلبات السوق الخليجي.',
            bodyEn: 'Designed for GCC market expectations.',
          ),
          Phase2InfoCard(
            icon: Icons.public_rounded,
            titleAr: 'رؤية كيان',
            titleEn: 'Vision',
            bodyAr: 'منصة واحدة لكل احتياجاتك اليومية.',
            bodyEn: 'One platform for daily needs.',
          ),
      ],
    );
  }
}
