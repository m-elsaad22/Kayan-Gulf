import 'package:flutter/material.dart';

import 'settings_light_screen.dart';

/// الإعدادات — legacy alias يوجّه إلى [SettingsLightScreen] (تصميم خفيف).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsLightScreen();
  }
}
