// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class TwoFaVerifyScreen extends StatelessWidget {
  const TwoFaVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'تأكيد التحقق الثنائي',
      titleEn: 'Verify 2FA',
      subtitleAr: 'أدخل الرمز لإكمال التفعيل.',
      subtitleEn: 'Enter the code to complete setup.',
      children: [
          Phase2InfoCard(
            icon: Icons.pin_rounded,
            titleAr: 'رمز مكون من 6 أرقام',
            titleEn: '6-digit PIN',
            bodyAr: 'تحقق من الرسالة وأدخل الرمز.',
            bodyEn: 'Check your message and enter the PIN.',
          ),
      ],
    );
  }
}
