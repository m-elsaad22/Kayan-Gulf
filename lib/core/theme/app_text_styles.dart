// ============================================================
// KAYAN Super App — Typography System
// lib/core/theme/app_text_styles.dart
//
// الخطوط تُحمَّل عبر google_fonts package في runtime
// لا حاجة لملفات .ttf محلية
// ============================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // ──────────────────────────────────────────────────────────
  // Font Family Constants
  // google_fonts يُحمِّل هذه الخطوط تلقائياً
  // ──────────────────────────────────────────────────────────

  /// للنصوص الإنجليزية
  static const String _fontInter = 'Inter';

  /// للنصوص العربية
  static const String _fontArabic = 'Noto Kufi Arabic';

  // ──────────────────────────────────────────────────────────
  // 📺 DISPLAY — للشعارات والعناوين الكبيرة
  // ──────────────────────────────────────────────────────────

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 57,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.22,
  );

  // ──────────────────────────────────────────────────────────
  // 📰 HEADLINE
  // ──────────────────────────────────────────────────────────

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.28,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.33,
  );

  // ──────────────────────────────────────────────────────────
  // 📋 TITLE
  // ──────────────────────────────────────────────────────────

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
    height: 1.43,
  );

  // ──────────────────────────────────────────────────────────
  // 📝 BODY
  // ──────────────────────────────────────────────────────────

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
    height: 1.33,
  );

  // ──────────────────────────────────────────────────────────
  // 🏷️ LABEL
  // ──────────────────────────────────────────────────────────

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  // ──────────────────────────────────────────────────────────
  // 🔘 BUTTON TEXT
  // ──────────────────────────────────────────────────────────

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.43,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.33,
  );

  // ──────────────────────────────────────────────────────────
  // 💰 PRICE STYLES
  // ──────────────────────────────────────────────────────────

  static const TextStyle priceHero = TextStyle(
    fontFamily: _fontInter,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.metallicGold,
    height: 1.0,
    letterSpacing: -0.5,
  );

  static const TextStyle priceXLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.metallicGold,
    height: 1.0,
    letterSpacing: -0.25,
  );

  static const TextStyle priceLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.metallicGold,
    height: 1.0,
  );

  static const TextStyle priceMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.metallicGold,
    height: 1.0,
  );

  static const TextStyle priceSmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.metallicGold,
    height: 1.0,
  );

  static const TextStyle priceOriginal = TextStyle(
    fontFamily: _fontInter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.textMuted,
    height: 1.0,
  );

  static const TextStyle priceOriginalMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.textMuted,
    height: 1.0,
  );

  // ──────────────────────────────────────────────────────────
  // 🔢 CAPTION / METADATA
  // ──────────────────────────────────────────────────────────

  static const TextStyle caption = TextStyle(
    fontFamily: _fontInter,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textMuted,
    height: 1.45,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: _fontInter,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: _fontInter,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppColors.textMuted,
    height: 1.6,
  );

  // ──────────────────────────────────────────────────────────
  // 🔢 MONO — للأرقام المرجعية وأرقام الطلبات
  // ──────────────────────────────────────────────────────────

  // نستخدم monospace system font بدلاً من JetBrains Mono
  static const TextStyle mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle orderNumber = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.skyBlue,
    letterSpacing: 1.0,
    height: 1.4,
  );

  // ──────────────────────────────────────────────────────────
  // 🌍 ARABIC STYLES
  // ──────────────────────────────────────────────────────────

  static const TextStyle arabicHeroTitle = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle arabicHeadlineLarge = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle arabicHeadlineMedium = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle arabicTitleLarge = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle arabicTitleMedium = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle arabicTitleSmall = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle arabicBodyLarge = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.7,
  );

  static const TextStyle arabicBodyMedium = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.7,
  );

  static const TextStyle arabicBodySmall = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static const TextStyle arabicCaption = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.6,
  );

  static const TextStyle arabicButton = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle arabicPrice = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.metallicGold,
    height: 1.2,
  );

  static const TextStyle arabicPriceMedium = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.metallicGold,
    height: 1.2,
  );

  // ──────────────────────────────────────────────────────────
  // ⭐ SPECIAL STYLES
  // ──────────────────────────────────────────────────────────

  static const TextStyle logoText = TextStyle(
    fontFamily: _fontInter,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 3.0,
    height: 1.0,
  );

  static const TextStyle logoTextArabic = TextStyle(
    fontFamily: _fontArabic,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle goldLabel = TextStyle(
    fontFamily: _fontInter,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.metallicGold,
    letterSpacing: 0.5,
  );

  static const TextStyle seeAll = TextStyle(
    fontFamily: _fontInter,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.skyBlue,
    letterSpacing: 0.2,
  );

  static const TextStyle rating = TextStyle(
    fontFamily: _fontInter,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.metallicGold,
    height: 1.0,
  );

  static const TextStyle countdown = TextStyle(
    fontFamily: _fontInter,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 2.0,
    height: 1.0,
  );

  static const TextStyle countdownSmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
    height: 1.0,
  );

  static const TextStyle otpDigit = TextStyle(
    fontFamily: _fontInter,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 9,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.0,
  );

  static const TextStyle badgeMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
    height: 1.0,
  );

  // ──────────────────────────────────────────────────────────
  // 📚 MATERIAL TEXT THEME
  // ──────────────────────────────────────────────────────────

  static TextTheme get textTheme => const TextTheme(
    displayLarge:   displayLarge,
    displayMedium:  displayMedium,
    displaySmall:   displaySmall,
    headlineLarge:  headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall:  headlineSmall,
    titleLarge:     titleLarge,
    titleMedium:    titleMedium,
    titleSmall:     titleSmall,
    bodyLarge:      bodyLarge,
    bodyMedium:     bodyMedium,
    bodySmall:      bodySmall,
    labelLarge:     labelLarge,
    labelMedium:    labelMedium,
    labelSmall:     labelSmall,
  );

  // ──────────────────────────────────────────────────────────
  // 🛠️ HELPERS
  // ──────────────────────────────────────────────────────────

  static TextStyle localizedBody(String locale) =>
      locale == 'ar' ? arabicBodyMedium : bodyMedium;

  static TextStyle localizedTitle(String locale) =>
      locale == 'ar' ? arabicTitleMedium : titleMedium;

  static TextStyle localizedPrice(String locale) =>
      locale == 'ar' ? arabicPrice : priceMedium;
}
