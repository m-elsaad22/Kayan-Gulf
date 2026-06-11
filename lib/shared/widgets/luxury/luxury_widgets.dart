// ============================================================
// KAYAN — Minimal Luxury design system (Gulf Super App)
// Glassmorphism · Neumorphism · Micro-interactions
// ============================================================

export 'luxury_glass.dart';
export 'luxury_neumorphic.dart';

import 'package:flutter/material.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/kayan_motion.dart';
import 'luxury_glass.dart';
import 'luxury_neumorphic.dart';

/// Dashboard / hub entry card — glass icon + neumorphic body + gradient accent.
class LuxuryHubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final bool darkText;
  final VoidCallback onTap;

  const LuxuryHubCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    this.darkText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = darkText
        ? AppColors.royalBlue
        : (isDark ? AppColors.darkText : AppColors.pureWhite);

    return LuxuryNeumorphicCard(
      onTap: onTap,
      gradient: gradient,
      emphasized: true,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          LuxuryGlassPanel(
            padding: EdgeInsets.zero,
            blurSigma: 14,
            borderRadius: AppBorderRadius.md,
            borderColor: AppColors.whiteOp(darkText ? 0.35 : 0.22),
            child: SizedBox(
              width: 64,
              height: 64,
              child: Icon(icon, color: fg, size: 32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: fg.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: fg.withValues(alpha: 0.9),
            size: 18,
          ),
        ],
      ),
    );
  }
}

/// Admin CMS stat tile with glass + gold accent.
class LuxuryStatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const LuxuryStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LuxuryGlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.metallicGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.metallicGold.withValues(alpha: 0.35),
              ),
            ),
            child: Icon(icon, color: AppColors.metallicGold, size: 22),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.arabicHeadlineSmall.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Admin menu row with haptic tap.
class LuxuryAdminMenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const LuxuryAdminMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LuxuryGlassCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.skyBlue, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.arabicTitleSmall,
            ),
          ),
          const Icon(Icons.chevron_left, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

/// Scale + haptic wrapper for any tappable child.
class LuxuryTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool primaryHaptic;
  final double pressedScale;

  const LuxuryTap({
    super.key,
    required this.child,
    this.onTap,
    this.primaryHaptic = false,
    this.pressedScale = KayanMotion.tapScale,
  });

  @override
  State<LuxuryTap> createState() => _LuxuryTapState();
}

class _LuxuryTapState extends State<LuxuryTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
        scale: _pressed ? widget.pressedScale : 1,
        duration: KayanMotion.fast,
        curve: KayanMotion.easeOut,
        child: widget.child,
      ),
    );
  }
}
