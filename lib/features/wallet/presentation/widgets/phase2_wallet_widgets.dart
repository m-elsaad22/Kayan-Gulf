// Wallet phase widgets — light design
import 'package:flutter/material.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

class Phase2WalletScaffold extends StatelessWidget {
  const Phase2WalletScaffold({
    super.key,
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.children,
  });

  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final List<Widget> children;

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

class Phase2WalletCard extends StatelessWidget {
  const Phase2WalletCard({
    super.key,
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.value,
    required this.captionAr,
    required this.captionEn,
  });

  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String value;
  final String captionAr;
  final String captionEn;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: KayanDesignTokens.gradBlue,
        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        boxShadow: KayanDesignTokens.shadowS,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isArabic ? titleAr : titleEn, style: KayanDesignTokens.cairo(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(value, style: KayanDesignTokens.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(isArabic ? captionAr : captionEn, style: KayanDesignTokens.cairo(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
