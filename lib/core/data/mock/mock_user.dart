// TODO: connect to real backend
class MockUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String countryCode;
  final bool isGuest;

  const MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.countryCode,
    this.isGuest = false,
  });
}

const mockGuestUser = MockUser(
  id: 'guest',
  name: 'ضيف كيان',
  email: '',
  phone: '',
  countryCode: 'SA',
  isGuest: true,
);

const mockSignedInUser = MockUser(
  id: 'user-001',
  name: 'عميل كيان',
  email: 'customer@kayan.sa',
  phone: '+966500000000',
  countryCode: 'SA',
);
