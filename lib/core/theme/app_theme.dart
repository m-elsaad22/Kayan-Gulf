// KAYAN Super App — ThemeData (light-first, KayanDesignTokens)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/admin_data_service.dart';
import 'app_border_radius.dart';
import 'app_spacing.dart';
import 'kayan_design_tokens.dart';

abstract class AppTheme {
  static const SystemUiOverlayStyle systemUiDark = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: KayanDesignTokens.kBlueDeep,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  static const SystemUiOverlayStyle systemUiLight = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: KayanDesignTokens.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static TextTheme _textTheme(Brightness brightness) {
    final fg = brightness == Brightness.dark ? Colors.white : KayanDesignTokens.text;
    final muted = brightness == Brightness.dark ? Colors.white70 : KayanDesignTokens.text2;
    return TextTheme(
      displayLarge: KayanDesignTokens.cairo(fontSize: 32, fontWeight: FontWeight.w800, color: fg),
      displayMedium: KayanDesignTokens.cairo(fontSize: 28, fontWeight: FontWeight.w700, color: fg),
      headlineLarge: KayanDesignTokens.cairo(fontSize: 24, fontWeight: FontWeight.w700, color: fg),
      headlineMedium: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w700, color: fg),
      titleLarge: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w700, color: fg),
      titleMedium: KayanDesignTokens.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: fg),
      bodyLarge: KayanDesignTokens.cairo(fontSize: 16, fontWeight: FontWeight.w500, color: fg),
      bodyMedium: KayanDesignTokens.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: fg),
      bodySmall: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w500, color: muted),
      labelLarge: KayanDesignTokens.cairo(fontSize: 14, fontWeight: FontWeight.w700, color: fg),
      labelMedium: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: muted),
      labelSmall: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w600, color: muted),
    );
  }

  static ColorScheme _scheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: KayanDesignTokens.kBlueLight,
        onPrimary: Colors.white,
        primaryContainer: KayanDesignTokens.kBlueDeep,
        onPrimaryContainer: Colors.white,
        secondary: KayanDesignTokens.gold,
        onSecondary: KayanDesignTokens.kBlueDeep,
        secondaryContainer: Color(0xFF2A2010),
        onSecondaryContainer: KayanDesignTokens.gold,
        tertiary: KayanDesignTokens.kGreenLight,
        onTertiary: Colors.white,
        error: KayanDesignTokens.danger,
        onError: Colors.white,
        surface: Color(0xFF132038),
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white70,
        outline: Color(0x33FFFFFF),
        shadow: Colors.black,
        scrim: Colors.black54,
        inverseSurface: KayanDesignTokens.surface,
        onInverseSurface: KayanDesignTokens.text,
        inversePrimary: KayanDesignTokens.kBlue,
        surfaceTint: KayanDesignTokens.kBlueLight,
      );
    }

    return const ColorScheme(
      brightness: Brightness.light,
      primary: KayanDesignTokens.kBlue,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE8F0FA),
      onPrimaryContainer: KayanDesignTokens.kBlueDeep,
      secondary: KayanDesignTokens.kBlueLight,
      onSecondary: Colors.white,
      secondaryContainer: KayanDesignTokens.bg,
      onSecondaryContainer: KayanDesignTokens.kBlue,
      tertiary: KayanDesignTokens.kGreen,
      onTertiary: Colors.white,
      error: KayanDesignTokens.danger,
      onError: Colors.white,
      surface: KayanDesignTokens.surface,
      onSurface: KayanDesignTokens.text,
      onSurfaceVariant: KayanDesignTokens.text2,
      outline: KayanDesignTokens.border,
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: KayanDesignTokens.kBlueDeep,
      onInverseSurface: Colors.white,
      inversePrimary: KayanDesignTokens.kBlueLight,
      surfaceTint: KayanDesignTokens.kBlue,
    );
  }

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = _scheme(brightness);
    final textTheme = _textTheme(brightness);
    final surface = scheme.surface;
    final onSurface = scheme.onSurface;
    final border = isDark ? scheme.outline : KayanDesignTokens.border;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? KayanDesignTokens.kBlueDeep : KayanDesignTokens.bg,
      canvasColor: surface,
      primaryColor: scheme.primary,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: isDark ? systemUiDark : systemUiLight,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: onSurface, size: 22),
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: isDark ? Colors.white54 : KayanDesignTokens.muted,
        elevation: isDark ? 0 : 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w700),
        unselectedLabelStyle: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w500),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: scheme.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStatePropertyAll(
          KayanDesignTokens.cairo(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 22);
          }
          return IconThemeData(color: isDark ? Colors.white54 : KayanDesignTokens.muted, size: 22);
        }),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isDark ? 0 : 2,
        shadowColor: scheme.primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          side: BorderSide(color: border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.button),
          textStyle: KayanDesignTokens.cairo(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.button),
          textStyle: KayanDesignTokens.cairo(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: KayanDesignTokens.cairo(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1A2840) : KayanDesignTokens.bg,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        hintStyle: textTheme.bodyMedium?.copyWith(color: KayanDesignTokens.muted),
        labelStyle: textTheme.bodyMedium,
        errorStyle: textTheme.bodySmall?.copyWith(color: KayanDesignTokens.danger),
        border: OutlineInputBorder(borderRadius: AppBorderRadius.input, borderSide: BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: AppBorderRadius.input, borderSide: BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.input,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.input,
          borderSide: const BorderSide(color: KayanDesignTokens.danger),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? const Color(0xFF1A2840) : KayanDesignTokens.bg,
        selectedColor: scheme.primary.withValues(alpha: 0.15),
        labelStyle: textTheme.labelMedium!,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.pill),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.dialog),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.bottomSheet),
        dragHandleColor: border,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1A2840) : KayanDesignTokens.kBlueDeep,
        contentTextStyle: KayanDesignTokens.cairo(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.md),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: isDark ? Colors.white54 : KayanDesignTokens.muted,
        indicatorColor: scheme.primary,
        dividerColor: border,
        labelStyle: KayanDesignTokens.cairo(fontWeight: FontWeight.w700),
        unselectedLabelStyle: KayanDesignTokens.cairo(fontWeight: FontWeight.w500),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: isDark ? Colors.white12 : KayanDesignTokens.border,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.1),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return isDark ? Colors.white54 : KayanDesignTokens.muted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary.withValues(alpha: 0.35);
          return isDark ? Colors.white12 : KayanDesignTokens.border;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(scheme.onPrimary),
        side: BorderSide(color: border, width: 1.5),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return border;
        }),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: isDark ? Colors.white70 : KayanDesignTokens.text2,
        textColor: onSurface,
        tileColor: Colors.transparent,
        selectedTileColor: scheme.primary.withValues(alpha: 0.08),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.md,
          side: BorderSide(color: border),
        ),
        textStyle: textTheme.bodyMedium,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: KayanDesignTokens.kBlueDeep,
          borderRadius: AppBorderRadius.sm,
        ),
        textStyle: KayanDesignTokens.cairo(fontSize: 12, color: Colors.white),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: surface,
        scrimColor: Colors.black54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(KayanDesignTokens.radiusM)),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: isDark ? Colors.white70 : KayanDesignTokens.text2,
        collapsedIconColor: isDark ? Colors.white54 : KayanDesignTokens.muted,
        textColor: onSurface,
        collapsedTextColor: onSurface,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.3),
        selectionHandleColor: scheme.primary,
      ),
    );
  }

  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData get light => _build(Brightness.light);

  static ThemeData lightWithAdmin(AdminThemeColors? colors) {
    if (colors == null) return light;
    final primary = KayanDesignTokens.colorFromHex(colors.primaryHex);
    final accent = KayanDesignTokens.colorFromHex(colors.accentHex);
    return light.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: accent,
      ),
      primaryColor: primary,
    );
  }

  static ThemeData darkWithAdmin(AdminThemeColors? colors) {
    if (colors == null) return dark;
    final primary = KayanDesignTokens.colorFromHex(colors.primaryHex);
    return dark.copyWith(
      colorScheme: dark.colorScheme.copyWith(primary: primary),
      primaryColor: primary,
    );
  }
}

