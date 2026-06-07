// TODO: connect to real backend
class MockAd {
  final String id;
  final String titleAr;
  final String titleEn;
  final String city;
  final String imageUrl;
  final double price;
  final bool featured;

  const MockAd({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.city,
    required this.imageUrl,
    required this.price,
    this.featured = false,
  });
}

const mockAds = [
  MockAd(
    id: 'ad-001',
    titleAr: 'شقة فاخرة في الرياض',
    titleEn: 'Luxury Apartment in Riyadh',
    city: 'الرياض',
    imageUrl: '',
    price: 420000,
    featured: true,
  ),
  MockAd(
    id: 'ad-002',
    titleAr: 'سيارة عائلية ممتازة',
    titleEn: 'Excellent Family Car',
    city: 'جدة',
    imageUrl: '',
    price: 76000,
  ),
];
