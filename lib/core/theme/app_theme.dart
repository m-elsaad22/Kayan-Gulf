// ============================================================
// KAYAN Super App — Complete ThemeData
// lib/core/theme/app_theme.dart
//
// Primary: Dark Mode (Royal Navy + Royal Blue + Metallic Gold)
// Secondary: Light Mode (optional fallback)
//
// Covers all Material 3 component themes:
//   AppBar, BottomNav, NavigationBar, Buttons (3 types),
//   InputDecoration, Card, Chip, Dialog, BottomSheet,
//   SnackBar, TabBar, Divider, Slider, Switch, Checkbox,
//   Radio, ListTile, Icon, FAB, PopupMenu, Tooltip,
//   Scrollbar, Drawer, ExpansionTile, PageTransitions
// ============================================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_data_service.dart';
import 'app_colors.dart';
import 'app_gradients.dart';
import 'app_text_styles.dart';
import 'app_border_radius.dart';
import 'app_spacing.dart';

abstract class AppTheme {
  // ──────────────────────────────────────────────────────────
  // 📱 SYSTEM UI OVERLAY STYLE
  // (Status bar appearance)
  // ──────────────────────────────────────────────────────────

  static const SystemUiOverlayStyle systemUiDark = SystemUiOverlayStyle(
    statusBarColor:               Colors.transparent,
    statusBarIconBrightness:      Brightness.light,
    statusBarBrightness:          Brightness.dark,
    systemNavigationBarColor:     AppColors.bgSurface,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor:   Colors.transparent,
  );

