import 'rukn_brand.dart';

/// Runtime configuration for API, distribution, and remote control.
///
/// Production release builds MUST set via `--dart-define` / build scripts:
/// - `KAYAN_ENV=production`
/// - `KAYAN_USE_MOCK_DATA=false`
/// - `KAYAN_API_BASE_URL=https://api.rukn-eltatawer.com/v1` (when that host exists)
/// - `KAYAN_GOOGLE_SERVER_CLIENT_ID=<web-client-id>`
/// - `KAYAN_REQUIRE_REMOTE_STATUS=true`
///
/// Public website links live in [RuknBrand] — do not hardcode them in widgets.
abstract final class AppConfig {
  /// NestJS API base including `/v1`.
  ///
  /// Default points at the **planned** production host
  /// (`https://api.rukn-eltatawer.com/v1`). That hostname is **not live** until
  /// DNS + server are provisioned — builds must still pass an explicit URL when
  /// targeting a real environment (see `scripts/build_production_apk.sh`).
  static const String apiBaseUrl = String.fromEnvironment(
    'KAYAN_API_BASE_URL',
    defaultValue: RuknBrand.futureApiBaseUrl,
  );

  /// When true, repositories return local mock data instead of HTTP calls.
  /// Production / Play Store builds MUST set this to false via dart-define.
  /// Sideload demo APKs may keep true (see `build_distribution_apk.sh`).
  static const bool useMockData = bool.fromEnvironment(
    'KAYAN_USE_MOCK_DATA',
    defaultValue: true,
  );

  static const bool enableFirebase = bool.fromEnvironment(
    'KAYAN_ENABLE_FIREBASE',
    defaultValue: false,
  );

  /// Emergency cPanel fallback (NOT primary AppControl authority).
  /// File is prepared in-repo; upload to cPanel is a manual ops step.
  static const String statusUrl = String.fromEnvironment(
    'KAYAN_STATUS_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/kayan/status.json',
  );

  /// Alias of [RuknBrand.websiteUrl] (kept for existing call sites).
  static const String publisherUrl = String.fromEnvironment(
    'KAYAN_PUBLISHER_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/',
  );

  static const String googleServerClientId = String.fromEnvironment(
    'KAYAN_GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  static const bool requireRemoteStatus = bool.fromEnvironment(
    'KAYAN_REQUIRE_REMOTE_STATUS',
    defaultValue: true,
  );

  /// `development` | `staging` | `production`
  static const String environment = String.fromEnvironment(
    'KAYAN_ENV',
    defaultValue: 'development',
  );

  static bool get isProductionEnv => environment == 'production';

  static bool get isProductionBuild =>
      isProductionEnv ||
      (!useMockData &&
          !apiBaseUrl.contains('127.0.0.1') &&
          !apiBaseUrl.contains('localhost'));

  /// Forbidden hosts in production binaries.
  static bool get apiLooksLikeDevHost =>
      apiBaseUrl.contains('127.0.0.1') ||
      apiBaseUrl.contains('localhost') ||
      apiBaseUrl.contains('10.0.2.2') ||
      apiBaseUrl.contains('kayan.gulf');

  static const Duration networkTimeout = Duration(seconds: 20);
}
