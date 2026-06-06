// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'الشروط والأحكام',
      titleEn: 'Terms of Service',
      subtitleAr: 'استخدامك لكيان يخضع لهذه الشروط.',
      subtitleEn: 'Your KAYAN usage follows these terms.',
      children: [
          Phase2InfoCard(
            icon: Icons.gavel_rounded,
            titleAr: 'الاستخدام العادل',
            titleEn: 'Fair Usage',
            bodyAr: 'التزم بالأنظمة المحلية وسياسات المنصة.',
            bodyEn: 'Follow local regulations and platform policies.',
          ),
          Phase2InfoCard(
            icon: Icons.receipt_long_rounded,
            titleAr: 'المدفوعات',
            titleEn: 'Payments',
            bodyAr: 'تختلف سياسات الاسترداد حسب الخدمة أو البائع.',
            bodyEn: 'Refund policies vary by service or vendor.',
          ),
      ],
    );
  }
}
