// ============================================================
// KAYAN — Theme Mode Provider
// lib/shared/providers/theme_provider.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final saved = LocalStorageService.themeMode;
    return switch (saved) {
      'light'  => ThemeMode.light,
      'system' => ThemeMode.system,
      _        => ThemeMode.light, // KAYAN default: light (production)
    };
  }

  void setDark()   => _set(ThemeMode.dark);
  void setLight()  => _set(ThemeMode.light);
  void setSystem() => _set(ThemeMode.system);

  void _set(ThemeMode mode) {
    LocalStorageService.saveThemeMode(switch (mode) {
      ThemeMode.dark   => 'dark',
      ThemeMode.light  => 'light',
      ThemeMode.system => 'system',
    });
    state = mode;
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
