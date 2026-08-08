import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/core/data/mock_data_catalog.dart';

void main() {
  group('MockDataCatalog', () {
    test('exposes product seed data', () {
      expect(MockDataCatalog.productCategories, isNotEmpty);
      expect(MockDataCatalog.products, isNotEmpty);
    });

    test('exposes classifieds seed data', () {
      expect(MockDataCatalog.adCategories, isNotEmpty);
      expect(MockDataCatalog.ads, isNotEmpty);
      expect(MockDataCatalog.myAds, isNotEmpty);
    });

    test('finds ad by slug', () {
      final ad = MockDataCatalog.adBySlug(MockDataCatalog.ads.first.slug);
      expect(ad, isNotNull);
      expect(ad!.slug, MockDataCatalog.ads.first.slug);
    });

    test('filters ads by category', () {
      final electronics = MockDataCatalog.adsByCategory('electronics');
      expect(electronics, isNotEmpty);
      expect(electronics.every((a) => a.categorySlug == 'electronics'), isTrue);
    });

    test('exposes services seed data', () {
      expect(MockDataCatalog.serviceCategories, isNotEmpty);
      expect(MockDataCatalog.bookings, isNotEmpty);
      expect(MockDataCatalog.serviceDetail('ac').slug, 'ac');
    });

    test('filters bookings by status', () {
      final confirmed = MockDataCatalog.bookingsByStatus('CONFIRMED');
      expect(confirmed.every((b) => b.status == 'CONFIRMED'), isTrue);
    });

    test('exposes user seed data', () {
      expect(MockDataCatalog.guestUser.isGuest, isTrue);
      expect(MockDataCatalog.signedInUser.email, isNotEmpty);
    });
  });
}
