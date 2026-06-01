// ============================================================
// KAYAN — Premium UI Primitives
// ============================================================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class PremiumScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PremiumScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.padding = const EdgeInsets.all(AppSpacing.pagePadding),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    PremiumIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.maybePop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.titleLarge
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: padding,
                  physics: const BouncingScrollPhysics(),
                  children: [child],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry borderRadius;
  final Gradient? gradient;
  final Color? borderColor;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = AppBorderRadius.card,
    this.gradient,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.whiteOp(0.12),
                      AppColors.pepsiBlue.withOpacity(0.10),
                      AppColors.whiteOp(0.04),
                    ],
                  ),
              borderRadius: borderRadius,
              border: Border.all(color: borderColor ?? AppColors.whiteOp(0.14)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 28,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class PremiumIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const PremiumIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.textPrimary,
  });

  @override
  State<PremiumIconButton> createState() => _PremiumIconButtonState();
}

class _PremiumIconButtonState extends State<PremiumIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: GlassPanel(
          padding: EdgeInsets.zero,
          borderRadius: AppBorderRadius.pill,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(widget.icon, color: widget.color, size: 20),
          ),
        ),
      ),
    );
  }
}

class PremiumActionButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool gold;

  const PremiumActionButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.gold = false,
  });

  @override
  State<PremiumActionButton> createState() => _PremiumActionButtonState();
}

class _PremiumActionButtonState extends State<PremiumActionButton> {
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
              HapticFeedback.mediumImpact();
              widget.onTap!();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.45,
          duration: const Duration(milliseconds: 160),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              gradient:
                  widget.gold ? AppGradients.goldButton : AppGradients.primaryButton,
              borderRadius: AppBorderRadius.button,
              boxShadow: [
                BoxShadow(
                  color: (widget.gold
                          ? AppColors.metallicGold
                          : AppColors.royalBlue)
                      .withOpacity(0.34),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 20,
                    color: widget.gold ? AppColors.bgPrimary : Colors.white,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: widget.gold ? AppColors.bgPrimary : Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? trailing;
  final VoidCallback? onTap;

  const PremiumInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color = AppColors.royalBlue,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassPanel(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.28)),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
          ],
        ),
      ),
    );
  }
}
