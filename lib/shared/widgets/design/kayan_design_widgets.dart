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
    this.onPillTap,
  });

  final List<KayanCategoryPill> items;
  final bool isArabic;
  final LinearGradient iconGradient;
  final void Function(int index)? onPillTap;

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
          return GestureDetector(
            onTap: onPillTap != null ? () => onPillTap!(index) : null,
            child: SizedBox(
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
            ),
          );
        },
      ),
    );
  }
}

class KayanServiceCard extends StatelessWidget {
  const KayanServiceCard({
    super.key,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.priceLabel,
    required this.icon,
    this.onTap,
    this.onAdd,
    this.accentGradient = KayanDesignTokens.gradGreen,
    this.metaIcon = Icons.schedule_rounded,
    this.priceColor = KayanDesignTokens.kGreen,
  });

  final String name;
  final double rating;
  final String reviews;
  final String duration;
  final String priceLabel;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;
  final LinearGradient accentGradient;
  final IconData metaIcon;
  final Color priceColor;

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
                      _Meta(metaIcon, duration, KayanDesignTokens.muted),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        priceLabel,
                        style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: priceColor),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onAdd ?? onTap,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: accentGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                        ),
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

class KayanClassifiedAdCard extends StatelessWidget {
  const KayanClassifiedAdCard({
    super.key,
    required this.title,
    required this.locationLine,
    required this.priceLabel,
    required this.icon,
    this.isFeatured = false,
    this.featuredLabel = 'مميز',
    this.isFavorited = false,
    this.onTap,
    this.onFavorite,
    this.accentGradient = KayanDesignTokens.gradBlue,
    this.priceColor = KayanDesignTokens.kBlue,
  });

  final String title;
  final String locationLine;
  final String priceLabel;
  final IconData icon;
  final bool isFeatured;
  final String featuredLabel;
  final bool isFavorited;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final LinearGradient accentGradient;
  final Color priceColor;

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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: KayanDesignTokens.cairo(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: KayanDesignTokens.kBlueDeep,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFeatured) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: KayanDesignTokens.gradGold,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            featuredLabel,
                            style: KayanDesignTokens.cairo(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF402C00),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    locationLine,
                    style: KayanDesignTokens.cairo(fontSize: 11.5, color: KayanDesignTokens.muted),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          priceLabel,
                          style: KayanDesignTokens.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: priceColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavorite,
                        child: Icon(
                          isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: KayanDesignTokens.danger,
                          size: 22,
                        ),
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

/// Light inner-page top bar — matches design/html cl-* topbar pattern.
class KayanLightTopBar extends StatelessWidget {
  const KayanLightTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          KayanHeroIconButton(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
            light: true,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: KayanDesignTokens.cairo(fontSize: 17, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep),
            ),
          ),
          trailing ?? const SizedBox(width: 38),
        ],
      ),
    );
  }
}

/// Selectable filter chips row — matches 118-cl-search-filters slot-row.
class KayanFilterSlotRow extends StatelessWidget {
  const KayanFilterSlotRow({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.activeGradient = KayanDesignTokens.gradBlue,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final LinearGradient activeGradient;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(labels.length, (index) {
        final selected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: selected ? activeGradient : null,
              color: selected ? null : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? Colors.transparent : KayanDesignTokens.border),
            ),
            child: Text(
              labels[index],
              style: KayanDesignTokens.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : KayanDesignTokens.text2,
              ),
            ),
          ),
        );
      }),
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
