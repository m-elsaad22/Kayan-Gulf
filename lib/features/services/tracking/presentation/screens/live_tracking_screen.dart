import 'package:flutter/material.dart';

import 'service_tracking_light_screen.dart';

/// تتبع مباشر — legacy alias يوجّه إلى [ServiceTrackingLightScreen].
class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return ServiceTrackingLightScreen(bookingId: bookingId);
  }
}
