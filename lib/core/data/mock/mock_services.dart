// TODO: connect to real backend
class MockService {
  final String id;
  final String titleAr;
  final String titleEn;
  final String category;
  final String imageUrl;
  final double startingPrice;
  final double rating;

  const MockService({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.category,
    required this.imageUrl,
    required this.startingPrice,
    required this.rating,
  });
}

const mockServices = [
  MockService(
    id: 'svc-001',
    titleAr: 'صيانة تكييف فورية',
    titleEn: 'Instant AC Maintenance',
    category: 'home',
    imageUrl: '',
    startingPrice: 120,
    rating: 4.9,
  ),
  MockService(
    id: 'svc-002',
    titleAr: 'تنظيف منازل فاخر',
    titleEn: 'Premium Home Cleaning',
    category: 'cleaning',
    imageUrl: '',
    startingPrice: 180,
    rating: 4.8,
  ),
];
