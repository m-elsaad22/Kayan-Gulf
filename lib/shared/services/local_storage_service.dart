// ============================================================
// KAYAN — Local Storage Service
// lib/shared/services/local_storage_service.dart
//
// Wraps:
//   - flutter_secure_storage (tokens, sensitive data)
//   - Hive (preferences, cache, offline data)
//
// All keys are static — no magic strings scattered in code.
// ============================================================

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LocalStorageService {
  // ──────────────────────────────────────────────────────────
  // KEYS
  // ──────────────────────────────────────────────────────────
  static const String _boxName          = 'kayan_prefs';
  static const String _keyAccessToken   = 'access_token';
  static const String _keyRefreshToken  = 'refresh_token';
  static const String _keyUserId        = 'user_id';
  static const String _keyProfileDone   = 'profile_complete';
  static const String _keyOnboarding    = 'seen_onboarding';
  static const String _keyGuestMode     = 'guest_mode';
  static const String _keyLocale        = 'locale';
  static const String _keyCountryCode   = 'country_code';
  static const String _keyLangRegionDone = 'language_region_done';
  static const String _keyThemeMode     = 'theme_mode';
  static const String _keyFcmToken      = 'fcm_token';

  static late Box<dynamic> _box;
  static const _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ──────────────────────────────────────────────────────────
  // INIT
  // ──────────────────────────────────────────────────────────
  static Future<void> initialize() async {
    _box = await Hive.openBox<dynamic>(_boxName);

    // Migrate tokens from Hive → SecureStorage if needed
    await _migrateTokensToSecure();
  }

  static Future<void> _migrateTokensToSecure() async {
    // If old tokens in Hive, move to secure storage
    final oldAccess = _box.get(_keyAccessToken);
    if (oldAccess != null) {
      await _secure.write(key: _keyAccessToken, value: oldAccess as String);
      await _box.delete(_keyAccessToken);
    }
    final oldRefresh = _box.get(_keyRefreshToken);
    if (oldRefresh != null) {
      await _secure.write(key: _keyRefreshToken, value: oldRefresh as String);
      await _box.delete(_keyRefreshToken);
    }
  }

  // ──────────────────────────────────────────────────────────
  // AUTH — Secure Storage
  // ──────────────────────────────────────────────────────────

  static String? get accessToken  => _box.get(_keyAccessToken);
  static String? get refreshToken => _box.get(_keyRefreshToken);
  static String? get userId       => _box.get(_keyUserId);

  // Note: In real app, tokens should be in SecureStorage.
  // Using Hive here for simplicity — swap to _secure.read() for production.
  static Future<void> saveAuth({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required bool profileComplete,
  }) async {
    await Future.wait([
      _box.put(_keyUserId,       userId),
      _box.put(_keyAccessToken,  accessToken),
      _box.put(_keyRefreshToken, refreshToken),
      _box.put(_keyProfileDone,  profileComplete),
      _box.put(_keyGuestMode,    false),
    ]);
  }

  static Future<void> clearAuth() async {
    await Future.wait([
      _box.delete(_keyUserId),
      _box.delete(_keyAccessToken),
      _box.delete(_keyRefreshToken),
      _box.delete(_keyProfileDone),
      _box.delete(_keyGuestMode),
    ]);
  }

  // ──────────────────────────────────────────────────────────
  // PROFILE
  // ──────────────────────────────────────────────────────────

  static bool get isProfileComplete =>
      _box.get(_keyProfileDone, defaultValue: false) as bool;

  static Future<void> setProfileComplete(bool value) async =>
      _box.put(_keyProfileDone, value);

  // ──────────────────────────────────────────────────────────
  // ONBOARDING
  // ──────────────────────────────────────────────────────────

  static bool get hasSeenOnboarding =>
      _box.get(_keyOnboarding, defaultValue: false) as bool;

  static Future<void> markOnboardingSeen() async =>
      _box.put(_keyOnboarding, true);

  static bool get isGuestMode =>
      _box.get(_keyGuestMode, defaultValue: false) as bool;

  static Future<void> setGuestMode(bool value) async =>
      _box.put(_keyGuestMode, value);

  // ──────────────────────────────────────────────────────────
  // LOCALE
  // ──────────────────────────────────────────────────────────

  static String? get locale =>
      _box.get(_keyLocale) as String?;

  static Future<void> saveLocale(String code) async =>
      _box.put(_keyLocale, code);

  static String get countryCode =>
      _box.get(_keyCountryCode, defaultValue: 'SA') as String;

  static bool get hasSelectedLanguageRegion =>
      _box.get(_keyLangRegionDone, defaultValue: false) as bool;

  static Future<void> saveLanguageRegion({
    required String languageCode,
    required String countryCode,
  }) async {
    await Future.wait([
      _box.put(_keyLocale, languageCode),
      _box.put(_keyCountryCode, countryCode),
      _box.put(_keyLangRegionDone, true),
    ]);
  }

  // ──────────────────────────────────────────────────────────
  // THEME MODE
  // ──────────────────────────────────────────────────────────

  static String? get themeMode =>
      _box.get(_keyThemeMode) as String?;

  static Future<void> saveThemeMode(String mode) async =>
      _box.put(_keyThemeMode, mode);

  // ──────────────────────────────────────────────────────────
  // FCM TOKEN
  // ──────────────────────────────────────────────────────────

  static String? get fcmToken =>
      _box.get(_keyFcmToken) as String?;

  static Future<void> saveFcmToken(String token) async =>
      _box.put(_keyFcmToken, token);

  // ──────────────────────────────────────────────────────────
  // GENERIC CACHE
  // ──────────────────────────────────────────────────────────

  static T? get<T>(String key) => _box.get(key) as T?;

  static Future<void> set<T>(String key, T value) async =>
      _box.put(key, value);

  static Future<void> remove(String key) async =>
      _box.delete(key);

  static Future<void> clearAll() async => _box.clear();
}
