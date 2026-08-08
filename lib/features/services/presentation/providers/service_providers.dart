import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/repository_providers.dart';
import '../../browse/data/models/service_models.dart';

final serviceCategoriesProvider =
    FutureProvider.autoDispose<List<ServiceCategory>>((ref) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return repo.getCategories();
});

final servicesListProvider =
    FutureProvider.autoDispose.family<List<ServiceDetailModel>, String?>(
  (ref, categoryId) async {
    final repo = ref.watch(serviceRepositoryProvider);
    return repo.getServices(categorySlug: categoryId);
  },
);

final serviceDetailProvider =
    FutureProvider.autoDispose.family<ServiceDetailModel, String>(
  (ref, slug) async {
    final repo = ref.watch(serviceRepositoryProvider);
    return repo.getServiceDetail(slug);
  },
);

final serviceBookingsProvider =
    FutureProvider.autoDispose.family<List<BookingModel>, String?>(
  (ref, status) async {
    final repo = ref.watch(serviceRepositoryProvider);
    return repo.getBookings(status: status);
  },
);

final serviceBookingProvider =
    FutureProvider.autoDispose.family<BookingModel, String>(
  (ref, id) async {
    final repo = ref.watch(serviceRepositoryProvider);
    return repo.getBooking(id);
  },
);
