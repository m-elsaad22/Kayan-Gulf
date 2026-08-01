import 'package:flutter/material.dart';

import '../../../core/theme/kayan_design_tokens.dart';

/// Shared layout/widgets for entry flow screens (design/html 01–22).
class KayanHeroBackdrop extends StatelessWidget {
  const KayanHeroBackdrop({super.key, required this.child, this.minHeight});

  final Widget child;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: minHeight != null ? BoxConstraints(minHeight: minHeight!) : null,
      decoration: const BoxDecoration(gradient: KayanDesignTokens.gradHero),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: CustomPaint(painter: _HeroGlowPainter()),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class KayanBrandLogo extends StatelessWidget {
  const KayanBrandLogo({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.18),
      child: Image.asset(
        'assets/images/kayan_logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/kayan_icon.webp',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class KayanWordmark extends StatelessWidget {
  const KayanWordmark({super.key, this.showSubtitle = true});

  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'KAYAN',
          style: KayanDesignTokens.cairo(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 2),
          Text(
            'GULF SUPER APP',
            style: KayanDesignTokens.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: KayanDesignTokens.kOrangeLight,
            ),
          ),
        ],
      ],
    );
  }
}

class KayanEntryTitle extends StatelessWidget {
  const KayanEntryTitle({
    super.key,
    required this.before,
    this.highlight,
    this.after,
    this.onHero = true,
    this.textAlign = TextAlign.center,
  });

  final String before;
  final String? highlight;
  final String? after;
  final bool onHero;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final baseColor = onHero ? Colors.white : KayanDesignTokens.kBlueDeep;
    if (highlight == null) {
      return Text(
        before,
        textAlign: textAlign,
        style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: baseColor, height: 1.4),
      );
    }
    return Text.rich(
      TextSpan(
        style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: baseColor, height: 1.4),
        children: [
          TextSpan(text: before),
          TextSpan(
            text: highlight,
            style: KayanDesignTokens.cairo(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: KayanDesignTokens.gold,
            ),
          ),
          if (after != null) TextSpan(text: after),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

class KayanEntrySubtitle extends StatelessWidget {
  const KayanEntrySubtitle(this.text, {super.key, this.onHero = true, this.textAlign = TextAlign.center});

  final String text;
  final bool onHero;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: KayanDesignTokens.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onHero ? Colors.white.withValues(alpha: 0.82) : KayanDesignTokens.text2,
        height: 1.8,
      ),
    );
  }
}

class KayanEntrySheet extends StatelessWidget {
  const KayanEntrySheet({super.key, required this.child, this.padding = const EdgeInsets.fromLTRB(24, 30, 24, 24)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class KayanCtaButton extends StatelessWidget {
  const KayanCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = KayanCtaVariant.gold,
    this.loading = false,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final KayanCtaVariant variant;
  final bool loading;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final gradient = switch (variant) {
      KayanCtaVariant.gold => KayanDesignTokens.gradGold,
      KayanCtaVariant.blue => KayanDesignTokens.gradBlue,
      KayanCtaVariant.orange => KayanDesignTokens.gradOrange,
      KayanCtaVariant.green => KayanDesignTokens.gradGreen,
    };
    final textColor = variant == KayanCtaVariant.gold ? const Color(0xFF402C00) : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: KayanDesignTokens.gold.withValues(alpha: variant == KayanCtaVariant.gold ? 0.35 : 0.15),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: loading
              ? const Center(
                  child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF402C00))),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label, style: KayanDesignTokens.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: textColor)),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 10),
                      Icon(trailingIcon, size: 16, color: textColor),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

enum KayanCtaVariant { gold, blue, orange, green }

class KayanDesignTextField extends StatefulWidget {
  const KayanDesignTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  State<KayanDesignTextField> createState() => _KayanDesignTextFieldState();
}

class _KayanDesignTextFieldState extends State<KayanDesignTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final obscure = widget.obscureText && _obscure;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: KayanDesignTokens.bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KayanDesignTokens.border),
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: KayanDesignTokens.kBlue),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: obscure,
                  keyboardType: widget.keyboardType,
                  style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w600, color: KayanDesignTokens.text),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: KayanDesignTokens.cairo(fontSize: 15, color: const Color(0xFFA9B7CC)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (widget.obscureText)
                GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(
                    obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: KayanDesignTokens.muted,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class KayanOnboardingDots extends StatelessWidget {
  const KayanOnboardingDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3.5),
          width: active ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            gradient: active ? KayanDesignTokens.gradGold : null,
            color: active ? null : Colors.white.withValues(alpha: 0.28),
          ),
        );
      }),
    );
  }
}

