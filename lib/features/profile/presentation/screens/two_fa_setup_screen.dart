// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class TwoFaSetupScreen extends StatelessWidget {
  const TwoFaSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'إعداد التحقق الثنائي',
      titleEn: '2FA Setup',
      subtitleAr: 'فعّل رمز تحقق إضافي عند تسجيل الدخول.',
      subtitleEn: 'Enable an extra verification code at sign-in.',
      children: [
          Phase2InfoCard(
            icon: Icons.sms_rounded,
            titleAr: 'رمز عبر SMS',
            titleEn: 'SMS Code',
            bodyAr: 'استلم الرمز على رقم جوالك المسجل.',
            bodyEn: 'Receive the code on your registered phone.',
          ),
          Phase2InfoCard(
            icon: Icons.email_rounded,
            titleAr: 'رمز عبر البريد',
            titleEn: 'Email Code',
            bodyAr: 'استخدم البريد كطريقة احتياطية.',
            bodyEn: 'Use email as a backup method.',
          ),
      ],
    );
  }
}