  static const SystemUiOverlayStyle systemUiLight = SystemUiOverlayStyle(
    statusBarColor:               Colors.transparent,
    statusBarIconBrightness:      Brightness.dark,
    statusBarBrightness:          Brightness.light,
    systemNavigationBarColor:     Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  // ──────────────────────────────────────────────────────────
  // 🌑 DARK THEME (Primary — الثيم الأساسي)
  // ──────────────────────────────────────────────────────────

  static ThemeData get dark => ThemeData(
    useMaterial3:              true,
    brightness:                Brightness.dark,
    colorScheme:               AppColors.darkColorScheme,

    // ── Scaffold ────────────────────────────────────────────
    scaffoldBackgroundColor:   AppColors.bgScaffold,
    canvasColor:               AppColors.bgPrimary,
    dialogBackgroundColor:     AppColors.bgModal,
    indicatorColor:            AppColors.royalBlue,

    // ── Typography ──────────────────────────────────────────
    textTheme:                 AppTextStyles.textTheme,
    fontFamily:                GoogleFonts.inter().fontFamily,

    // ──────────────────────────────────────────────────────
    // APP BAR
    // ──────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor:          AppColors.bgSurface,
      foregroundColor:          AppColors.textPrimary,
      elevation:                0,
      scrolledUnderElevation:   0,
      centerTitle:              true,
      iconTheme:                const IconThemeData(
        color: AppColors.textPrimary,
        size: 22,
      ),
      actionsIconTheme:         const IconThemeData(
        color: AppColors.textPrimary,
        size: 22,
      ),
      titleTextStyle:           AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      systemOverlayStyle:       systemUiDark,
      shape: const Border(
        bottom: BorderSide(
          color: AppColors.borderSubtle,
          width: 1,
        ),
      ),
      surfaceTintColor:         Colors.transparent,
    ),

    // ──────────────────────────────────────────────────────
    // BOTTOM NAVIGATION BAR
    // ──────────────────────────────────────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:          AppColors.navBackground,
      selectedItemColor:        AppColors.navActive,
      unselectedItemColor:      AppColors.navInactive,
      elevation:                0,
      type:                     BottomNavigationBarType.fixed,
      showSelectedLabels:       true,
      showUnselectedLabels:     true,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ──────────────────────────────────────────────────────
    // NAVIGATION BAR (Material 3)
    // ──────────────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:          AppColors.navBackground,
      surfaceTintColor:         Colors.transparent,
      indicatorColor:           AppColors.royalBlue.withOpacity(0.15),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: AppColors.navActive, size: 22);
        }
        return const IconThemeData(color: AppColors.navInactive, size: 22);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.navActive,
          );
        }
        return GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.navInactive,
        );
      }),
      height:               64,
      labelBehavior:        NavigationDestinationLabelBehavior.alwaysShow,
      elevation:            0,
      overlayColor:         MaterialStateProperty.all(AppColors.royalBlue.withOpacity(0.06)),
    ),

    // ──────────────────────────────────────────────────────
    // ELEVATED BUTTON (Primary CTA)
    // Background: Royal Blue gradient
    // ──────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.royalBlue.withOpacity(0.25);
          }
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF3558C8);
          }
          return AppColors.royalBlue;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.textDisabled;
          }
          return AppColors.textPrimary;
        }),
        overlayColor: MaterialStateProperty.all(
          AppColors.whiteOp(0.08),
        ),
        elevation: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) return 0;
          return 4;
        }),
        shadowColor: MaterialStateProperty.all(
          AppColors.royalBlue.withOpacity(0.4),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: AppBorderRadius.button,
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
        ),
        textStyle: MaterialStateProperty.all(AppTextStyles.buttonMedium),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 52)),
        maximumSize: MaterialStateProperty.all(const Size(double.infinity, 52)),
        animationDuration: const Duration(milliseconds: 200),
        splashFactory: InkRipple.splashFactory,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),

    // ──────────────────────────────────────────────────────
    // OUTLINED BUTTON (Secondary CTA)
    // Border: Royal Blue, transparent background
    // ──────────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.textDisabled;
          }
          return AppColors.royalBlue;
        }),
        overlayColor: MaterialStateProperty.all(
          AppColors.royalBlue.withOpacity(0.06),
        ),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return const BorderSide(color: AppColors.borderSubtle, width: 1);
          }
          if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
            return const BorderSide(color: AppColors.royalBlue, width: 1.5);
          }
          return const BorderSide(color: AppColors.borderActive, width: 1.5);
        }),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppBorderRadius.button),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        ),
        textStyle: MaterialStateProperty.all(AppTextStyles.buttonMedium),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 52)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),

    // ──────────────────────────────────────────────────────
    // TEXT BUTTON (Tertiary CTA, links)
    // ──────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.textDisabled;
          }
          return AppColors.skyBlue;
        }),
        overlayColor: MaterialStateProperty.all(
          AppColors.royalBlue.withOpacity(0.08),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
        ),
        textStyle: MaterialStateProperty.all(
          AppTextStyles.buttonMedium.copyWith(color: AppColors.skyBlue),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        ),
      ),
    ),

    // ──────────────────────────────────────────────────────
    // INPUT / TEXT FIELD
    // ──────────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled:          true,
      fillColor:       AppColors.bgInput,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textMuted,
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
        if (states.contains(MaterialState.error)) {
          return AppTextStyles.bodySmall.copyWith(color: AppColors.error);
        }
        if (states.contains(MaterialState.focused)) {
          return AppTextStyles.bodySmall.copyWith(color: AppColors.skyBlue);
        }
        return AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary);
      }),
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.error,
      ),
      helperStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textMuted,
      ),
      prefixIconColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.focused)) return AppColors.skyBlue;
        return AppColors.textMuted;
      }),
      suffixIconColor: AppColors.textMuted,

      // Borders
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.input,
        borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.input,
        borderSide: const BorderSide(color: AppColors.borderDefault, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.input,
        borderSide: const BorderSide(color: AppColors.borderActiveBold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.input,
        borderSide: const BorderSide(color: AppColors.borderError, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.input,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.input,
        borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      isDense: false,
    ),

    // ──────────────────────────────────────────────────────
    // CARD
    // ──────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color:          AppColors.bgCard,
      elevation:      0,
      margin:         EdgeInsets.zero,
      shape:          RoundedRectangleBorder(
        borderRadius: AppBorderRadius.card,
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      clipBehavior:   Clip.antiAlias,
      surfaceTintColor: Colors.transparent,
    ),

    // ──────────────────────────────────────────────────────
    // CHIP
    // ──────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor:   AppColors.bgCard2,
      labelStyle:        AppTextStyles.labelMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      side:              const BorderSide(color: AppColors.borderSubtle, width: 1),
      shape:             RoundedRectangleBorder(
        borderRadius: AppBorderRadius.pill,
      ),
      padding:           const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      selectedColor:     AppColors.royalBlue.withOpacity(0.2),
      checkmarkColor:    AppColors.skyBlue,
      showCheckmark:     false,
      elevation:         0,
      pressElevation:    0,
      deleteIconColor:   AppColors.textMuted,
      brightness:        Brightness.dark,
      surfaceTintColor:  Colors.transparent,
    ),

    // ──────────────────────────────────────────────────────
    // DIALOG
    // ──────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor:  AppColors.bgModal,
      elevation:        24,
      shadowColor:      Colors.black54,
      surfaceTintColor: Colors.transparent,
      shape:            RoundedRectangleBorder(
        borderRadius: AppBorderRadius.xl,
      ),
      titleTextStyle:   AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // ──────────────────────────────────────────────────────
    // BOTTOM SHEET
    // ──────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor:       AppColors.bgBottomSheet,
      modalBackgroundColor:  AppColors.bgBottomSheet,
      surfaceTintColor:      Colors.transparent,
      elevation:             0,
      modalElevation:        16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      dragHandleColor: AppColors.borderDefault,
      dragHandleSize:  Size(40, 4),
      showDragHandle:  true,
      clipBehavior:    Clip.antiAlias,
    ),

    // ──────────────────────────────────────────────────────
    // SNACK BAR
    // ──────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.bgCard2,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.md,
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      behavior:         SnackBarBehavior.floating,
      elevation:        8,
      actionTextColor:  AppColors.skyBlue,
      dismissDirection: DismissDirection.horizontal,
    ),

    // ──────────────────────────────────────────────────────
    // TAB BAR
    // ──────────────────────────────────────────────────────
    tabBarTheme: TabBarThemeData(
      labelColor:            AppColors.royalBlue,
      unselectedLabelColor:  AppColors.textMuted,
      indicator: BoxDecoration(
        borderRadius: AppBorderRadius.pill,
        color:        AppColors.royalBlue.withOpacity(0.15),
        border:       Border.all(color: AppColors.borderActive, width: 1),
      ),
      indicatorSize:     TabBarIndicatorSize.tab,
      labelStyle:        AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTextStyles.bodyMedium,
      dividerColor:      AppColors.borderSubtle,
      overlayColor:      MaterialStateProperty.all(
        AppColors.royalBlue.withOpacity(0.08),
      ),
      splashFactory: InkRipple.splashFactory,
    ),

    // ──────────────────────────────────────────────────────
    // DIVIDER
    // ──────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color:     AppColors.borderSubtle,
      thickness: 1,
      space:     1,
    ),

    // ──────────────────────────────────────────────────────
    // PROGRESS INDICATOR
    // ──────────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color:                AppColors.royalBlue,
      linearTrackColor:     AppColors.bgCard2,
      circularTrackColor:   Colors.transparent,
      refreshBackgroundColor: AppColors.bgCard,
      linearMinHeight:      3,
    ),

    // ──────────────────────────────────────────────────────
    // SLIDER
    // ──────────────────────────────────────────────────────
    sliderTheme: SliderThemeData(
      activeTrackColor:        AppColors.royalBlue,
      inactiveTrackColor:      AppColors.bgCard2,
      thumbColor:              AppColors.royalBlue,
      overlayColor:            AppColors.royalBlue.withOpacity(0.1),
      valueIndicatorColor:     AppColors.bgCard,
      activeTickMarkColor:     Colors.transparent,
      inactiveTickMarkColor:   Colors.transparent,
      valueIndicatorTextStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textPrimary,
      ),
      trackHeight:   4,
      thumbShape:    const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape:  const RoundSliderOverlayShape(overlayRadius: 20),
    ),

    // ──────────────────────────────────────────────────────
    // SWITCH
    // ──────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.textPrimary;
        }
        return AppColors.textMuted;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.royalBlue;
        }
        return AppColors.bgCard2;
      }),
      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      overlayColor: MaterialStateProperty.all(
        AppColors.royalBlue.withOpacity(0.08),
      ),
    ),

    // ──────────────────────────────────────────────────────
    // CHECKBOX
    // ──────────────────────────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.royalBlue;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(AppColors.textPrimary),
      side:       const BorderSide(color: AppColors.borderDefault, width: 1.5),
      shape:      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      overlayColor: MaterialStateProperty.all(
        AppColors.royalBlue.withOpacity(0.08),
      ),
      splashRadius: 20,
    ),

    // ──────────────────────────────────────────────────────
    // RADIO
    // ──────────────────────────────────────────────────────
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.royalBlue;
        }
        return AppColors.borderDefault;
      }),
      overlayColor: MaterialStateProperty.all(
        AppColors.royalBlue.withOpacity(0.08),
      ),
    ),

    // ──────────────────────────────────────────────────────
    // LIST TILE
    // ──────────────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      tileColor:          Colors.transparent,
      selectedTileColor:  AppColors.royalBlue.withOpacity(0.08),
      iconColor:          AppColors.textSecondary,
      textColor:          AppColors.textPrimary,
      subtitleTextStyle:  AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      titleTextStyle:     AppTextStyles.bodyMedium,
      contentPadding:     const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.sm,
      ),
      dense:           false,
      minLeadingWidth: 24,
    ),

    // ──────────────────────────────────────────────────────
    // ICONS
    // ──────────────────────────────────────────────────────
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: 22,
    ),
    primaryIconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: 22,
    ),

    // ──────────────────────────────────────────────────────
    // FLOATING ACTION BUTTON
    // ──────────────────────────────────────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor:   AppColors.royalBlue,
      foregroundColor:   AppColors.textPrimary,
      splashColor:       AppColors.whiteOp(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.xl,
      ),
      elevation:          6,
      focusElevation:     8,
      hoverElevation:     8,
      highlightElevation: 2,
      extendedTextStyle:  AppTextStyles.buttonMedium,
      extendedPadding:    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),

    // ──────────────────────────────────────────────────────
    // POPUP MENU
    // ──────────────────────────────────────────────────────
    popupMenuTheme: PopupMenuThemeData(
      color:        AppColors.bgCard2,
      elevation:    12,
      shadowColor:  Colors.black54,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.md,
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      textStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      labelTextStyle: MaterialStateProperty.all(
        AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      ),
    ),

    // ──────────────────────────────────────────────────────
    // TOOLTIP
    // ──────────────────────────────────────────────────────
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color:        AppColors.bgCard2,
        borderRadius: AppBorderRadius.sm,
        border:       Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      textStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      waitDuration:  const Duration(milliseconds: 500),
      showDuration:  const Duration(seconds: 2),
    ),

    // ──────────────────────────────────────────────────────
    // EXPANSION TILE
    // ──────────────────────────────────────────────────────
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor:          Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      iconColor:                AppColors.textSecondary,
      collapsedIconColor:       AppColors.textMuted,
      textColor:                AppColors.textPrimary,
      collapsedTextColor:       AppColors.textPrimary,
      tilePadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      childrenPadding: EdgeInsets.zero,
      expandedAlignment: Alignment.centerLeft,
    ),

    // ──────────────────────────────────────────────────────
    // DRAWER
    // ──────────────────────────────────────────────────────
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.bgSurface,
      scrimColor:      AppColors.overlayDark,
      elevation:       0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(0)),
      ),
      width: 280,
    ),

    // ──────────────────────────────────────────────────────
    // SCROLLBAR
    // ──────────────────────────────────────────────────────
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.all(
        AppColors.royalBlue.withOpacity(0.3),
      ),
      trackColor: MaterialStateProperty.all(Colors.transparent),
      trackBorderColor: MaterialStateProperty.all(Colors.transparent),
      radius:       const Radius.circular(2),
      thickness:    MaterialStateProperty.all(3),
      crossAxisMargin: 2,
      mainAxisMargin: 4,
    ),

    // ──────────────────────────────────────────────────────
    // PAGE TRANSITIONS
    // Cupertino-style slide transition for both platforms
    // ──────────────────────────────────────────────────────
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS:     const CupertinoPageTransitionsBuilder(),
      },
    ),

    // ──────────────────────────────────────────────────────
    // TEXT SELECTION
    // ──────────────────────────────────────────────────────
    textSelectionTheme: TextSelectionThemeData(
      cursorColor:              AppColors.royalBlue,
      selectionColor:           AppColors.royalBlue.withOpacity(0.3),
      selectionHandleColor:     AppColors.royalBlue,
    ),
  ); // end dark ThemeData

  // ──────────────────────────────────────────────────────────
  // 🌕 LIGHT THEME (Optional fallback)
  // ──────────────────────────────────────────────────────────

  static ThemeData lightWithAdmin(AdminThemeColors? colors) {
    final primary = colors != null
        ? AppColors.fromHex(colors.primaryHex.replaceFirst('#', ''))
        : AppColors.royalBlue;
    final accent = colors != null
        ? AppColors.fromHex(colors.accentHex.replaceFirst('#', ''))
        : AppColors.pepsiBlue;
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
    final primary = colors != null
        ? AppColors.fromHex(colors.primaryHex.replaceFirst('#', ''))
        : AppColors.royalBlue;
    return dark.copyWith(
      colorScheme: dark.colorScheme.copyWith(primary: primary),
      primaryColor: primary,
    );
  }

  static ThemeData get light => ThemeData(
    useMaterial3:       true,
    brightness:         Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor:  AppColors.royalBlue,
      brightness: Brightness.light,
      primary:    AppColors.royalBlue,
      secondary:  AppColors.pepsiBlue,
    ),
    scaffoldBackgroundColor: AppColors.lightBg,
    canvasColor: AppColors.pureWhite,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: AppTextStyles.textTheme.apply(
      bodyColor:    const Color(0xFF1E293B),
      displayColor: const Color(0xFF0F172A),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor:    Colors.white,
      foregroundColor:    AppColors.royalNavy,
      elevation:          0,
      centerTitle:        true,
      systemOverlayStyle: systemUiLight,
      titleTextStyle:     AppTextStyles.titleLarge.copyWith(
        color: AppColors.royalNavy,
      ),
      shape: const Border(
        bottom: BorderSide(color: Color(0x1A000000), width: 1),
      ),
    ),
    cardTheme: CardThemeData(
      color:       Colors.white,
      elevation:   2,
      shadowColor: AppColors.royalNavy.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.card),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.pepsiBlue),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 52)),
        textStyle: MaterialStateProperty.all(AppTextStyles.buttonMedium),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.pepsiBlue,
      unselectedItemColor: AppColors.silver,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// 🎨 DECORATION HELPERS — Box decorations for custom widgets