// Decoration helpers for custom widgets
BoxDecoration get kayanPrimaryButtonDecoration => BoxDecoration(
      gradient: KayanDesignTokens.gradBlue,
      borderRadius: AppBorderRadius.button,
      boxShadow: KayanDesignTokens.shadowS,
    );

BoxDecoration get kayanGoldButtonDecoration => BoxDecoration(
      gradient: KayanDesignTokens.gradGold,
      borderRadius: AppBorderRadius.button,
      boxShadow: [
        BoxShadow(
          color: KayanDesignTokens.gold.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );

BoxDecoration get kayanCardDecoration => BoxDecoration(
      color: KayanDesignTokens.surface,
      borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
      border: Border.all(color: KayanDesignTokens.border),
      boxShadow: KayanDesignTokens.shadowS,
    );

BoxDecoration get kayanPremiumCardDecoration => BoxDecoration(
      color: KayanDesignTokens.surface,
      borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
      border: Border.all(color: KayanDesignTokens.gold.withValues(alpha: 0.5)),
      boxShadow: [
        BoxShadow(
          color: KayanDesignTokens.gold.withValues(alpha: 0.12),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );

BoxDecoration get kayanActiveCardDecoration => BoxDecoration(
      color: KayanDesignTokens.surface,
      borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
      border: Border.all(color: KayanDesignTokens.kBlue, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: KayanDesignTokens.kBlue.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
