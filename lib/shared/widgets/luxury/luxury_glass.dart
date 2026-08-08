// KAYAN — Glassmorphism primitives (light design)
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/kayan_design_tokens.dart';
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

  static List<Color> get _glassGradient => [
        KayanDesignTokens.surface.withValues(alpha: 0.72),
        KayanDesignTokens.kBlueLight.withValues(alpha: 0.06),
        KayanDesignTokens.surface.withValues(alpha: 0.55),
      ];

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(KayanDesignTokens.radiusM);
    final effectiveBorder = borderColor ?? KayanDesignTokens.kBlue.withValues(alpha: 0.12);

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
                    colors: _glassGradient,
                  ),
              borderRadius: radius,
              border: Border.all(color: effectiveBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: KayanDesignTokens.kBlue.withValues(alpha: 0.08),
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
