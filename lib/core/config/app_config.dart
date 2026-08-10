/// Runtime configuration for API, distribution, and remote control.
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'KAYAN_API_BASE_URL',
    defaultValue: 'https://api.kayan.gulf/v1',
  );

  /// When true, repositories return local mock data instead of HTTP calls.
  /// Distribution APKs for cPanel-only hosting typically use `true`.
  static const bool useMockData = bool.fromEnvironment(
    'KAYAN_USE_MOCK_DATA',
    defaultValue: true,
  );

  /// When true, initialize Firebase (requires FlutterFire options).
  static const bool enableFirebase = bool.fromEnvironment(
    'KAYAN_ENABLE_FIREBASE',
    defaultValue: false,
  );

  /// Remote kill-switch JSON/PHP on cPanel (e.g. rukn-eltatawer.com).
  /// If unreachable or `enabled: false`, the app stops (fail-closed).
  static const String statusUrl = String.fromEnvironment(
    'KAYAN_STATUS_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/kayan/status.json',
  );

  /// Publisher / company website shown on disabled screen & About.
  static const String publisherUrl = String.fromEnvironment(
    'KAYAN_PUBLISHER_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/',
  );

  /// Optional Google OAuth Web client ID (server) for idToken on Android/iOS.
  static const String googleServerClientId = String.fromEnvironment(
    'KAYAN_GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  /// When false, skip remote status check (local/dev only).
  static const bool requireRemoteStatus = bool.fromEnvironment(
    'KAYAN_REQUIRE_REMOTE_STATUS',
    defaultValue: true,
  );

  static const Duration networkTimeout = Duration(seconds: 20);
}
