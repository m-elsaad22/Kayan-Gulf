import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/mock_auth_repository.dart';
import '../../features/auth/data/repositories/remote_auth_repository.dart';
import '../../features/ecommerce/product/data/repositories/mock_product_repository.dart';
import '../../features/ecommerce/product/data/repositories/product_repository.dart';
import '../../features/ecommerce/product/data/repositories/remote_product_repository.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/data/repositories/mock_home_repository.dart';
import '../../features/home/data/repositories/remote_home_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  if (AppConfig.useMockData) {
    return const MockHomeRepository();
  }
  return RemoteHomeRepository(ref.watch(apiClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  if (AppConfig.useMockData) {
    return const MockProductRepository();
  }
  return RemoteProductRepository(ref.watch(apiClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (AppConfig.useMockData) {
    return const MockAuthRepository();
  }
  return RemoteAuthRepository(ref.watch(apiClientProvider));
});
