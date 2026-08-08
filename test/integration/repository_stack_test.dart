import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/core/di/repository_providers.dart';
import 'package:kayan/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:kayan/features/classifieds/data/repositories/mock_classifieds_repository.dart';
import 'package:kayan/features/ecommerce/product/data/repositories/mock_product_repository.dart';
import 'package:kayan/features/home/data/repositories/mock_home_repository.dart';
import 'package:kayan/features/services/data/repositories/mock_service_repository.dart';

void main() {
  group('Repository provider stack', () {
    test('resolves all mock repositories in default mode', () {
      expect(const MockHomeRepository(), isA<MockHomeRepository>());
      expect(const MockProductRepository(), isA<MockProductRepository>());
      expect(const MockAuthRepository(), isA<MockAuthRepository>());
      expect(const MockServiceRepository(), isA<MockServiceRepository>());
      expect(const MockClassifiedsRepository(), isA<MockClassifiedsRepository>());
    });

    test('repository providers can be overridden independently', () async {
      const customHome = MockHomeRepository();
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(customHome),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(homeRepositoryProvider), same(customHome));
      expect(
        container.read(productRepositoryProvider),
        isA<MockProductRepository>(),
      );
    });
  });
}
