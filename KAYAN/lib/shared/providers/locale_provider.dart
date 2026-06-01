// ============================================================
// KAYAN — Locale & Theme Mode Providers
// lib/shared/providers/locale_provider.dart
// lib/shared/providers/theme_provider.dart
// (Combined for convenience)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

// ──────────────────────────────────────────────────────────────
// LOCALE PROVIDER
// ──────────────────────────────────────────────────────────────

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final saved = LocalStorageService.locale;
    return saved != null ? Locale(saved) : const Locale('ar', 'SA');
  }

  void setArabic() => _set(const Locale('ar', 'SA'));
  void setEnglish() => _set(const Locale('en', 'US'));

  void setLocale(String languageCode, [String? countryCode]) {
    _set(countryCode != null
        ? Locale(languageCode, countryCode)
        : Locale(languageCode));
  }

  void _set(Locale locale) {
    LocalStorageService.saveLocale(locale.languageCode);
    state = locale;
  }
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

/// Convenience: is current locale Arabic?
final isArabicProvider = Provider<bool>((ref) {
  return ref.watch(localeProvider).languageCode == 'ar';
});
