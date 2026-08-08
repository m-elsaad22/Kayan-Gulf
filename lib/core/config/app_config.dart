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

  static const Duration networkTimeout = Duration(seconds: 20);
}
