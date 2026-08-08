import 'package:flutter/material.dart';

import 'services_bookings_light_screen.dart';

/// حجوزاتي — legacy alias يوجّه إلى [ServicesBookingsLightScreen] (تصميم خفيف).
class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) => const ServicesBookingsLightScreen();
}
