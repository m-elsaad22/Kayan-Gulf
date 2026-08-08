import '../../browse/data/models/service_models.dart';

/// Contract for loading services and bookings data.
abstract class ServiceRepository {
  Future<List<ServiceCategory>> getCategories();

  Future<List<ServiceDetailModel>> getServices({String? categorySlug});

  Future<ServiceDetailModel> getServiceDetail(String slug);

  Future<List<BookingModel>> getBookings({String? status});

  Future<BookingModel> getBooking(String id);
}
