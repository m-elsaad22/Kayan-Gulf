// ============================================================
// KAYAN Super App — Luxury Royal Metallic Color System
// lib/core/theme/app_colors.dart
//
// Design Vision:
//   Primary Theme: Dark Mode — كيان الملكي
//   Inspired by: Rolex, Mercedes-Maybach, Private Jets
//   Palette: Royal Navy + Royal Blue + Metallic Gold + Silver
// ============================================================

import 'package:flutter/material.dart';

abstract class AppColors {
  // ──────────────────────────────────────────────────────────
  // 🔵 CORE BRAND — الألوان الأساسية للبراند
  // ──────────────────────────────────────────────────────────

  /// #0A1F3B — الأزرق الملكي العميق (legacy navy)
  static const Color royalNavy = Color(0xFF0A1F3B);

  /// #0A2B5E — Royal Blue (brand primary — prompt spec)
  static const Color royalBlue = Color(0xFF0A2B5E);

  /// #4169E1 — Interactive accent blue (buttons, links)
  static const Color accentBlue = Color(0xFF4169E1);

  /// #004B93 — الأزرق العميق (الهيدرات، الرؤوس)
  static const Color deepBlue = Color(0xFF004B93);

  /// #0033A0 — Pepsi Blue (prompt spec)
  static const Color pepsiBlue = Color(0xFF0033A0);

  /// Alias used by legacy feature code; keep centralized in the palette.
  static const Color gold = metallicGold;

  /// Neutral premium foreground alias used by legacy feature code.
  static const Color text = textPrimary;

  /// #00B4D8 — Sky Blue (prompt spec)
  static const Color skyBlue = Color(0xFF00B4D8);

  /// #00A8A8 — Turquoise accent (services)
  static const Color turquoise = Color(0xFF00A8A8);

  /// #C0C0C0 — Silver metallic
  static const Color silver = Color(0xFFC0C0C0);

  /// #FFFFFF — Pure white
  static const Color pureWhite = Color(0xFFFFFFFF);

  // ── Light theme surfaces (prompt spec) ──
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightCardBg = Color(0xFFF8F9FA);
  static const Color lightText = Color(0xFF0A2B5E);
  static const Color lightSubtext = Color(0xFF6C757D);

  // ── Dark theme surfaces (prompt spec) ──
  static const Color darkBg = Color(0xFF0A2B5E);
  static const Color darkCardBg = Color(0xFF1A2A3A);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkSubtext = Color(0xFFB3E5FC);

  /// #F4D03F — Light gold (stars, highlights)
  static const Color lightGold = Color(0xFFF4D03F);

  /// #D4AF37 — Dark gold (premium badges)
  static const Color darkGold = Color(0xFFD4AF37);

  /// #25D366 — WhatsApp green
  static const Color whatsappGreen = Color(0xFF25D366);

  /// #2196F3 — Call blue
  static const Color callBlue = Color(0xFF2196F3);

  // ──────────────────────────────────────────────────────────
  // 🌟 METALLIC GOLD PALETTE — لوحة الذهب المعدني
  // ──────────────────────────────────────────────────────────

  /// #D4AF37 — الذهب المعدني الأصيل
  static const Color metallicGold = Color(0xFFD4AF37);

  /// #EFBF04 — ذهب الفخامة
  static const Color luxuryGold = Color(0xFFEFBF04);

  /// #F5E8B3 — الذهب الفاتح
  static const Color goldLight = Color(0xFFF5E8B3);

  /// #B8960C — الذهب الداكن
  static const Color goldDark = Color(0xFFB8960C);

  /// #8B6914 — الذهب الأعمق
  static const Color goldDeep = Color(0xFF8B6914);

  // ──────────────────────────────────────────────────────────
  // 🪙 SILVER METALLIC — الفضي المعدني
  // ──────────────────────────────────────────────────────────

  static const Color silverMetallic = Color(0xFFC0C0C0);
  static const Color silverLight    = Color(0xFFE8E8E8);
  static const Color silverDark     = Color(0xFF9CA3AF);

  // ──────────────────────────────────────────────────────────
  // 🌑 DARK BACKGROUNDS — طبقات الخلفية الداكنة
  // ──────────────────────────────────────────────────────────

  /// #0B1D3A — الخلفية الرئيسية للتطبيق
  static const Color bgPrimary     = Color(0xFF0B1D3A);

  /// #0A1F3B — خلفية الـ Scaffold
  static const Color bgScaffold    = Color(0xFF0A1F3B);

  /// #142B5A — خلفية البطاقات (الطبقة المرفوعة الأولى)
  static const Color bgCard        = Color(0xFF142B5A);

  /// #1E2A44 — خلفية البطاقات الثانوية
  static const Color bgCard2       = Color(0xFF1E2A44);

