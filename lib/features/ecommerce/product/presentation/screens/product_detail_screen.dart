import 'package:flutter/material.dart';

import '../../../shop/presentation/screens/shop_product_screen.dart';

/// تفاصيل المنتج — legacy alias يوجّه إلى [ShopProductScreen] (تصميم خفيف).
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return ShopProductScreen(slug: slug);
  }
}
