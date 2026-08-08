import 'package:flutter/material.dart';

import 'profile_home_screen.dart';

/// الملف الشخصي — legacy alias يوجّه إلى [ProfileHomeScreen] (تصميم خفيف).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileHomeScreen();
  }
}
