import 'package:flutter/material.dart';

import '../../../ecommerce/shop/presentation/screens/shop_orders_screen.dart';

/// سجل الطلبات — legacy alias يوجّه إلى [ShopOrdersScreen] (تصميم خفيف).
class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) => const ShopOrdersScreen();
}
