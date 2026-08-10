// ============================================================
// KAYAN — Local Storage Service
// Tokens → FlutterSecureStorage; prefs/cache → Hive
// ============================================================

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LocalStorageService {
  static const String _boxName = 'kayan_prefs';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyProfileDone = 'profile_complete';
  static const String _keyOnboarding = 'seen_onboarding';
  static const String _keyGuestMode = 'guest_mode';
  static const String _keyLocale = 'locale';
  static const String _keyCountryCode = 'country_code';
  static const String _keyLangRegionDone = 'language_region_done';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyFcmToken = 'fcm_token';

  static late Box<dynamic> _box;
  static const _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// In-memory cache so interceptors can read tokens synchronously.
  static String? _accessTokenCache;
  static String? _refreshTokenCache;
  static String? _userIdCache;

  static Future<void> initialize() async {
    _box = await Hive.openBox<dynamic>(_boxName);
    await _migrateTokensToSecure();
    await _hydrateTokenCache();
  }

  static Future<void> _migrateTokensToSecure() async {
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
    // Never keep tokens in Hive going forward.
    await _box.delete(_keyAccessToken);
    await _box.delete(_keyRefreshToken);
  }

  static Future<void> _hydrateTokenCache() async {
    _accessTokenCache = await _secure.read(key: _keyAccessToken);
    _refreshTokenCache = await _secure.read(key: _keyRefreshToken);
    _userIdCache = _box.get(_keyUserId) as String?;
  }

  static String? get accessToken => _accessTokenCache;
  static String? get refreshToken => _refreshTokenCache;
  static String? get userId => _userIdCache ?? _box.get(_keyUserId) as String?;

  static Future<void> saveAuth({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required bool profileComplete,
  }) async {
    await Future.wait([
      _secure.write(key: _keyAccessToken, value: accessToken),
      _secure.write(key: _keyRefreshToken, value: refreshToken),
      _box.put(_keyUserId, userId),
      _box.put(_keyProfileDone, profileComplete),
      _box.put(_keyGuestMode, false),
      _box.delete(_keyAccessToken),
      _box.delete(_keyRefreshToken),
    ]);
    _accessTokenCache = accessToken;
    _refreshTokenCache = refreshToken;
    _userIdCache = userId;
  }

  static Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secure.write(key: _keyAccessToken, value: accessToken),
      _secure.write(key: _keyRefreshToken, value: refreshToken),
    ]);
    _accessTokenCache = accessToken;
    _refreshTokenCache = refreshToken;
  }

  static Future<void> clearAuth() async {
    await Future.wait([
      _secure.delete(key: _keyAccessToken),
      _secure.delete(key: _keyRefreshToken),
      _box.delete(_keyUserId),
      _box.delete(_keyProfileDone),
      _box.delete(_keyGuestMode),
      _box.delete(_keyAccessToken),
      _box.delete(_keyRefreshToken),
    ]);
    _accessTokenCache = null;
    _refreshTokenCache = null;
    _userIdCache = null;
  }

  static bool get isProfileComplete =>
      _box.get(_keyProfileDone, defaultValue: false) as bool;

  static Future<void> setProfileComplete(bool value) async =>
      _box.put(_keyProfileDone, value);

  static bool get hasSeenOnboarding =>
      _box.get(_keyOnboarding, defaultValue: false) as bool;

  static Future<void> markOnboardingSeen() async =>
      _box.put(_keyOnboarding, true);

  static bool get isGuestMode =>
      _box.get(_keyGuestMode, defaultValue: false) as bool;

  static Future<void> setGuestMode(bool value) async =>
      _box.put(_keyGuestMode, value);

  static String? get locale => _box.get(_keyLocale) as String?;

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

  static String? get themeMode => _box.get(_keyThemeMode) as String?;

  static Future<void> saveThemeMode(String mode) async =>
      _box.put(_keyThemeMode, mode);

  static String? get fcmToken => _box.get(_keyFcmToken) as String?;

  static Future<void> saveFcmToken(String token) async =>
      _box.put(_keyFcmToken, token);

  static T? get<T>(String key) => _box.get(key) as T?;

  static Future<void> set<T>(String key, T value) async =>
      _box.put(key, value);

  static Future<void> remove(String key) async => _box.delete(key);

  static Future<void> clearAll() async {
    await clearAuth();
    await _box.clear();
  }
}
