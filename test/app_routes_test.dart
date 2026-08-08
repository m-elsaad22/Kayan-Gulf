import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/routing/app_routes.dart';

void main() {
  group('AppRoutes deep-link compatibility', () {
    test('compat product detail path builder', () {
      expect(
        AppRoutes.compatProductDetailPath('iphone-15'),
        '/shop/product-detail/iphone-15',
      );
    });

    test('compat routes keep legacy URL paths', () {
      expect(AppRoutes.compatProductList, '/shop/product-list');
      expect(AppRoutes.compatProfile, '/profile/classic');
      expect(AppRoutes.compatSettings, '/settings/classic');
      expect(AppRoutes.compatLiveTracking, '/services/live-tracking/:bookingId');
    });

    test('primary routes are defined', () {
      expect(AppRoutes.home, isNotEmpty);
      expect(AppRoutes.shopCart, isNotEmpty);
      expect(AppRoutes.bookingConfirm, isNotEmpty);
    });
  });
}
