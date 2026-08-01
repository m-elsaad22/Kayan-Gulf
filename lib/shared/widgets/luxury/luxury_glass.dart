// ============================================================
// KAYAN — Glassmorphism primitives (light / dark aware)
// ============================================================

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/kayan_motion.dart';

/// Frosted glass panel with blur + semi-transparent Gulf palette.
class LuxuryGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double blurSigma;
  final Color? tintColor;
  final Color? borderColor;
  final Gradient? gradient;

  const LuxuryGlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.blurSigma = 20,
    this.tintColor,
    this.borderColor,
    this.gradient,
  });

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static List<Color> _glassGradient(BuildContext context) {
    final dark = _isDark(context);
    if (dark) {
      return [
        AppColors.whiteOp(0.14),
        AppColors.skyBlue.withValues(alpha: 0.08),
        AppColors.whiteOp(0.04),
      ];
    }
    return [
      AppColors.pureWhite.withValues(alpha: 0.72),
      AppColors.skyBlue.withValues(alpha: 0.06),
      AppColors.pureWhite.withValues(alpha: 0.55),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    final radius = borderRadius ?? AppBorderRadius.card;
    final effectiveBorder =
        borderColor ?? (dark ? AppColors.whiteOp(0.16) : AppColors.royalBlueOp(0.12));

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _glassGradient(context),
                  ),
              borderRadius: radius,
              border: Border.all(color: effectiveBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: (dark ? Colors.black : AppColors.royalBlue)
                      .withValues(alpha: dark ? 0.28 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// Tappable glass card with scale + haptic micro-interaction.
class LuxuryGlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double blurSigma;
  final bool primaryHaptic;

  const LuxuryGlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.blurSigma = 20,
    this.primaryHaptic = false,
  });

  @override
  State<LuxuryGlassCard> createState() => _LuxuryGlassCardState();
}

class _LuxuryGlassCardState extends State<LuxuryGlassCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTap: enabled
          ? () {
              KayanMotion.hapticForTap(primary: widget.primaryHaptic);
              widget.onTap!();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? KayanMotion.tapScale : 1,
        duration: KayanMotion.fast,
        curve: KayanMotion.easeOut,
        child: LuxuryGlassPanel(
          margin: widget.margin,
          padding: widget.padding,
          blurSigma: widget.blurSigma,
          child: widget.child,
        ),
      ),
    );
  }
}
