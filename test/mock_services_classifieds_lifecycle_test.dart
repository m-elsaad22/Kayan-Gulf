import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/features/classifieds/data/repositories/mock_classifieds_repository.dart';
import 'package:kayan/features/services/data/repositories/mock_service_repository.dart';

void main() {
  test('MockServiceRepository creates booking', () async {
    const repo = MockServiceRepository();
    final booking = await repo.createBooking(
      serviceId: 'svc-1',
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
      addressLine: 'الرياض',
    );
    expect(booking.bookingNumber, startsWith('BK-'));
    expect(booking.status, 'CONFIRMED');
  });

  test('MockClassifiedsRepository creates ad', () async {
    const repo = MockClassifiedsRepository();
    final ad = await repo.createAd(
      title: 'جهاز تجريبي',
      city: 'جدة',
      categorySlug: 'electronics',
      price: 100,
    );
    expect(ad.title, 'جهاز تجريبي');
    expect(ad.city, 'جدة');
  });
}
