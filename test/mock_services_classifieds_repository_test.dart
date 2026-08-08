import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/features/classifieds/data/repositories/mock_classifieds_repository.dart';
import 'package:kayan/features/classifieds/domain/ad_filter.dart';
import 'package:kayan/features/services/data/repositories/mock_service_repository.dart';

void main() {
  group('MockServiceRepository', () {
    const repo = MockServiceRepository();

    test('returns service categories', () async {
      final categories = await repo.getCategories();
      expect(categories, isNotEmpty);
      expect(categories.first.slug, isNotEmpty);
    });

    test('returns services list', () async {
      final services = await repo.getServices();
      expect(services, isNotEmpty);
    });

    test('filters services by category', () async {
      final services = await repo.getServices(categorySlug: 'ac');
      expect(services, isNotEmpty);
    });

    test('returns service detail', () async {
      final detail = await repo.getServiceDetail('ac');
      expect(detail.slug, 'ac');
      expect(detail.nameAr, isNotEmpty);
    });

    test('returns bookings', () async {
      final bookings = await repo.getBookings();
      expect(bookings, isNotEmpty);
    });

    test('filters bookings by status', () async {
      final confirmed = await repo.getBookings(status: 'CONFIRMED');
      expect(confirmed.every((b) => b.status == 'CONFIRMED'), isTrue);
    });
  });

  group('MockClassifiedsRepository', () {
    const repo = MockClassifiedsRepository();

    test('returns ad categories', () async {
      final categories = await repo.getCategories();
      expect(categories.length, greaterThanOrEqualTo(5));
    });

    test('returns ads with filter', () async {
      final ads = await repo.getAds(const AdFilter());
      expect(ads, isNotEmpty);
    });

    test('filters ads by category', () async {
      final ads = await repo.getAds(
        const AdFilter(categorySlug: 'electronics'),
      );
      expect(ads.every((a) => a.categorySlug == 'electronics'), isTrue);
    });

    test('returns ad detail', () async {
      final list = await repo.getAds(const AdFilter());
      final detail = await repo.getAdDetail(list.first.slug);
      expect(detail.slug, list.first.slug);
    });

    test('returns my ads', () async {
      final myAds = await repo.getMyAds();
      expect(myAds, isNotEmpty);
    });

    test('returns featured ads', () async {
      final featured = await repo.getFeaturedAds();
      expect(featured, isNotEmpty);
    });
  });
}
