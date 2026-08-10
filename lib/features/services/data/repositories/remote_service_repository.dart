import '../../../../core/network/api_client.dart';
import '../../browse/data/models/service_models.dart';
import 'service_repository.dart';

/// HTTP implementation — ready to connect when backend is live.
class RemoteServiceRepository implements ServiceRepository {
  const RemoteServiceRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<ServiceCategory>> getCategories() async {
    final json = await _client.getJson('/services/categories');
    final items = json['items'] as List? ?? json['data'] as List? ?? [];
    return items
        .map((e) => ServiceCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ServiceDetailModel>> getServices({String? categorySlug}) async {
    final json = await _client.getJson(
      '/services',
      query: {
        if (categorySlug != null && categorySlug.isNotEmpty)
          'categorySlug': categorySlug,
      },
    );
    final items = json['items'] as List? ?? json['data'] as List? ?? [];
    return items
        .map((e) => ServiceDetailModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ServiceDetailModel> getServiceDetail(String slug) async {
    final json = await _client.getJson('/services/$slug');
    final data = json['service'] as Map<String, dynamic>? ?? json;
    return ServiceDetailModel.fromJson(data);
  }

  @override
  Future<List<BookingModel>> getBookings({String? status}) async {
    final json = await _client.getJson(
      '/bookings',
      query: {if (status != null && status.isNotEmpty) 'status': status},
    );
    final items = json['items'] as List? ?? json['data'] as List? ?? [];
    return items
        .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    final json = await _client.getJson('/bookings/$id');
    final data = json['booking'] as Map<String, dynamic>? ?? json;
    return BookingModel.fromJson(data);
  }

  @override
  Future<BookingModel> createBooking({
    required String serviceId,
    required DateTime scheduledAt,
    required String addressLine,
    String? notes,
  }) async {
    final json = await _client.postJson(
      '/bookings',
      body: {
        'serviceId': serviceId,
        'scheduledAt': scheduledAt.toIso8601String(),
        'addressLine': addressLine,
        if (notes != null) 'notes': notes,
      },
    );
    return BookingModel.fromJson(json);
  }

  @override
  Future<BookingModel> updateBookingStatus(String id, String status) async {
    final json = await _client.patchJson(
      '/bookings/$id/status',
      body: {'status': status},
    );
    return BookingModel.fromJson(json);
  }
}
