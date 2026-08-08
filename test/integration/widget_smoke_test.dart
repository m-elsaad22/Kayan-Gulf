import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/features/ecommerce/product/presentation/providers/product_providers.dart';
import 'package:kayan/features/home/presentation/providers/home_providers.dart';
import 'package:kayan/shared/widgets/design/kayan_design_widgets.dart';

import '../helpers/provider_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Home screen widget integration', () {
    testWidgets('renders section header from design system', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: KayanSectionHeader(
                title: 'منتجات مميزة',
                action: 'عرض الكل',
              ),
            ),
          ),
        ),
      );

      expect(find.text('منتجات مميزة'), findsOneWidget);
      expect(find.text('عرض الكل'), findsOneWidget);
    });
  });

  group('Provider-backed home sections', () {
    test('home and cart providers compose for dashboard shell', () async {
      final container = createIntegrationContainer();
      addTearDown(container.dispose);

      final homeSub = keepAlive(container, homeDataProvider);
      addTearDown(homeSub.close);

      final home = await container.read(homeDataProvider.future);
      final cartCount = container.read(cartItemCountProvider);

      expect(home.featuredProducts, isNotEmpty);
      expect(home.recentAds, isNotEmpty);
      expect(cartCount, greaterThanOrEqualTo(0));
    });
  });
}