  /// #0F2040 — خلفية شريط التنقل وبار التطبيق
  static const Color bgSurface     = Color(0xFF0F2040);

  /// #1A3360 — خلفية حالة التمرير والضغط
  static const Color bgHover       = Color(0xFF1A3360);

  /// #162440 — خلفية حقول الإدخال
  static const Color bgInput       = Color(0xFF162440);

  /// #112035 — خلفية الـ Bottom Sheet
  static const Color bgBottomSheet = Color(0xFF112035);

  /// #0D1E36 — خلفية الـ Modal والحوارات
  static const Color bgModal       = Color(0xFF0D1E36);

  // ──────────────────────────────────────────────────────────
  // ✏️ TEXT COLORS — ألوان النصوص
  // ──────────────────────────────────────────────────────────

  /// #FFFFFF — النص الأساسي
  static const Color textPrimary     = Color(0xFFFFFFFF);

  /// #94A3B8 — النص الثانوي
  static const Color textSecondary   = Color(0xFF94A3B8);

  /// #64748B — النص الباهت
  static const Color textMuted       = Color(0xFF64748B);

  /// #3D5270 — النص المعطل
  static const Color textDisabled    = Color(0xFF3D5270);

  /// #D4AF37 — نص ذهبي
  static const Color textGold        = Color(0xFFD4AF37);

  /// #EFBF04 — نص ذهبي فاخر
  static const Color textLuxuryGold  = Color(0xFFEFBF04);

  static const Color textError       = Color(0xFFEF4444);
  static const Color textSuccess     = Color(0xFF10B981);
  static const Color textWarning     = Color(0xFFF59E0B);
  static const Color textLink        = Color(0xFF60A5FA);

  // ──────────────────────────────────────────────────────────
  // 🔲 BORDERS — الحدود
  // ──────────────────────────────────────────────────────────

  /// 6% white — حد خفي جداً
  static const Color borderSubtle    = Color(0x0FFFFFFF);

  /// 10% white — حد افتراضي
  static const Color borderDefault   = Color(0x1AFFFFFF);

  /// 18% white — حد مرئي
  static const Color borderVisible   = Color(0x2DFFFFFF);

  /// 30% royalBlue — حد نشط
  static const Color borderActive    = Color(0x4D4169E1);

  /// 50% royalBlue — حد نشط قوي
  static const Color borderActiveBold = Color(0x804169E1);

  /// 30% gold — حد ذهبي
  static const Color borderGold      = Color(0x4DD4AF37);

  /// 50% gold — حد ذهبي قوي
  static const Color borderGoldBold  = Color(0x80D4AF37);

  /// 30% error — حد الخطأ
  static const Color borderError     = Color(0x4DEF4444);

  /// 30% success — حد النجاح
  static const Color borderSuccess   = Color(0x4D10B981);

  // ──────────────────────────────────────────────────────────
  // 🚦 SEMANTIC COLORS — الألوان الدلالية
  // ──────────────────────────────────────────────────────────

  // Success (prompt: #28A745)
  static const Color success      = Color(0xFF28A745);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark  = Color(0xFF059669);
  static const Color successBg    = Color(0x1A10B981);

  // Warning (prompt: #FD7E14)
  static const Color warning      = Color(0xFFFD7E14);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark  = Color(0xFFD97706);
  static const Color warningBg    = Color(0x1AF59E0B);

  // Error (prompt: #DC3545)
  static const Color error        = Color(0xFFDC3545);
  static const Color errorLight   = Color(0xFFF87171);
  static const Color errorDark    = Color(0xFFDC2626);
  static const Color errorBg      = Color(0x1AEF4444);

  // Info (prompt: #17A2B8)
  static const Color info         = Color(0xFF17A2B8);
  static const Color infoLight    = Color(0xFF60A5FA);
  static const Color infoBg       = Color(0x1A3B82F6);

  // ──────────────────────────────────────────────────────────
  // 🌫️ OVERLAYS — طبقات التعتيم
  // ──────────────────────────────────────────────────────────

  static const Color overlayDark   = Color(0xCC000000); // 80%
  static const Color overlayMedium = Color(0x99000000); // 60%
  static const Color overlayLight  = Color(0x4D000000); // 30%
  static const Color overlayBlue   = Color(0x264169E1); // 15% blue
  static const Color overlayGold   = Color(0x26D4AF37); // 15% gold

  // ──────────────────────────────────────────────────────────
  // 🏷️ BADGE COLORS — ألوان الشارات
  // ──────────────────────────────────────────────────────────

