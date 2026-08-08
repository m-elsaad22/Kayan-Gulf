import 'package:flutter/material.dart';

import 'order_detail_light_screen.dart';

/// تفاصيل الطلب — legacy alias يوجّه إلى [OrderDetailLightScreen] (تصميم خفيف).
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) => OrderDetailLightScreen(orderId: orderId);
}
