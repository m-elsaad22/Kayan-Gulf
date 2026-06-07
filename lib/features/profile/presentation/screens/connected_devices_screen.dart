// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class ConnectedDevicesScreen extends StatelessWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'الأجهزة المتصلة',
      titleEn: 'Connected Devices',
      subtitleAr: 'تابع جلسات الدخول النشطة.',
      subtitleEn: 'Track active login sessions.',
      children: [
          Phase2InfoCard(
            icon: Icons.phone_android_rounded,
            titleAr: 'iPhone / Android',
            titleEn: 'iPhone / Android',
            bodyAr: 'آخر استخدام: اليوم.',
            bodyEn: 'Last active: today.',
          ),
          Phase2InfoCard(
            icon: Icons.desktop_windows_rounded,
            titleAr: 'متصفح الويب',
            titleEn: 'Web Browser',
            bodyAr: 'آخر استخدام: قبل يومين.',
            bodyEn: 'Last active: two days ago.',
          ),
      ],
    );
  }
}
