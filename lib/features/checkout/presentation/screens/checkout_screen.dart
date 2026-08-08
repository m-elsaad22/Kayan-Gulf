import 'package:flutter/material.dart';

import '../../../ecommerce/shop/presentation/screens/shop_checkout_screen.dart';

/// الدفع — legacy alias يوجّه إلى [ShopCheckoutScreen] (تصميم خفيف).
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) => const ShopCheckoutScreen();
}
