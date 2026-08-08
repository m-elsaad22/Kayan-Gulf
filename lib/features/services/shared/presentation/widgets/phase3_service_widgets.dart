// Service phase widgets — light design
import 'package:flutter/material.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class Phase3ServiceScaffold extends StatelessWidget {
  const Phase3ServiceScaffold({
    super.key,
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.children,
    this.footer,
  });

  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: isArabic ? titleAr : titleEn, onBack: () => Navigator.maybePop(context)),
              Expanded(
                child: ListView(
                  children: [
                    Text(isArabic ? subtitleAr : subtitleEn, style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted, height: 1.6)),
                    const SizedBox(height: 16),
                    ...children,
                    if (footer != null) ...[const SizedBox(height: 16), footer!],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Phase3ServiceCard extends StatelessWidget {
  const Phase3ServiceCard({
    super.key,
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    this.color = KayanDesignTokens.kGreen,
    this.onTap,
  });

  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
            border: Border.all(color: KayanDesignTokens.border),
            boxShadow: KayanDesignTokens.shadowS,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isArabic ? titleAr : titleEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(isArabic ? bodyAr : bodyEn, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                  ],
                ),
              ),
              if (onTap != null) const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: KayanDesignTokens.muted),
            ],
          ),
        ),
      ),
    );
  }
}
