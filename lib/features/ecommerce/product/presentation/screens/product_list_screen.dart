import 'package:flutter/material.dart';

import '../../../shop/presentation/screens/shop_catalog_screen.dart';

/// قائمة المنتجات — legacy alias يوجّه إلى [ShopCatalogScreen] (تصميم خفيف).
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key, this.categorySlug, this.initialQuery});

  final String? categorySlug;
  final String? initialQuery;

  @override
  Widget build(BuildContext context) {
    return ShopCatalogScreen(categorySlug: categorySlug);
  }
}
