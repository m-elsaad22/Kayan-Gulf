// ============================================================
// KAYAN — Dynamic Theme (reads DesignEngineService)
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/super_admin/services/design_engine_service.dart';
import 'app_colors.dart';
import 'app_theme.dart';

abstract class DynamicTheme {
  static Color _hex(String hex) {
    try {
      return AppColors.fromHex(hex.replaceFirst('#', ''));
    } catch (_) {
      return AppColors.royalBlue;
    }
  }

  static Curve curveFromName(String name) {
    switch (name) {
      case 'easeOut':
        return Curves.easeOut;
      case 'easeIn':
        return Curves.easeIn;
      case 'bounceOut':
        return Curves.bounceOut;
      case 'elasticOut':
        return Curves.elasticOut;
      case 'fastOutSlowIn':
        return Curves.fastOutSlowIn;
      case 'linear':
        return Curves.linear;
      case 'decelerate':
        return Curves.decelerate;
      case 'accelerate':
        return Curves.easeIn;
      case 'easeOutCubic':
        return Curves.easeOutCubic;
      case 'easeInCubic':
        return Curves.easeInCubic;
      case 'easeOutBack':
        return Curves.easeOutBack;
      case 'easeInOut':
      default:
        return Curves.easeInOut;
    }
  }

  static TextStyle Function({FontWeight? fontWeight, Color? color, double? fontSize})
      _fontResolver(String family, bool isArabic) {
    switch (family) {
      case 'Cairo':
        return GoogleFonts.cairo;
      case 'Tajawal':
        return GoogleFonts.tajawal;
      case 'Almarai':
        return GoogleFonts.almarai;
      case 'Noto Kufi Arabic':
        return GoogleFonts.notoKufiArabic;
      case 'Poppins':
        return GoogleFonts.poppins;
      case 'Inter':
        return GoogleFonts.inter;
      case 'Roboto':
        return GoogleFonts.roboto;
      case 'Lato':
        return GoogleFonts.lato;
      default:
        return isArabic ? GoogleFonts.cairo : GoogleFonts.poppins;
    }
  }

  static TextTheme _buildTextTheme(DesignSettings s, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final typo = s.typography;
    final ar = _fontResolver(typo.arabicFont, true);
    final en = _fontResolver(typo.englishFont, false);
    TextStyle base(TypographyLevel level, FontWeight weight) {
      final size = level.sizeFor(isDark);
      return en(fontSize: size, fontWeight: weight);
    }

    return TextTheme(
      displayLarge: base(typo.displayLarge, FontWeight.w800),
      displayMedium: base(typo.displayMedium, FontWeight.w700),
      headlineLarge: ar(fontSize: typo.headlineLarge.sizeFor(isDark), fontWeight: FontWeight.w700),
      headlineMedium: ar(fontSize: typo.headlineMedium.sizeFor(isDark), fontWeight: FontWeight.w600),
      titleLarge: base(typo.titleLarge, FontWeight.w600),
      bodyLarge: base(typo.bodyLarge, FontWeight.w400),
      bodyMedium: base(typo.bodyMedium, FontWeight.w400),
      labelLarge: base(typo.labelLarge, FontWeight.w600),
    );
  }

