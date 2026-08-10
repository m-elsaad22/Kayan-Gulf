import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

/// Remote application control (API primary, cPanel emergency fallback).
class AppStatus {
  final bool enabled;
  final bool maintenanceMode;
  final bool forceUpdate;
  final String messageAr;
  final String messageEn;
  final String? supportUrl;
  final String? websiteUrl;
  final String? minVersion;
  final String? latestVersion;
  final String? apkUrl;
  final String? playStoreUrl;
  final String source;
  final bool updateRequired;

  const AppStatus({
    required this.enabled,
    this.maintenanceMode = false,
    this.forceUpdate = false,
    this.messageAr = 'التطبيق متوقف مؤقتًا من لوحة التحكم.',
    this.messageEn = 'The app is temporarily disabled by the publisher.',
    this.supportUrl,
    this.websiteUrl,
    this.minVersion,
    this.latestVersion,
    this.apkUrl,
    this.playStoreUrl,
    this.source = 'unknown',
    this.updateRequired = false,
  });

  bool get isBlocked =>
      !enabled || maintenanceMode || updateRequired;

  factory AppStatus.enabled() => const AppStatus(
        enabled: true,
        source: 'local',
      );

  factory AppStatus.disabled({
    String? messageAr,
    String? messageEn,
    String? supportUrl,
    String source = 'unknown',
  }) =>
      AppStatus(
        enabled: false,
        messageAr: messageAr ?? 'التطبيق متوقف مؤقتًا من لوحة التحكم.',
        messageEn:
            messageEn ?? 'The app is temporarily disabled by the publisher.',
        supportUrl: supportUrl,
        source: source,
      );

  factory AppStatus.fromJson(Map<String, dynamic> j, {required String source}) {
    final enabled = j['enabled'] == true ||
        j['enabled'] == 1 ||
        j['enabled'] == '1' ||
        j['enabled'] == 'true';
    final maintenance = j['maintenanceMode'] == true ||
        j['maintenanceMode'] == 1 ||
        j['maintenanceMode'] == 'true';
    final force = j['forceUpdate'] == true ||
        j['forceUpdate'] == 1 ||
        j['forceUpdate'] == 'true';
    return AppStatus(
      enabled: enabled,
      maintenanceMode: maintenance,
      forceUpdate: force,
      messageAr: (j['messageAr'] as String?)?.trim().isNotEmpty == true
          ? j['messageAr'] as String
          : 'التطبيق متوقف مؤقتًا من لوحة التحكم.',
      messageEn: (j['messageEn'] as String?)?.trim().isNotEmpty == true
          ? j['messageEn'] as String
          : 'The app is temporarily disabled by the publisher.',
      supportUrl: j['supportUrl'] as String? ?? j['website'] as String?,
      websiteUrl: j['websiteUrl'] as String? ?? j['website'] as String?,
      minVersion: j['minVersion'] as String?,
      latestVersion: j['latestVersion'] as String?,
      apkUrl: j['apkUrl'] as String?,
      playStoreUrl: j['playStoreUrl'] as String?,
      source: source,
    );
  }

  AppStatus copyWith({bool? updateRequired, String? messageAr, String? messageEn}) {
    return AppStatus(
      enabled: enabled,
      maintenanceMode: maintenanceMode,
      forceUpdate: forceUpdate,
      messageAr: messageAr ?? this.messageAr,
      messageEn: messageEn ?? this.messageEn,
      supportUrl: supportUrl,
      websiteUrl: websiteUrl,
      minVersion: minVersion,
      latestVersion: latestVersion,
      apkUrl: apkUrl,
      playStoreUrl: playStoreUrl,
      source: source,
      updateRequired: updateRequired ?? this.updateRequired,
    );
  }

  Map<String, dynamic> toCacheJson() => {
        'enabled': enabled,
        'maintenanceMode': maintenanceMode,
        'forceUpdate': forceUpdate,
        'messageAr': messageAr,
        'messageEn': messageEn,
        'supportUrl': supportUrl,
        'websiteUrl': websiteUrl,
        'minVersion': minVersion,
        'latestVersion': latestVersion,
        'apkUrl': apkUrl,
        'playStoreUrl': playStoreUrl,
        'source': source,
      };
}

class AppStatusService {
  AppStatusService._();

  static const _cacheKey = 'kayan_app_status_v1';
  static const _cacheAtKey = 'kayan_app_status_at_v1';
  static const _grace = Duration(hours: 6);

  static AppStatus? _cached;
  static DateTime? _checkedAt;

  static AppStatus? get lastStatus => _cached;

  static bool get isBlocked =>
      AppConfig.requireRemoteStatus && (_cached?.isBlocked ?? false);

