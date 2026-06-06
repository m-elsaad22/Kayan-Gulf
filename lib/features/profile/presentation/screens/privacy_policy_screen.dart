// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'سياسة الخصوصية',
      titleEn: 'Privacy Policy',
      subtitleAr: 'خصوصيتك أساس الثقة في كيان.',
      subtitleEn: 'Your privacy is core to KAYAN trust.',
      children: [
          Phase2InfoCard(
            icon: Icons.privacy_tip_rounded,
            titleAr: 'البيانات الشخصية',
            titleEn: 'Personal Data',
            bodyAr: 'نستخدم بياناتك لتحسين التجربة فقط.',
            bodyEn: 'We use your data only to improve the experience.',
          ),
          Phase2InfoCard(
            icon: Icons.security_rounded,
            titleAr: 'الحماية',
            titleEn: 'Protection',
            bodyAr: 'نخزن البيانات الحساسة بطريقة آمنة.',
            bodyEn: 'Sensitive data is stored securely.',
          ),
      ],
    );
  }
}
