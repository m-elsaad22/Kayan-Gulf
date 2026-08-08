import 'package:flutter/material.dart';

import 'notifications_light_screen.dart';

/// الإشعارات — legacy alias يوجّه إلى [NotificationsLightScreen] (تصميم خفيف).
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => const NotificationsLightScreen();
}
