import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/mock_auth_repository.dart';
import '../../features/auth/data/repositories/remote_auth_repository.dart';
import '../../features/classifieds/data/repositories/classifieds_repository.dart';
import '../../features/classifieds/data/repositories/mock_classifieds_repository.dart';
import '../../features/classifieds/data/repositories/remote_classifieds_repository.dart';
import '../../features/ecommerce/cart/data/repositories/cart_repository.dart';
import '../../features/ecommerce/cart/data/repositories/mock_cart_repository.dart';
import '../../features/ecommerce/cart/data/repositories/remote_cart_repository.dart';
import '../../features/ecommerce/orders/data/repositories/mock_order_repository.dart';
import '../../features/ecommerce/orders/data/repositories/order_repository.dart';
import '../../features/ecommerce/orders/data/repositories/remote_order_repository.dart';
import '../../features/ecommerce/product/data/repositories/mock_product_repository.dart';
import '../../features/ecommerce/product/data/repositories/product_repository.dart';
import '../../features/ecommerce/product/data/repositories/remote_product_repository.dart';
import '../../features/services/data/repositories/mock_service_repository.dart';
import '../../features/services/data/repositories/remote_service_repository.dart';
import '../../features/services/data/repositories/service_repository.dart';
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

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  if (AppConfig.useMockData) {
    return MockCartRepository();
  }
  return RemoteCartRepository(ref.watch(apiClientProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  if (AppConfig.useMockData) {
    return MockOrderRepository();
  }
  return RemoteOrderRepository(ref.watch(apiClientProvider));
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  if (AppConfig.useMockData) {
    return const MockServiceRepository();
  }
  return RemoteServiceRepository(ref.watch(apiClientProvider));
});

final classifiedsRepositoryProvider = Provider<ClassifiedsRepository>((ref) {
  if (AppConfig.useMockData) {
    return const MockClassifiedsRepository();
  }
  return RemoteClassifiedsRepository(ref.watch(apiClientProvider));
});
