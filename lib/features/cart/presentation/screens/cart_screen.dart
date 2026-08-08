import 'package:flutter/material.dart';

import '../../../ecommerce/shop/presentation/screens/shop_cart_screen.dart';

/// سلة التسوق — legacy alias يوجّه إلى [ShopCartScreen] (تصميم خفيف).
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) => const ShopCartScreen();
}
