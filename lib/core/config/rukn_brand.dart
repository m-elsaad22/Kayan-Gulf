import 'app_config.dart';

/// Official Rukn El Tatawer / KAYAN public links.
///
/// **Single source of truth for website identity.** Screens must not hardcode
/// these URLs — use [RuknBrand] (or [AppConfig] aliases).
///
/// The live marketing site today is https://www.rukn-eltatawer.com/
/// Future API/Admin hosts are configured separately and are NOT assumed live.
abstract final class RuknBrand {
  static const String companyNameAr = 'ركن التطور';
  static const String companyNameEn = 'Rukn El Tatawer';
  static const String appNameAr = 'كيان';
  static const String appNameEn = 'KAYAN';

  /// Official website (exists today).
  static const String websiteUrl = String.fromEnvironment(
    'KAYAN_WEBSITE_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/',
  );

  static const String supportUrl = String.fromEnvironment(
    'KAYAN_SUPPORT_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/',
  );

  static const String privacyUrl = String.fromEnvironment(
    'KAYAN_PRIVACY_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/privacy',
  );

  static const String termsUrl = String.fromEnvironment(
    'KAYAN_TERMS_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/terms',
  );

  /// Direct APK / download landing (WordPress page or file URL — configure later).
  static const String appDownloadUrl = String.fromEnvironment(
    'KAYAN_APP_DOWNLOAD_URL',
    defaultValue: 'https://www.rukn-eltatawer.com/kayan/',
  );

  /// Optional WhatsApp deep link (`https://wa.me/9665…`). Empty = hide CTA.
  static const String whatsappUrl = String.fromEnvironment(
    'KAYAN_WHATSAPP_URL',
    defaultValue: '',
  );

  /// `tel:` target without scheme, e.g. `+966920012345`. Empty = hide call CTA.
  static const String phoneUrl = String.fromEnvironment(
    'KAYAN_PHONE_URL',
    defaultValue: '',
  );

  static const String supportEmail = String.fromEnvironment(
    'KAYAN_SUPPORT_EMAIL',
    defaultValue: 'info@rukn-eltatawer.com',
  );

  /// Future NestJS API base (NOT deployed until DNS + server exist).
  /// Override with `--dart-define=KAYAN_API_BASE_URL=…` for every environment.
  static const String futureApiBaseUrl = 'https://api.rukn-eltatawer.com/v1';

  /// Future admin host (NOT deployed until DNS exists).
  static const String futureAdminUrl = 'https://admin.rukn-eltatawer.com';

  /// Emergency AppControl fallback path on the WordPress/cPanel site.
  static String get statusFallbackUrl => AppConfig.statusUrl;

  static Uri websiteUri() => Uri.parse(websiteUrl);
  static Uri supportUri() => Uri.parse(supportUrl);
  static Uri privacyUri() => Uri.parse(privacyUrl);
  static Uri termsUri() => Uri.parse(termsUrl);
  static Uri appDownloadUri() => Uri.parse(appDownloadUrl);

  static Uri? whatsappUri() {
    final raw = whatsappUrl.trim();
    if (raw.isEmpty) return null;
    return Uri.tryParse(raw);
  }

  static Uri? phoneUri() {
    final raw = phoneUrl.trim();
    if (raw.isEmpty) return null;
    final digits = raw.startsWith('tel:') ? raw : 'tel:$raw';
    return Uri.tryParse(digits);
  }

  static Uri? mailtoUri() {
    final e = supportEmail.trim();
    if (e.isEmpty) return null;
    return Uri(scheme: 'mailto', path: e);
  }
}
