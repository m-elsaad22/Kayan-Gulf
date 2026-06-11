// ============================================================
// KAYAN Super App — Root Application Widget
// lib/app.dart
//
// KayanApp is the root ConsumerWidget:
//   • Watches GoRouter (Riverpod provider)
//   • Watches locale (ar / en) → sets RTL or LTR Directionality
//   • Watches themeMode (dark / light / system) → default dark
//   • Wraps everything in MaterialApp.router
//   • Custom scroll behavior (no glow, bouncing physics)
//   • Global MediaQuery text-scale clamp (accessibility safe)
// ============================================================

import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/admin_data_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/dynamic_theme.dart';
import 'features/super_admin/services/design_engine_service.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/providers/theme_provider.dart';

// ──────────────────────────────────────────────────────────────
// ROOT WIDGET
// ──────────────────────────────────────────────────────────────
class KayanApp extends ConsumerWidget {
  const KayanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router    = ref.watch(appRouterProvider);
    final locale    = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return ValueListenableBuilder<int>(
      valueListenable: AdminDataService.instance.revisionNotifier,
      builder: (context, _, __) {
        return ValueListenableBuilder<int>(
          valueListenable: DesignEngineService.instance.revisionNotifier,
          builder: (context, _, __) {
        final isArabic  = locale.languageCode == 'ar';
        final appName   = AdminDataService.instance.getAppName();
        final design    = DesignEngineService.instance.settings;
        final fontScale = AdminDataService.instance.getFontSettings().bodyScale;

        return MaterialApp.router(
      // ── Identity ────────────────────────────────────────
      title:                    appName,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid:    false,

      // ── Theme ───────────────────────────────────────────
      // Dynamic design engine (Super Admin) + legacy admin fallback merge
      theme:      DynamicTheme.light(design),
      darkTheme:  DynamicTheme.dark(design),
      themeMode:  themeMode,

      // ── Localization ────────────────────────────────────
      locale: locale,
      supportedLocales: const [
        Locale('ar', 'SA'),     // Arabic – Saudi Arabia (default)
        Locale('ar', 'AE'),     // Arabic – UAE
        Locale('ar', 'QA'),     // Arabic – Qatar
        Locale('ar', 'KW'),     // Arabic – Kuwait
        Locale('ar', 'BH'),     // Arabic – Bahrain
        Locale('ar', 'OM'),     // Arabic – Oman
        Locale('en', 'US'),     // English
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supported) {
        if (deviceLocale == null) return const Locale('ar', 'SA');
        // Match by language code first
        for (final locale in supported) {
          if (locale.languageCode == deviceLocale.languageCode) {
            return locale;
          }
        }
        // Fallback to Arabic
        return const Locale('ar', 'SA');
      },

      // ── Routing ─────────────────────────────────────────
      routerConfig: router,

      // ── Global builder ──────────────────────────────────
      // Applies:
      //   1. RTL/LTR Directionality based on locale
      //   2. Custom scroll behavior
      //   3. Text scale clamping (prevent huge accessibility text breaking layout)
      builder: (context, child) {
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: MediaQuery(
            // Clamp text scale between 0.85x and 1.3x
            // Prevents UI breakage from extreme accessibility settings
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(context).textScaler.clamp(
                minScaleFactor: 0.85 * fontScale,
                maxScaleFactor: 1.3 * fontScale,
              ),
            ),
            child: ScrollConfiguration(
              behavior: const _KayanScrollBehavior(),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
          },
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CUSTOM SCROLL BEHAVIOR
//
// Removes the blue glow overscroll effect on Android.
// Uses BouncingScrollPhysics for an iOS-feel on all platforms.
// ──────────────────────────────────────────────────────────────
class _KayanScrollBehavior extends ScrollBehavior {
  const _KayanScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // No overscroll glow on any platform
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    // Allow mouse + touch (for desktop/web testing)
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  };
}
