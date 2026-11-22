/// Runtime configuration for API and data sources.
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'KAYAN_API_BASE_URL',
    defaultValue: 'https://api.kayan.gulf/v1',
  );

  /// When true, repositories return local mock data instead of HTTP calls.
  static const bool useMockData = bool.fromEnvironment(
    'KAYAN_USE_MOCK_DATA',
    defaultValue: true,
  );

  /// When true, use Firebase Auth (requires google-services.json).
  /// Set to true after adding your google-services.json from Firebase Console.
  static const bool useFirebaseAuth = bool.fromEnvironment(
    'KAYAN_USE_FIREBASE_AUTH',
    defaultValue: false,
  );

  static const Duration networkTimeout = Duration(seconds: 20);
}