  static ColorScheme _colorScheme(DesignColorPalette p, Brightness brightness) {
    final primary = _hex(p.primary);
    final secondary = _hex(p.secondary);
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: brightness == Brightness.dark ? Colors.white : Colors.white,
      primaryContainer: _hex(p.primaryLight),
      onPrimaryContainer: _hex(p.primaryDark),
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: _hex(p.surfaceVariant),
      onSecondaryContainer: primary,
      tertiary: _hex(p.turquoise),
      onTertiary: Colors.white,
      error: _hex(p.error),
      onError: Colors.white,
      surface: _hex(p.surface),
      onSurface: brightness == Brightness.dark ? Colors.white : _hex(p.primaryDark),
      onSurfaceVariant: _hex(p.primaryLight),
      outline: primary.withValues(alpha: 0.2),
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: _hex(p.surfaceVariant),
      onInverseSurface: primary,
      inversePrimary: _hex(p.primaryLight),
      surfaceTint: primary,
    );
  }

  static ThemeData build(Brightness brightness, {DesignSettings? settings}) {
    final s = settings ?? DesignEngineService.instance.settings;
    final palette = brightness == Brightness.dark ? s.darkColors : s.lightColors;
    final rs = s.radiusShadows;
    final motion = s.motion;
    final base = brightness == Brightness.dark ? AppTheme.dark : AppTheme.light;

    final scheme = _colorScheme(palette, brightness);
    final textTheme = _buildTextTheme(s, brightness);

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: _hex(palette.background),
      canvasColor: _hex(palette.surface),
      primaryColor: scheme.primary,
      textTheme: textTheme,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: _hex(palette.surface),
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: _hex(palette.surface),
        elevation: rs.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rs.cardRadius),
        ),
        shadowColor: scheme.primary.withValues(alpha: 0.15),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: rs.primaryButtonElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rs.primaryButtonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rs.secondaryButtonRadius),
          ),
          side: BorderSide(color: scheme.primary.withValues(alpha: 0.5)),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: _hex(palette.surfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rs.inputRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rs.inputRadius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rs.inputRadius),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _hex(palette.surface),
        elevation: rs.modalElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rs.modalRadius),
        ),
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: _hex(palette.surface),
        elevation: rs.modalElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(rs.modalRadius),
          ),
        ),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: _transitionBuilder(motion),
        },
      ),
      extensions: [
        KayanDesignExtension(
          radiusShadows: rs,
          motion: motion,
          gold: _hex(palette.gold),
          turquoise: _hex(palette.turquoise),
          success: _hex(palette.success),
          warning: _hex(palette.warning),
          info: _hex(palette.info),
        ),
      ],
    );
  }

  static PageTransitionsBuilder _transitionBuilder(MotionSettings motion) {
    final duration = Duration(milliseconds: motion.transitionDurationMs);
    final curve = curveFromName(motion.curveName);

    switch (motion.transitionType) {
      case 'slide':
        return _SlidePageTransitionBuilder(duration: duration, curve: curve);
      case 'scale':
        return _ScalePageTransitionBuilder(duration: duration, curve: curve);
      case 'rotate':
        return _RotatePageTransitionBuilder(duration: duration, curve: curve);
      case 'hero':
        return const ZoomPageTransitionsBuilder();
      case 'fade':
      default:
        return _FadePageTransitionBuilder(duration: duration, curve: curve);
    }
  }

  static ThemeData light([DesignSettings? settings]) =>
      build(Brightness.light, settings: settings);

  static ThemeData dark([DesignSettings? settings]) =>
      build(Brightness.dark, settings: settings);
}

class KayanDesignExtension extends ThemeExtension<KayanDesignExtension> {
  final RadiusShadowSettings radiusShadows;
  final MotionSettings motion;
  final Color gold;
  final Color turquoise;
  final Color success;
  final Color warning;
  final Color info;

  const KayanDesignExtension({
    required this.radiusShadows,
    required this.motion,
    required this.gold,
    required this.turquoise,
    required this.success,
    required this.warning,
    required this.info,
  });

  static KayanDesignExtension of(BuildContext context) {
    return Theme.of(context).extension<KayanDesignExtension>() ??
        KayanDesignExtension(
          radiusShadows: DesignEngineService.instance.settings.radiusShadows,
          motion: DesignEngineService.instance.settings.motion,
          gold: AppColors.lightGold,
          turquoise: AppColors.turquoise,
          success: AppColors.success,
          warning: AppColors.warning,
          info: AppColors.info,
        );
  }

  @override
  KayanDesignExtension copyWith({
    RadiusShadowSettings? radiusShadows,
    MotionSettings? motion,
    Color? gold,
    Color? turquoise,
    Color? success,
    Color? warning,
    Color? info,
  }) =>
      KayanDesignExtension(
        radiusShadows: radiusShadows ?? this.radiusShadows,
        motion: motion ?? this.motion,
        gold: gold ?? this.gold,
        turquoise: turquoise ?? this.turquoise,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        info: info ?? this.info,
      );

  @override
  KayanDesignExtension lerp(ThemeExtension<KayanDesignExtension>? other, double t) {
    if (other is! KayanDesignExtension) return this;
    return other;
  }
}

class _FadePageTransitionBuilder extends PageTransitionsBuilder {
  final Duration duration;
  final Curve curve;
  const _FadePageTransitionBuilder({required this.duration, required this.curve});

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: curve),
      child: child,
    );
  }
}

class _SlidePageTransitionBuilder extends PageTransitionsBuilder {
  final Duration duration;
  final Curve curve;
  const _SlidePageTransitionBuilder({required this.duration, required this.curve});

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero);
    return SlideTransition(
      position: tween.animate(CurvedAnimation(parent: animation, curve: curve)),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

class _ScalePageTransitionBuilder extends PageTransitionsBuilder {
  final Duration duration;
  final Curve curve;
  const _ScalePageTransitionBuilder({required this.duration, required this.curve});

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.94, end: 1).animate(
        CurvedAnimation(parent: animation, curve: curve),
      ),
      child: child,
    );
  }
}

class _RotatePageTransitionBuilder extends PageTransitionsBuilder {
  final Duration duration;
  final Curve curve;
  const _RotatePageTransitionBuilder({required this.duration, required this.curve});

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.02, end: 0).animate(
        CurvedAnimation(parent: animation, curve: curve),
      ),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}
