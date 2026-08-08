import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/core/config/app_config.dart';
import 'package:kayan/features/home/data/repositories/mock_home_repository.dart';

void main() {
  group('AppConfig', () {
    test('defaults to mock data mode', () {
      expect(AppConfig.useMockData, isTrue);
    });

    test('has API base URL', () {
      expect(AppConfig.apiBaseUrl, isNotEmpty);
    });
  });

  group('MockHomeRepository', () {
    test('returns populated home sections', () async {
      const repo = MockHomeRepository();
      final data = await repo.getHomeData();

      expect(data.banners, isNotEmpty);
      expect(data.ecommerceCategories.length, greaterThanOrEqualTo(4));
      expect(data.flashDeals, isNotEmpty);
      expect(data.featuredServices, isNotEmpty);
      expect(data.recentAds, isNotEmpty);
    });
  });
}
