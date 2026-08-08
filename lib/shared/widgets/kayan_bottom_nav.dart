// KAYAN — Light-first bottom navigation (5 tabs)
import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../core/theme/kayan_motion.dart';

class KayanBottomNav extends StatelessWidget {
  const KayanBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isArabic = true,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final items = isArabic
        ? const [
            ('الرئيسية', Icons.home_outlined, Icons.home_rounded),
            ('الخدمات', Icons.home_repair_service_outlined, Icons.home_repair_service_rounded),
            ('المتجر', Icons.shopping_bag_outlined, Icons.shopping_bag_rounded),
            ('الإعلانات', Icons.campaign_outlined, Icons.campaign_rounded),
            ('حسابي', Icons.person_outline_rounded, Icons.person_rounded),
          ]
        : const [
            ('Home', Icons.home_outlined, Icons.home_rounded),
            ('Services', Icons.home_repair_service_outlined, Icons.home_repair_service_rounded),
            ('Shop', Icons.shopping_bag_outlined, Icons.shopping_bag_rounded),
            ('Ads', Icons.campaign_outlined, Icons.campaign_rounded),
            ('Profile', Icons.person_outline_rounded, Icons.person_rounded),
          ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: KayanDesignTokens.border)),
        boxShadow: KayanDesignTokens.shadowS,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == selectedIndex;
              final color = active ? KayanDesignTokens.kBlue : KayanDesignTokens.muted;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    KayanMotion.hapticSelection();
                    onItemSelected(i);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(active ? items[i].$3 : items[i].$2, size: 22, color: color),
                      const SizedBox(height: 2),
                      Text(items[i].$1, style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: color)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
