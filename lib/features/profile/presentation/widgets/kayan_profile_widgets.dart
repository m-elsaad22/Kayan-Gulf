import 'package:flutter/material.dart';

import '../../../../core/theme/kayan_design_tokens.dart';

class KayanProfileMenuTile extends StatelessWidget {
  const KayanProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? KayanDesignTokens.danger : KayanDesignTokens.kBlue;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: KayanDesignTokens.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: danger ? KayanDesignTokens.danger : KayanDesignTokens.kBlueDeep,
                    ),
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: KayanDesignTokens.cairo(fontSize: 11.5, color: KayanDesignTokens.muted)),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: KayanDesignTokens.muted),
          ],
        ),
      ),
    );
  }
}
