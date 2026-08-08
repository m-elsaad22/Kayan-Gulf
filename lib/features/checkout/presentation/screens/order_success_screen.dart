import 'package:flutter/material.dart';

import 'order_success_light_screen.dart';

/// نجاح الطلب — legacy alias يوجّه إلى [OrderSuccessLightScreen] (تصميم خفيف).
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) => OrderSuccessLightScreen(orderId: orderId);
}
