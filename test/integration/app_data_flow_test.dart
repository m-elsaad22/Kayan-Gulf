import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/features/auth/presentation/providers/auth_providers.dart';
import 'package:kayan/features/classifieds/presentation/providers/classifieds_providers.dart';
import 'package:kayan/features/ecommerce/product/presentation/providers/product_providers.dart';
import 'package:kayan/features/home/presentation/providers/home_providers.dart';
import 'package:kayan/features/services/presentation/providers/service_providers.dart';

import '../helpers/provider_container.dart';

void main() {
  group('Home → Product integration', () {
    late ProviderContainer container;

    setUp(() {
      container = createIntegrationContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('loads home dashboard then product catalog', () async {
      final homeSub = keepAlive(container, homeDataProvider);
      final productSub = keepAlive(container, productListProvider);
      addTearDown(homeSub.close);
      addTearDown(productSub.close);

      final home = await container.read(homeDataProvider.future);
      final products = await container.read(productListProvider.future);

      expect(home.banners, isNotEmpty);
      expect(home.flashDeals, isNotEmpty);
      expect(products, isNotEmpty);
    });

    test('product filter changes refresh catalog', () async {
      final productSub = keepAlive(container, productListProvider);
      addTearDown(productSub.close);

      container.read(productFilterProvider.notifier).setSort(SortOption.priceAsc);
      final products = await container.read(productListProvider.future);

      if (products.length >= 2) {
        expect(
          products.first.price <= products.last.price,
          isTrue,
        );
      }
    });
  });

  group('Auth OTP integration', () {
    late ProviderContainer container;

    setUp(() {
      container = createIntegrationContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('send and verify OTP returns authenticated user payload', () async {
      final sendSub = keepAlive(container, sendOtpProvider);
      final verifySub = keepAlive(container, verifyOtpProvider);
      addTearDown(sendSub.close);
      addTearDown(verifySub.close);

      final sent = await container.read(sendOtpProvider.notifier).sendOtp('+966501234567');
      expect(sent, isTrue);

      final result = await container
          .read(verifyOtpProvider.notifier)
          .verifyOtp('+966501234567', '123456');
      expect(result.success, isTrue);
      expect(result.userId, isNotNull);
      expect(result.accessToken, isNotEmpty);
      expect(result.refreshToken, isNotEmpty);
    });
  });

  group('Classifieds and services integration', () {
    late ProviderContainer container;

    setUp(() {
      container = createIntegrationContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('loads ads, services, and bookings together', () async {
      final adsSub = keepAlive(
        container,
        adsListProvider(const AdFilter()),
      );
      final servicesSub = keepAlive(container, servicesListProvider(null));
      final bookingsSub = keepAlive(container, serviceBookingsProvider(null));
      addTearDown(adsSub.close);
      addTearDown(servicesSub.close);
      addTearDown(bookingsSub.close);

      final ads = await container.read(adsListProvider(const AdFilter()).future);
      final services = await container.read(servicesListProvider(null).future);
      final bookings = await container.read(serviceBookingsProvider(null).future);

      expect(ads, isNotEmpty);
      expect(services, isNotEmpty);
      expect(bookings, isNotEmpty);
    });

    test('featured and similar ads providers resolve', () async {
      final featuredSub = keepAlive(container, featuredAdsProvider);
      addTearDown(featuredSub.close);

      final featured = await container.read(featuredAdsProvider.future);
      expect(featured, isNotEmpty);

      final slug = featured.first.slug;
      final similarSub = keepAlive(container, similarAdsProvider(slug));
      addTearDown(similarSub.close);

      final similar = await container.read(similarAdsProvider(slug).future);
      expect(similar, isNotEmpty);
    });
  });
}
