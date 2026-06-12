// ============================================================
// KAYAN — Light-first bottom navigation (5 tabs)
// ============================================================

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/kayan_motion.dart';

class KayanBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isArabic;

  const KayanBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isArabic = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCardBg : AppColors.lightBg;
    final selected = isDark ? AppColors.skyBlue : AppColors.pepsiBlue;
    final unselected = AppColors.silver;

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
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          backgroundColor: bg,
          selectedItemColor: selected,
          unselectedItemColor: unselected,
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          onTap: (i) {
            KayanMotion.hapticSelection();
            onItemSelected(i);
          },
          items: [
            for (var i = 0; i < items.length; i++)
              BottomNavigationBarItem(
                icon: Icon(items[i].$2),
                activeIcon: Icon(items[i].$3),
                label: items[i].$1,
              ),
          ],
        ),
      ),
    );
  }
}