// These are used when you need custom painted containers,
// not covered by ThemeData component themes.
// ──────────────────────────────────────────────────────────────

/// Blue gradient button decoration (for custom gradient buttons)
BoxDecoration get kayanPrimaryButtonDecoration => BoxDecoration(
  gradient:     AppGradients.primaryButton,
  borderRadius: AppBorderRadius.button,
  boxShadow: [
    BoxShadow(
      color:      AppColors.royalBlue.withOpacity(0.35),
      blurRadius: 16,
      offset:     const Offset(0, 4),
    ),
  ],
);

/// Gold gradient button decoration (for premium CTAs)
BoxDecoration get kayanGoldButtonDecoration => BoxDecoration(
  gradient:     AppGradients.goldButton,
  borderRadius: AppBorderRadius.button,
  boxShadow: [
    BoxShadow(
      color:      AppColors.metallicGold.withOpacity(0.35),
      blurRadius: 16,
      offset:     const Offset(0, 4),
    ),
  ],
);

/// Default KAYAN card decoration
BoxDecoration get kayanCardDecoration => BoxDecoration(
  gradient:     AppGradients.card,
  borderRadius: AppBorderRadius.card,
  border:       Border.all(color: AppColors.borderSubtle, width: 1),
  boxShadow: [
    BoxShadow(
      color:      Colors.black.withOpacity(0.3),
      blurRadius: 12,
      offset:     const Offset(0, 4),
    ),
  ],
);

/// Gold-bordered card (featured, premium items)
BoxDecoration get kayanPremiumCardDecoration => BoxDecoration(
  gradient:     AppGradients.card,
  borderRadius: AppBorderRadius.card,
  border:       Border.all(color: AppColors.borderGold, width: 1),
  boxShadow: [
    BoxShadow(
      color:      AppColors.metallicGold.withOpacity(0.12),
      blurRadius: 20,
      spreadRadius: 0,
      offset:     const Offset(0, 4),
    ),
    BoxShadow(
      color:      Colors.black.withOpacity(0.25),
      blurRadius: 8,
      offset:     const Offset(0, 2),
    ),
  ],
);

/// Blue-glow card (active/selected state)
BoxDecoration get kayanActiveCardDecoration => BoxDecoration(
  gradient:     AppGradients.card,
  borderRadius: AppBorderRadius.card,
  border:       Border.all(color: AppColors.borderActiveBold, width: 1.5),
  boxShadow: [
    BoxShadow(
      color:      AppColors.royalBlue.withOpacity(0.2),
      blurRadius: 20,
      spreadRadius: 0,
      offset:     const Offset(0, 4),
    ),
  ],
);
