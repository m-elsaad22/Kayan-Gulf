import '../../../../core/data/mock_data_catalog.dart';
import '../../../../core/services/admin_data_service.dart';
import '../../browse/data/models/service_models.dart';
import 'service_repository.dart';

/// Local mock implementation — swap for [RemoteServiceRepository] when API is ready.
class MockServiceRepository implements ServiceRepository {
  const MockServiceRepository();

  @override
  Future<List<ServiceCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDataCatalog.serviceCategories;
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
    return match ?? MockDataCatalog.serviceDetail(slug);
  }

  @override
  Future<List<BookingModel>> getBookings({String? status}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockDataCatalog.bookingsByStatus(status);
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDataCatalog.bookings.firstWhere(
      (b) => b.id == id,
      orElse: () => MockDataCatalog.bookings.first,
    );
  }

  @override
  Future<BookingModel> createBooking({
    required String serviceId,
    required DateTime scheduledAt,
    required String addressLine,
    String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return BookingModel(
      id: 'b-${DateTime.now().millisecondsSinceEpoch}',
      bookingNumber: 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      serviceNameAr: 'خدمة محلية',
      serviceNameEn: 'Local service',
      serviceId: serviceId,
      price: 120,
      scheduledAt: scheduledAt,
      status: 'CONFIRMED',
      addressLine: addressLine,
      notes: notes,
    );
  }

  @override
  Future<BookingModel> updateBookingStatus(String id, String status) async {
    final booking = await getBooking(id);
    return BookingModel(
      id: booking.id,
      bookingNumber: booking.bookingNumber,
      serviceNameAr: booking.serviceNameAr,
      serviceNameEn: booking.serviceNameEn,
      serviceId: booking.serviceId,
      price: booking.price,
      currency: booking.currency,
      scheduledAt: booking.scheduledAt,
      status: status,
      addressLine: booking.addressLine,
      notes: booking.notes,
      technician: booking.technician,
    );
  }
}
