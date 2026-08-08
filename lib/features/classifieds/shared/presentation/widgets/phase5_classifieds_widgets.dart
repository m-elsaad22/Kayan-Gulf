// Classifieds phase widgets — light design
import 'package:flutter/material.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

class Phase5ClassifiedsScaffold extends StatelessWidget {
  const Phase5ClassifiedsScaffold({
    super.key,
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.children,
    this.actions,
  });

  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final List<Widget> children;
  final List<Widget>? actions;

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
              Row(
                children: [
                  Expanded(child: KayanLightTopBar(title: isArabic ? titleAr : titleEn, onBack: () => Navigator.maybePop(context))),
                  if (actions != null) ...actions!,
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    Text(isArabic ? subtitleAr : subtitleEn, style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted, height: 1.6)),
                    const SizedBox(height: 16),
                    ...children,
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

class Phase5ClassifiedsCard extends StatelessWidget {
  const Phase5ClassifiedsCard({
    super.key,
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    this.color = KayanDesignTokens.kBlue,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
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
          ],
        ),
      ),
    );
  }
}
