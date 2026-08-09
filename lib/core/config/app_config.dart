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

  /// When true, initialize Firebase (requires `lib/firebase_options.dart`
  /// from `flutterfire configure` and real `google-services.json`).
  static const bool enableFirebase = bool.fromEnvironment(
    'KAYAN_ENABLE_FIREBASE',
    defaultValue: false,
  );

  static const Duration networkTimeout = Duration(seconds: 20);
}
