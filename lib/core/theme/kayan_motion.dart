// ============================================================
// KAYAN — Motion & Haptics (60fps / 120Hz-friendly)
// Minimal Luxury · Gulf Super App design system
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// Centralized animation timing and haptic feedback for micro-interactions.
abstract class KayanMotion {
  // Frame-aligned durations (~60fps: 16.67ms/frame)
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 480);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve spring = Curves.easeOutBack;

  static const double tapScale = 0.97;
  static const double iconTapScale = 0.92;

  /// Haptic presets used across the super app.
  static void hapticSelection() => HapticFeedback.selectionClick();
  static void hapticLight() => HapticFeedback.lightImpact();
  static void hapticMedium() => HapticFeedback.mediumImpact();
  static void hapticHeavy() => HapticFeedback.heavyImpact();

  static void hapticForTap({bool primary = false}) {
    if (primary) {
      hapticMedium();
    } else {
      hapticLight();
    }
  }

  /// On high-refresh devices Flutter tickers follow display rate automatically.
  /// Warm up the first frame pipeline for smoother splash / hero transitions.
  static void prepareHighRefreshPipeline() {
    if (kIsWeb) return;
    final binding = SchedulerBinding.instance;
    binding.scheduleWarmUpFrame();
    if (kDebugMode) {
      final views = binding.platformDispatcher.views;
      if (views.isNotEmpty) {
        final dpr = views.first.devicePixelRatio;
        debugPrint('[KAYAN Motion] DPR $dpr — tickers sync to display refresh');
      }
    }
  }
}
