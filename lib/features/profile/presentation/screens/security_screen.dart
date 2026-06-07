// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'الأمان',
      titleEn: 'Security',
      subtitleAr: 'إدارة حماية حسابك في كيان.',
      subtitleEn: 'Manage your KAYAN account protection.',
      children: [
          Phase2InfoCard(
            icon: Icons.lock_rounded,
            titleAr: 'تغيير كلمة المرور',
            titleEn: 'Change Password',
            bodyAr: 'حدّث كلمة المرور بشكل دوري.',
            bodyEn: 'Update your password regularly.',
          ),
          Phase2InfoCard(
            icon: Icons.verified_user_rounded,
            titleAr: 'التحقق الثنائي',
            titleEn: 'Two-factor Authentication',
            bodyAr: 'أضف طبقة حماية إضافية.',
            bodyEn: 'Add an extra protection layer.',
          ),
          Phase2InfoCard(
            icon: Icons.devices_rounded,
            titleAr: 'الأجهزة المتصلة',
            titleEn: 'Connected Devices',
            bodyAr: 'راجع الأجهزة التي استخدمت حسابك.',
            bodyEn: 'Review devices that used your account.',
          ),
      ],
    );
  }
}
