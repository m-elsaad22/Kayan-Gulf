// ============================================================
// KAYAN Super App — Gradient Definitions
// lib/core/theme/app_gradients.dart
//
// All LinearGradient and RadialGradient used across the app
// ============================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppGradients {
  // ──────────────────────────────────────────────────────────
  // 🔵 PRIMARY BUTTON GRADIENT — تدرج الزر الأساسي
  // Royal Blue → Deep Navy Blue
  // ──────────────────────────────────────────────────────────

  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4169E1), Color(0xFF1E40AF)],
  );

  static const LinearGradient primaryButtonPressed = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3558C8), Color(0xFF1A369A)],
  );

  static const LinearGradient primaryButtonHover = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5579E8), Color(0xFF2A50C0)],
  );

  // ──────────────────────────────────────────────────────────
  // 🌟 GOLD / PREMIUM GRADIENT — تدرج الذهب الفاخر
  // For featured items, VIP badges, premium CTAs
  // ──────────────────────────────────────────────────────────

  static const LinearGradient goldPremium = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD4AF37),
      Color(0xFFF5E8B3),
      Color(0xFFD4AF37),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient goldButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEFBF04), Color(0xFFD4AF37)],
  );

  static const LinearGradient goldButtonPressed = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4AF37), Color(0xFFB8960C)],
  );

  /// Animated shimmer gradient for gold text
  static const LinearGradient goldShimmer = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFB8960C),
      Color(0xFFD4AF37),
      Color(0xFFEFBF04),
      Color(0xFFF5E8B3),
      Color(0xFFEFBF04),
      Color(0xFFD4AF37),
      Color(0xFFB8960C),
    ],
    stops: [0.0, 0.15, 0.3, 0.5, 0.7, 0.85, 1.0],
  );

  static const LinearGradient goldBorder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD4AF37),
      Color(0xFFF5E8B3),
      Color(0xFFD4AF37),
      Color(0xFFB8960C),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // ──────────────────────────────────────────────────────────
  // 🌅 HERO / HEADER GRADIENT — تدرج الـ Hero والترويسة
  // Full-width banner, splash, onboarding
  // ──────────────────────────────────────────────────────────

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1F3B), Color(0xFF1E3A8A)],
  );

  static const LinearGradient heroReversed = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xFF0A1F3B), Color(0xFF1E3A8A)],
  );

  static const LinearGradient heroDiagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1F3B), Color(0xFF1E3A8A), Color(0xFF004B93)],
    stops: [0.0, 0.6, 1.0],
  );

  /// Hero with subtle gold accent at bottom
  static const LinearGradient heroWithGold = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A1F3B),
      Color(0xFF1E3A8A),
      Color(0xFF142B5A),
    ],
    stops: [0.0, 0.7, 1.0],
  );

  // ──────────────────────────────────────────────────────────
  // 🃏 CARD GRADIENTS — تدرجات البطاقات
  // ──────────────────────────────────────────────────────────

  static const LinearGradient card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF142B5A), Color(0xFF1E2A44)],
  );

  static const LinearGradient cardHover = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A3360), Color(0xFF243050)],
  );

  /// Premium/Featured card
  static const LinearGradient cardPremium = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E2810), Color(0xFF2A2A18)],
  );

  /// Emergency service card
  static const LinearGradient cardEmergency = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B0A0A), Color(0xFF1F0606)],
  );

  // ──────────────────────────────────────────────────────────
  // 🖼️ IMAGE OVERLAYS — تدرجات فوق الصور
  // For text readability on product/banner images
  // ──────────────────────────────────────────────────────────

  /// Gradient from transparent → dark (bottom text overlay)
  static const LinearGradient imageOverlayBottom = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
    stops: [0.4, 1.0],
  );

  /// Gradient from dark → transparent (top overlay)
  static const LinearGradient imageOverlayTop = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xCC000000), Colors.transparent],
    stops: [0.0, 0.6],
  );

  /// Full overlay (both top and bottom)
  static const LinearGradient imageOverlayFull = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x66000000),
      Colors.transparent,
      Color(0xB3000000),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Light overlay for cards with text
  static const LinearGradient imageOverlayLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0x80000000)],
    stops: [0.5, 1.0],
  );

  // ──────────────────────────────────────────────────────────
  // 📱 NAVIGATION / SIDEBAR — تدرج الشريط الجانبي
  // ──────────────────────────────────────────────────────────

  static const LinearGradient sidebar = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1F3B), Color(0xFF0B1D3A)],
  );

  static const LinearGradient bottomNav = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F2040), Color(0xFF0B1D3A)],
  );

  // ──────────────────────────────────────────────────────────
  // 🚨 STATUS GRADIENTS — تدرجات الحالة
  // ──────────────────────────────────────────────────────────

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const LinearGradient infoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );

  /// Emergency service gradient (red)
  static const LinearGradient emergency = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
  );

  // ──────────────────────────────────────────────────────────
  // ⏱️ FLASH DEAL GRADIENT — تدرج العروض السريعة
  // ──────────────────────────────────────────────────────────

  static const LinearGradient flashDeal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
  );

  static const LinearGradient flashDealCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2A0A0A), Color(0xFF1A0505)],
  );

  // ──────────────────────────────────────────────────────────
  // 💳 PAYMENT GRADIENTS — تدرجات بوابات الدفع
  // ──────────────────────────────────────────────────────────

  static const LinearGradient tabbyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B9ECC), Color(0xFF2A7A9E)],
  );

  static const LinearGradient tamaraGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00B2A9), Color(0xFF008A82)],
  );

  static const LinearGradient stripeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF635BFF), Color(0xFF4F46E5)],
  );

  // ──────────────────────────────────────────────────────────
  // ✨ SHIMMER GRADIENT — تدرج التحميل
  // ──────────────────────────────────────────────────────────

  static const LinearGradient shimmer = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      Color(0xFF1E2A44),
      Color(0xFF2A3A5A),
      Color(0xFF1E2A44),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ──────────────────────────────────────────────────────────
  // 🎯 RADIAL GRADIENTS — التدرجات الشعاعية
  // ──────────────────────────────────────────────────────────

  /// Blue glow — for active states
  static const RadialGradient blueGlow = RadialGradient(
    colors: [Color(0x4D4169E1), Colors.transparent],
    radius: 0.8,
  );

  /// Gold glow — for premium elements
  static const RadialGradient goldGlow = RadialGradient(
    colors: [Color(0x4DD4AF37), Colors.transparent],
    radius: 0.8,
  );

  /// Subtle background radial
  static const RadialGradient bgRadial = RadialGradient(
    center: Alignment.topCenter,
    colors: [Color(0xFF142B5A), Color(0xFF0B1D3A)],
    radius: 1.2,
  );

  // ──────────────────────────────────────────────────────────
  // 🎨 SPLASH GRADIENT — تدرج شاشة البداية
  // ──────────────────────────────────────────────────────────

  static const LinearGradient splash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A2B5E),
      Color(0xFF0033A0),
      Color(0xFF0A2B5E),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ──────────────────────────────────────────────────────────
  // 🛠️ HELPER METHODS — دوال مساعدة
  // ──────────────────────────────────────────────────────────

  /// Generate category color gradient
  static LinearGradient fromCategoryColor(Color color) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
  );

  /// Generate gradient from two colors
  static LinearGradient fromColors(Color start, Color end) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [start, end],
  );

  /// Animated shimmer for any base color
  static LinearGradient shimmerFor(Color baseColor) => LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      baseColor,
      baseColor.withOpacity(0.5),
      baseColor,
    ],
    stops: const [0.0, 0.5, 1.0],
  );
}