  static const Color badgeNew      = Color(0xFF10B981);
  static const Color badgeSale     = Color(0xFFEF4444);
  static const Color badgeFeatured = Color(0xFF4169E1);
  static const Color badgePremium  = Color(0xFFD4AF37);
  static const Color badgeUrgent   = Color(0xFFF97316);
  static const Color badgeSold     = Color(0xFF6B7280);
  static const Color badgeFree     = Color(0xFF059669);
  static const Color badgeHot      = Color(0xFFEF4444);
  static const Color badgeEmergency = Color(0xFFDC2626);

  // ──────────────────────────────────────────────────────────
  // ⭐ RATING — النجوم
  // ──────────────────────────────────────────────────────────

  static const Color starFilled = Color(0xFFF4D03F);
  static const Color starEmpty  = Color(0xFF3D5270);

  // ──────────────────────────────────────────────────────────
  // 📱 BOTTOM NAVIGATION
  // ──────────────────────────────────────────────────────────

  static const Color navBackground = Color(0xFF0F2040);
  static const Color navActive     = Color(0xFF4169E1);
  static const Color navInactive   = Color(0xFF64748B);
  static const Color navBorder     = Color(0x1AFFFFFF);
  static const Color navIndicator  = Color(0x264169E1);

  // ──────────────────────────────────────────────────────────
  // ✨ SHIMMER
  // ──────────────────────────────────────────────────────────

  static const Color shimmerBase      = Color(0xFF1E2A44);
  static const Color shimmerHighlight = Color(0xFF2A3A5A);

  // ──────────────────────────────────────────────────────────
  // 🧩 CATEGORY COLORS — ألوان الفئات
  // ──────────────────────────────────────────────────────────

  static const Color categoryBlue   = Color(0xFF3B82F6);
  static const Color categoryGreen  = Color(0xFF10B981);
  static const Color categoryOrange = Color(0xFFF97316);
  static const Color categoryPurple = Color(0xFF8B5CF6);
  static const Color categoryTeal   = Color(0xFF14B8A6);
  static const Color categoryRed    = Color(0xFFEF4444);
  static const Color categoryYellow = Color(0xFFF59E0B);
  static const Color categoryPink   = Color(0xFFEC4899);
  static const Color categoryIndigo = Color(0xFF6366F1);
  static const Color categoryCyan   = Color(0xFF06B6D4);

  // ──────────────────────────────────────────────────────────
  // 💳 PAYMENT — بوابات الدفع
  // ──────────────────────────────────────────────────────────

  static const Color stripeColor  = Color(0xFF635BFF);
  static const Color tabbyColor   = Color(0xFF3B9ECC);
  static const Color tamaraColor  = Color(0xFF00B2A9);

  // ──────────────────────────────────────────────────────────
  // 🌍 BASE
  // ──────────────────────────────────────────────────────────

  static const Color transparent = Colors.transparent;
  static const Color white       = Colors.white;
  static const Color black       = Colors.black;

  // ──────────────────────────────────────────────────────────
  // 🎨 DARK COLOR SCHEME — نظام الألوان الكامل
  // ──────────────────────────────────────────────────────────

  static ColorScheme get darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,

    // Primary (Royal Blue)
    primary:              royalBlue,
    onPrimary:            textPrimary,
    primaryContainer:     bgCard,
    onPrimaryContainer:   skyBlue,

    // Secondary (Metallic Gold)
    secondary:              metallicGold,
    onSecondary:            bgPrimary,
    secondaryContainer:     Color(0xFF2A2010),
    onSecondaryContainer:   goldLight,

    // Tertiary (Sky Blue)
    tertiary:              skyBlue,
    onTertiary:            bgPrimary,
    tertiaryContainer:     Color(0xFF1A2A4A),
    onTertiaryContainer:   skyBlue,

    // Error
    error:              error,
    onError:            textPrimary,
    errorContainer:     errorBg,
    onErrorContainer:   errorLight,

    // Surface
    surface:                 bgCard,
    onSurface:               textPrimary,
    surfaceContainerHighest: bgCard2,
    onSurfaceVariant:        textSecondary,

    // Outline
    outline:        borderDefault,
    outlineVariant: borderSubtle,

    // Shadow & Scrim
    shadow: Color(0xFF000000),
    scrim:  overlayDark,

    // Inverse
    inverseSurface:   Color(0xFFF0F4FF),
    onInverseSurface: bgPrimary,
    inversePrimary:   deepBlue,
  );

  // ──────────────────────────────────────────────────────────
  // 🛠️ HELPERS — دوال مساعدة
  // ──────────────────────────────────────────────────────────

  static Color royalBlueOp(double opacity) =>
      royalBlue.withOpacity(opacity);

  static Color goldOp(double opacity) =>
      metallicGold.withOpacity(opacity);

  static Color whiteOp(double opacity) =>
      Colors.white.withOpacity(opacity);

  static Color blackOp(double opacity) =>
      Colors.black.withOpacity(opacity);

  static Color fromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