class KayanSplashProgress extends StatefulWidget {
  const KayanSplashProgress({super.key});

  @override
  State<KayanSplashProgress> createState() => _KayanSplashProgressState();
}

class _KayanSplashProgressState extends State<KayanSplashProgress> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Column(
        children: [
          Container(
            width: 140,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(99),
            ),
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: 0.2 + _ctrl.value * 0.75,
              child: Container(
                decoration: BoxDecoration(
                  gradient: KayanDesignTokens.gradGold,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'جارِ التحميل...',
            style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class KayanLangToggle extends StatelessWidget {
  const KayanLangToggle({super.key, required this.isArabic, required this.onChanged});

  final bool isArabic;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LangCard(label: 'English', selected: !isArabic, onTap: () => onChanged(false)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _LangCard(label: 'عربي', selected: isArabic, onTap: () => onChanged(true)),
        ),
      ],
    );
  }
}

class _LangCard extends StatelessWidget {
  const _LangCard({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: selected ? const Color(0x0FE2801F) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? KayanDesignTokens.kOrange : KayanDesignTokens.border, width: 1.5),
          boxShadow: KayanDesignTokens.shadowS,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: KayanDesignTokens.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: selected ? const Color(0xFFB5590C) : KayanDesignTokens.kBlueDeep,
          ),
        ),
      ),
    );
  }
}

class KayanCountryRadioTile extends StatelessWidget {
  const KayanCountryRadioTile({
    super.key,
    required this.flag,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String flag;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 6),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlueDeep)),
            ),
            _RadioDot(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? KayanDesignTokens.kOrange : KayanDesignTokens.border, width: 2),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: KayanDesignTokens.kOrange, shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}

class KayanOrDivider extends StatelessWidget {
  const KayanOrDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: KayanDesignTokens.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(label, style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.muted)),
        ),
        const Expanded(child: Divider(color: KayanDesignTokens.border)),
      ],
    );
  }
}

class KayanSocialButton extends StatelessWidget {
  const KayanSocialButton({super.key, required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KayanDesignTokens.border),
            boxShadow: KayanDesignTokens.shadowS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: KayanDesignTokens.kBlueDeep),
              const SizedBox(width: 8),
              Text(label, style: KayanDesignTokens.cairo(fontSize: 13.5, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlueDeep)),
            ],
          ),
        ),
      ),
    );
  }
}

class KayanCheckRow extends StatelessWidget {
  const KayanCheckRow({super.key, required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: value ? KayanDesignTokens.gradGold : null,
              color: value ? null : Colors.transparent,
              border: value ? null : Border.all(color: KayanDesignTokens.border, width: 1.5),
            ),
            child: value ? const Icon(Icons.check_rounded, size: 11, color: Color(0xFF402C00)) : null,
          ),
          const SizedBox(width: 9),
          Text(label, style: KayanDesignTokens.cairo(fontSize: 13.5, fontWeight: FontWeight.w600, color: KayanDesignTokens.text2)),
        ],
      ),
    );
  }
}

class KayanEntryScaffold extends StatelessWidget {
  const KayanEntryScaffold({
    super.key,
    required this.hero,
    required this.sheet,
    this.smallHero = false,
    this.heroHeight,
  });

  final Widget hero;
  final Widget sheet;
  final bool smallHero;
  final double? heroHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanHeroBackdrop(
            minHeight: heroHeight ?? (smallHero ? 200 : null),
            child: SafeArea(bottom: false, child: hero),
          ),
          Expanded(child: Transform.translate(offset: const Offset(0, -24), child: KayanEntrySheet(child: sheet))),
        ],
      ),
    );
  }
}

class _HeroGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final orange = Paint()..color = const Color(0x4DE2801F);
    final green = Paint()..color = const Color(0x4D1FA073);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.05), 120, orange);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.95), 110, green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
