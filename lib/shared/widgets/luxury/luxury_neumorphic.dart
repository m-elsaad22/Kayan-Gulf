// KAYAN — Light neumorphism for premium CTAs & stat cards
import 'package:flutter/material.dart';

import '../../../core/theme/kayan_design_tokens.dart';
import '../../../core/theme/kayan_motion.dart';

/// Soft dual-shadow card — subtle neumorphism for important surfaces.
class LuxuryNeumorphicCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final bool emphasized;
  final bool primaryHaptic;

  const LuxuryNeumorphicCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.gradient,
    this.emphasized = false,
    this.primaryHaptic = true,
  });

  @override
  State<LuxuryNeumorphicCard> createState() => _LuxuryNeumorphicCardState();
}

class _LuxuryNeumorphicCardState extends State<LuxuryNeumorphicCard> {
  bool _pressed = false;

  List<BoxShadow> get _shadows {
    final depth = widget.emphasized ? 18.0 : 14.0;
    final spread = widget.emphasized ? 1.0 : 0.0;

    return [
      BoxShadow(
        color: KayanDesignTokens.surface.withValues(alpha: 0.95),
        blurRadius: depth,
        offset: const Offset(-5, -5),
        spreadRadius: spread,
      ),
      BoxShadow(
        color: KayanDesignTokens.kBlue.withValues(alpha: 0.12),
        blurRadius: depth + 4,
        offset: const Offset(5, 7),
        spreadRadius: spread,
      ),
    ];
  }

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
        child: AnimatedContainer(
          duration: KayanMotion.normal,
          curve: KayanMotion.easeOut,
          margin: widget.margin,
          padding: widget.padding,
          constraints: const BoxConstraints(minHeight: 140),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            color: widget.gradient == null ? KayanDesignTokens.surface : null,
            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
            border: Border.all(color: KayanDesignTokens.kBlue.withValues(alpha: 0.08)),
            boxShadow: _shadows,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
