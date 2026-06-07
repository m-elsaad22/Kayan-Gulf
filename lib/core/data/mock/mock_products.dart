// TODO: connect to real backend
class MockProduct {
  final String id;
  final String titleAr;
  final String titleEn;
  final String category;
  final String imageUrl;
  final double price;
  final double rating;

  const MockProduct({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });
}

const mockProducts = [
  MockProduct(
    id: 'prod-001',
    titleAr: 'عطر خليجي فاخر',
    titleEn: 'Luxury Gulf Perfume',
    category: 'beauty',
    imageUrl: '',
    price: 249,
    rating: 4.8,
  ),
  MockProduct(
    id: 'prod-002',
    titleAr: 'ساعة ذكية بريميوم',
    titleEn: 'Premium Smart Watch',
    category: 'electronics',
    imageUrl: '',
    price: 699,
    rating: 4.7,
  ),
];