  /// API primary → cPanel fallback → last-known-good grace → fail-closed.
  static Future<AppStatus> check({bool force = false}) async {
    if (!AppConfig.requireRemoteStatus) {
      _cached = AppStatus.enabled();
      return _cached!;
    }

    if (!force &&
        _cached != null &&
        _checkedAt != null &&
        DateTime.now().difference(_checkedAt!) < const Duration(minutes: 5)) {
      return _cached!;
    }

    AppStatus? remote;
    try {
      remote = await _fetchApiStatus();
    } catch (e) {
      if (kDebugMode) debugPrint('AppStatus API: $e');
    }

    if (remote == null) {
      try {
        remote = await _fetchCpanelStatus();
      } catch (e) {
        if (kDebugMode) debugPrint('AppStatus cPanel: $e');
      }
    }

    if (remote == null) {
      final grace = await _loadGraceCache();
      if (grace != null) {
        _cached = grace;
        _checkedAt = DateTime.now();
        return _applyVersionGate(_cached!);
      }
      _cached = AppStatus.disabled(
        messageAr:
            'لا يمكن الوصول لخادم التحكم. التطبيق متوقف حتى يعود الاتصال.',
        messageEn:
            'Control server unreachable. The app stays off until status is restored.',
        supportUrl: AppConfig.publisherUrl,
        source: 'offline',
      );
      _checkedAt = DateTime.now();
      return _cached!;
    }

    await _saveGraceCache(remote);
    _cached = await _applyVersionGate(remote);
    _checkedAt = DateTime.now();
    return _cached!;
  }

  static Future<AppStatus> _applyVersionGate(AppStatus status) async {
    if (!status.enabled) return status;
    if (status.maintenanceMode) {
      return status.copyWith(
        messageAr: status.messageAr.isNotEmpty
            ? status.messageAr
            : 'التطبيق تحت الصيانة حاليًا.',
        messageEn: status.messageEn.isNotEmpty
            ? status.messageEn
            : 'The app is under maintenance.',
      );
    }

    final min = status.minVersion?.trim();
    if (min == null || min.isEmpty) return status;

    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version;
      final needsUpdate =
          _compareVersions(current, min) < 0 || status.forceUpdate;
      if (needsUpdate) {
        return status.copyWith(
          updateRequired: true,
          messageAr:
              'يتوفر تحديث مطلوب للمتابعة. الإصدار الأدنى: $min (الحالي: $current)',
          messageEn:
              'A required update is available. Minimum version: $min (current: $current)',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('version gate: $e');
    }
    return status;
  }

  static Future<AppStatus?> _fetchApiStatus() async {
    final base = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/$'), '');
    if (base.isEmpty || base.contains('localhost') && kReleaseMode) {
      // Still attempt — caller may override via dart-define.
    }
    final url = '$base/app/status';
    final map = await _getJson(url);
    if (map == null) return null;
    return AppStatus.fromJson(map, source: 'api');
  }

  static Future<AppStatus?> _fetchCpanelStatus() async {
    final url = AppConfig.statusUrl.trim();
    if (url.isEmpty) return null;
    final map = await _getJson(url);
    if (map == null) return null;
    return AppStatus.fromJson(map, source: 'cpanel');
  }

  static Future<Map<String, dynamic>?> _getJson(String url) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        headers: const {
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
        },
        responseType: ResponseType.plain,
        validateStatus: (s) => s != null && s < 500,
      ),
    );
    final res = await dio.get<String>(url);
    if (res.statusCode != 200 || res.data == null) return null;
    final decoded = jsonDecode(res.data!.trim());
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return null;
  }

  static Future<void> _saveGraceCache(AppStatus status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(status.toCacheJson()));
      await prefs.setString(_cacheAtKey, DateTime.now().toIso8601String());
    } catch (_) {}
  }

  static Future<AppStatus?> _loadGraceCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      final atRaw = prefs.getString(_cacheAtKey);
      if (raw == null || atRaw == null) return null;
      final at = DateTime.tryParse(atRaw);
      if (at == null || DateTime.now().difference(at) > _grace) return null;
      final map = jsonDecode(raw);
      if (map is! Map) return null;
      return AppStatus.fromJson(
        Map<String, dynamic>.from(map),
        source: 'grace-cache',
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns negative if a < b, 0 if equal, positive if a > b.
  static int _compareVersions(String a, String b) {
    List<int> parts(String v) => v
        .split(RegExp(r'[^0-9]+'))
        .where((p) => p.isNotEmpty)
        .map(int.parse)
        .toList();
    final pa = parts(a);
    final pb = parts(b);
    final n = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < n; i++) {
      final x = i < pa.length ? pa[i] : 0;
      final y = i < pb.length ? pb[i] : 0;
      if (x != y) return x - y;
    }
    return 0;
  }
}
