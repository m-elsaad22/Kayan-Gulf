/// Runtime configuration for API, distribution, and remote control.
///
/// Production release builds should set:
/// - `KAYAN_USE_MOCK_DATA=false`
/// - `KAYAN_API_BASE_URL=https://<your-api>/v1`
/// - `KAYAN_GOOGLE_SERVER_CLIENT_ID=<web-client-id>`
/// - `KAYAN_REQUIRE_REMOTE_STATUS=true`
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'KAYAN_API_BASE_URL',
    defaultValue: 'https://api.kayan.gulf/v1',
  );

  /// When true, repositories return local mock data instead of HTTP calls.
  /// Production / Play Store builds MUST set this to false via dart-define.
  /// Sideload “demo” APKs may keep true (see build_distribution_apk.sh).
  static const bool useMockData = bool.fromEnvironment(
    'KAYAN_USE_MOCK_DATA',
    defaultValue: true,
  );

  /// When true, initialize Firebase (requires FlutterFire options).
  static const bool enableFirebase = bool.fromEnvironment(
    'KAYAN_ENABLE_FIREBASE',
    defaultValue: false,
  );

  /// Emergency cPanel fallback JSON/PHP (not primary authority).
  static const String statusUrl = String.fromEnvironment(
    'KAYAN_STATUS_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/kayan/status.json',
  );

  /// Publisher / company website shown on disabled screen & About.
  static const String publisherUrl = String.fromEnvironment(
    'KAYAN_PUBLISHER_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/',
  );

  /// Google OAuth Web client ID (server) — required for idToken on Android.
  static const String googleServerClientId = String.fromEnvironment(
    'KAYAN_GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  /// When false, skip remote status check (local/dev only).
  static const bool requireRemoteStatus = bool.fromEnvironment(
    'KAYAN_REQUIRE_REMOTE_STATUS',
    defaultValue: true,
  );

  /// Environment label for diagnostics: development | staging | production
  static const String environment = String.fromEnvironment(
    'KAYAN_ENV',
    defaultValue: 'development',
  );

  static bool get isProductionBuild =>
      environment == 'production' || (!useMockData && !apiBaseUrl.contains('127.0.0.1'));

  static const Duration networkTimeout = Duration(seconds: 20);
}
