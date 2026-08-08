import '../../../../core/services/admin_data_service.dart';
import '../../browse/data/models/service_models.dart';
import 'service_repository.dart';

/// Local mock implementation — swap for [RemoteServiceRepository] when API is ready.
class MockServiceRepository implements ServiceRepository {
  const MockServiceRepository();

  @override
  Future<List<ServiceCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockServiceCategories;
  }

  @override
  Future<List<ServiceDetailModel>> getServices({String? categorySlug}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AdminDataService.instance.getServiceDetails(categorySlug: categorySlug);
  }

  @override
  Future<ServiceDetailModel> getServiceDetail(String slug) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final services = AdminDataService.instance.getServiceDetails();
    final match = services.where((s) => s.slug == slug).firstOrNull;
    return match ?? mockServiceDetail(slug);
  }

  @override
  Future<List<BookingModel>> getBookings({String? status}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (status == null || status.isEmpty) return mockBookings;
    return mockBookings.where((b) => b.status == status).toList();
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockBookings.firstWhere(
      (b) => b.id == id,
      orElse: () => mockBookings.first,
    );
  }
}
