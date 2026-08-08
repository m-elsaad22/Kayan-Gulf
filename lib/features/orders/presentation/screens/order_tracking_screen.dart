import 'package:flutter/material.dart';

import 'order_tracking_light_screen.dart';

/// تتبع الطلب — legacy alias يوجّه إلى [OrderTrackingLightScreen] (تصميم خفيف).
class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) => OrderTrackingLightScreen(orderId: orderId);
}
