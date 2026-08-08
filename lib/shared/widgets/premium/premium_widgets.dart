// KAYAN — Premium UI primitives (light design)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/kayan_design_tokens.dart';
import '../design/kayan_design_widgets.dart';
import '../design/kayan_entry_widgets.dart';

class PremiumScaffold extends StatelessWidget {
  const PremiumScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.padding = const EdgeInsets.fromLTRB(24, 0, 24, 24),
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: title, onBack: () => Navigator.maybePop(context)),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 12),
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
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.gradient,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(KayanDesignTokens.radiusM);
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: gradient,
        borderRadius: radius,
        border: Border.all(color: borderColor ?? KayanDesignTokens.border),
        boxShadow: KayanDesignTokens.shadowS,
      ),
      child: child,
    );
  }
}

class PremiumIconButton extends StatefulWidget {
  const PremiumIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = KayanDesignTokens.kBlueDeep,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

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
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: KayanDesignTokens.border),
            boxShadow: KayanDesignTokens.shadowS,
          ),
          child: Icon(widget.icon, color: widget.color, size: 20),
        ),
      ),
    );
  }
}

class PremiumActionButton extends StatelessWidget {
  const PremiumActionButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.gold = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return KayanCtaButton(
      label: label,
      trailingIcon: icon,
      variant: gold ? KayanCtaVariant.orange : KayanCtaVariant.blue,
      onPressed: onTap,
    );
  }
}

class PremiumInfoTile extends StatelessWidget {
  const PremiumInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color = KayanDesignTokens.kBlue,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? trailing;
  final VoidCallback? onTap;

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
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: KayanDesignTokens.muted),
          ],
        ),
      ),
    );
  }
}
