import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../../core/firebase/firebase_bootstrap.dart';

/// Thin Analytics wrapper — no-ops when Firebase is disabled.
abstract final class AnalyticsService {
  static FirebaseAnalytics? _analytics;

  static Future<void> initialize() async {
    if (!FirebaseBootstrap.isReady) return;
    try {
      _analytics = FirebaseAnalytics.instance;
      await _analytics!.setAnalyticsCollectionEnabled(true);
    } catch (e) {
      if (kDebugMode) debugPrint('Analytics init skipped: $e');
    }
  }

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (_analytics == null) {
      if (kDebugMode) debugPrint('[analytics:$name] $parameters');
      return;
    }
    await _analytics!.logEvent(name: name, parameters: parameters);
  }

  static Future<void> logLogin(String method) =>
      logEvent('login', parameters: {'method': method});

  static Future<void> logPurchase({
    required String orderId,
    required double value,
    String currency = 'SAR',
  }) =>
      logEvent(
        'purchase',
        parameters: {
          'transaction_id': orderId,
          'value': value,
          'currency': currency,
        },
      );
}
