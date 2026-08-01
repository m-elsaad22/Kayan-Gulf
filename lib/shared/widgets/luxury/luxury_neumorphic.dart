// ============================================================
// KAYAN — Light neumorphism for premium CTAs & stat cards
// ============================================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
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

  List<BoxShadow> _shadows(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final depth = widget.emphasized ? 18.0 : 14.0;
    final spread = widget.emphasized ? 1.0 : 0.0;

    if (dark) {
      return [
        BoxShadow(
          color: AppColors.whiteOp(0.06),
          blurRadius: depth,
          offset: const Offset(-4, -4),
          spreadRadius: spread,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.45),
          blurRadius: depth + 6,
          offset: const Offset(6, 8),
          spreadRadius: spread,
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.pureWhite.withValues(alpha: 0.95),
        blurRadius: depth,
        offset: const Offset(-5, -5),
        spreadRadius: spread,
      ),
      BoxShadow(
        color: AppColors.royalBlue.withValues(alpha: 0.12),
        blurRadius: depth + 4,
        offset: const Offset(5, 7),
        spreadRadius: spread,
      ),
    ];
  }

  Color _fill(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (widget.gradient != null) return Colors.transparent;
    return dark ? AppColors.darkCardBg : AppColors.lightCardBg;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final dark = Theme.of(context).brightness == Brightness.dark;

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
            color: widget.gradient == null ? _fill(context) : null,
            borderRadius: AppBorderRadius.card,
            border: Border.all(
              color: dark
                  ? AppColors.whiteOp(0.10)
                  : AppColors.royalBlueOp(0.08),
            ),
            boxShadow: _shadows(context),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
