import 'package:flutter/material.dart';

import '../../../core/theme/kayan_design_tokens.dart';

enum KayanSectionHeroVariant { green, orange, blue, redOrange }

class KayanSectionHero extends StatelessWidget {
  const KayanSectionHero({
    super.key,
    required this.title,
    required this.variant,
    this.leading,
    this.trailing,
    this.searchHint,
    this.onSearchTap,
  });

  final String title;
  final KayanSectionHeroVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final String? searchHint;
  final VoidCallback? onSearchTap;

  LinearGradient get _gradient => switch (variant) {
        KayanSectionHeroVariant.green => KayanDesignTokens.secHeroGreen,
        KayanSectionHeroVariant.orange => KayanDesignTokens.secHeroOrange,
        KayanSectionHeroVariant.blue => KayanDesignTokens.secHeroBlue,
        KayanSectionHeroVariant.redOrange => KayanDesignTokens.secHeroRedOrange,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
      decoration: BoxDecoration(gradient: _gradient),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(painter: _DotPatternPainter()),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (leading != null) leading!,
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: KayanDesignTokens.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing! else const SizedBox(width: 38),
                ],
              ),
              if (searchHint != null) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onSearchTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.85), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            searchHint!,
                            style: KayanDesignTokens.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class KayanHeroIconButton extends StatelessWidget {
  const KayanHeroIconButton({super.key, required this.icon, this.onTap, this.light = false});

  final IconData icon;
  final VoidCallback? onTap;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: light ? KayanDesignTokens.bg : Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 16,
            color: light ? KayanDesignTokens.kBlue : Colors.white,
          ),
        ),
      ),
    );
  }
}

class KayanHubCard extends StatelessWidget {
  const KayanHubCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: const BoxConstraints(minHeight: 150),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(26),
          boxShadow: KayanDesignTokens.shadowM,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.14,
                child: CustomPaint(painter: _DotPatternPainter()),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 13),
              ),
            ),
            Positioned(
              right: 18,
              top: 14,
              child: Transform.rotate(
                angle: -0.12,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: KayanDesignTokens.shadowS,
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: FractionallySizedBox(
                  widthFactor: 0.64,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: KayanDesignTokens.cairo(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: KayanDesignTokens.cairo(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KayanOfferBanner extends StatelessWidget {
  const KayanOfferBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.gradient = KayanDesignTokens.gradDeliveryOrange,
  });

  final String title;
  final String subtitle;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: KayanDesignTokens.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}

class KayanCategoryPill {
  const KayanCategoryPill({required this.icon, required this.labelAr, required this.labelEn});

  final IconData icon;
  final String labelAr;
  final String labelEn;
}

class KayanCategoryPillRow extends StatelessWidget {
  const KayanCategoryPillRow({
    super.key,
    required this.items,
    required this.isArabic,
    this.iconGradient = KayanDesignTokens.gradDeliveryOrange,
  });

  final List<KayanCategoryPill> items;
  final bool isArabic;
  final LinearGradient iconGradient;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 66,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: iconGradient,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(item.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 7),
                Text(
                  isArabic ? item.labelAr : item.labelEn,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: KayanDesignTokens.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class KayanVendorCard extends StatelessWidget {
  const KayanVendorCard({
    super.key,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.eta,
    required this.isOpen,
    required this.deliveryLabel,
    required this.icon,
    this.onTap,
    this.accentGradient = KayanDesignTokens.gradDeliveryOrange,
  });

  final String name;
  final double rating;
  final String reviews;
  final String eta;
  final bool isOpen;
  final String deliveryLabel;
  final IconData icon;
  final VoidCallback? onTap;
  final LinearGradient accentGradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: KayanDesignTokens.border),
          boxShadow: KayanDesignTokens.shadowS,
        ),
        child: Row(
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                gradient: accentGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: KayanDesignTokens.cairo(fontSize: 14.5, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _Meta(Icons.star_rounded, '$rating ($reviews)', KayanDesignTokens.gold),
                      _Meta(Icons.schedule_rounded, eta, KayanDesignTokens.muted),
                      _Meta(
                        Icons.circle,
                        isOpen ? 'مفتوح' : 'مغلق',
                        isOpen ? KayanDesignTokens.oGreenOpen : KayanDesignTokens.danger,
                        iconSize: 6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        deliveryLabel,
                        style: KayanDesignTokens.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: KayanDesignTokens.oOrange,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: accentGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.icon, this.text, this.color, {this.iconSize = 12});

  final IconData icon;
  final String text;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: color),
        const SizedBox(width: 4),
        Text(text, style: KayanDesignTokens.cairo(fontSize: 11.5, fontWeight: FontWeight.w600, color: KayanDesignTokens.muted)),
      ],
    );
  }
}

class KayanDesignPrimaryButton extends StatelessWidget {
  const KayanDesignPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradient = KayanDesignTokens.gradDeliveryOrange,
  });

  final String label;
  final VoidCallback onPressed;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: KayanDesignTokens.oOrange.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: KayanDesignTokens.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class KayanSectionHeader extends StatelessWidget {
  const KayanSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    this.actionColor = KayanDesignTokens.oOrange,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep),
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: actionColor),
            ),
          ),
      ],
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const spacing = 16.0;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
