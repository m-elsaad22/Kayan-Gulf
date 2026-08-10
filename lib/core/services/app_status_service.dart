import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

/// Remote app control from cPanel / publisher website.
class AppStatus {
  final bool enabled;
  final String messageAr;
  final String messageEn;
  final String? supportUrl;
  final String? minVersion;

  const AppStatus({
    required this.enabled,
    this.messageAr = 'التطبيق متوقف مؤقتًا من لوحة التحكم.',
    this.messageEn = 'The app is temporarily disabled by the publisher.',
    this.supportUrl,
    this.minVersion,
  });

  factory AppStatus.enabled() => const AppStatus(enabled: true);

  factory AppStatus.disabled({
    String? messageAr,
    String? messageEn,
    String? supportUrl,
  }) =>
      AppStatus(
        enabled: false,
        messageAr: messageAr ?? 'التطبيق متوقف مؤقتًا من لوحة التحكم.',
        messageEn:
            messageEn ?? 'The app is temporarily disabled by the publisher.',
        supportUrl: supportUrl,
      );

  factory AppStatus.fromJson(Map<String, dynamic> j) {
    final enabled = j['enabled'] == true ||
        j['enabled'] == 1 ||
        j['enabled'] == '1' ||
        j['enabled'] == 'true';
    return AppStatus(
      enabled: enabled,
      messageAr: (j['messageAr'] as String?)?.trim().isNotEmpty == true
          ? j['messageAr'] as String
          : 'التطبيق متوقف مؤقتًا من لوحة التحكم.',
      messageEn: (j['messageEn'] as String?)?.trim().isNotEmpty == true
          ? j['messageEn'] as String
          : 'The app is temporarily disabled by the publisher.',
      supportUrl: j['supportUrl'] as String? ?? j['website'] as String?,
      minVersion: j['minVersion'] as String?,
    );
  }
}

class AppStatusService {
  AppStatusService._();

  static AppStatus? _cached;
  static DateTime? _checkedAt;

  static AppStatus? get lastStatus => _cached;

  static bool get isBlocked =>
      AppConfig.requireRemoteStatus && (_cached?.enabled == false);

  /// Fail-closed: missing/unreachable status file ⇒ app disabled
  /// (so deleting the file on cPanel stops installs).
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

    final url = AppConfig.statusUrl.trim();
    if (url.isEmpty) {
      _cached = AppStatus.disabled(
        messageAr: 'رابط حالة التطبيق غير مضبوط.',
        messageEn: 'App status URL is not configured.',
      );
      _checkedAt = DateTime.now();
      return _cached!;
    }

    try {
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
      if (res.statusCode == 404 || res.statusCode == 403) {
        _cached = AppStatus.disabled(
          messageAr:
              'تم إيقاف التطبيق أو حذف ملف التحكم من الخادم. تواصل مع المطور.',
          messageEn:
              'App control file is missing on the server. Contact the publisher.',
          supportUrl: AppConfig.publisherUrl,
        );
      } else if (res.statusCode != 200 || res.data == null) {
        _cached = AppStatus.disabled(
          messageAr: 'تعذر التحقق من حالة التطبيق. حاول لاحقًا.',
          messageEn: 'Could not verify app status. Try again later.',
          supportUrl: AppConfig.publisherUrl,
        );
      } else {
        final raw = res.data!.trim();
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          _cached = AppStatus.fromJson(decoded);
        } else if (decoded is Map) {
          _cached = AppStatus.fromJson(Map<String, dynamic>.from(decoded));
        } else {
          _cached = AppStatus.disabled(
            supportUrl: AppConfig.publisherUrl,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('AppStatusService: $e');
      // Fail-closed: offline / DNS / SSL / deleted host path
      _cached = AppStatus.disabled(
        messageAr:
            'لا يمكن الوصول لخادم التحكم. التطبيق متوقف حتى يعود الملف على الموقع.',
        messageEn:
            'Control server unreachable. The app stays off until status is restored.',
        supportUrl: AppConfig.publisherUrl,
      );
    }

    _checkedAt = DateTime.now();
    return _cached!;
  }
}
