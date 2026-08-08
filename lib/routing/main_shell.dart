// KAYAN Super App — Main Shell (light bottom navigation)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/kayan_design_tokens.dart';
import 'app_routes.dart';

class _TabItem {
  const _TabItem({
    required this.route,
    required this.label,
    required this.labelAr,
    required this.icon,
    required this.activeIcon,
  });

  final String route;
  final String label;
  final String labelAr;
  final IconData icon;
  final IconData activeIcon;
}

const List<_TabItem> _tabs = [
  _TabItem(route: AppRoutes.home, label: 'Home', labelAr: 'الرئيسية', icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
  _TabItem(route: AppRoutes.delivery, label: 'Orders', labelAr: 'طلبات', icon: Icons.delivery_dining_outlined, activeIcon: Icons.delivery_dining_rounded),
  _TabItem(route: AppRoutes.shop, label: 'Shop', labelAr: 'التسوق', icon: Icons.storefront_outlined, activeIcon: Icons.storefront_rounded),
  _TabItem(route: AppRoutes.services, label: 'Services', labelAr: 'الخدمات', icon: Icons.build_circle_outlined, activeIcon: Icons.build_circle_rounded),
  _TabItem(route: AppRoutes.classifieds, label: 'Classifieds', labelAr: 'الإعلانات', icon: Icons.newspaper_outlined, activeIcon: Icons.newspaper_rounded),
  _TabItem(route: AppRoutes.profile, label: 'Profile', labelAr: 'حسابي', icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded),
];

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: navigationShell,
      bottomNavigationBar: _KayanBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        isArabic: isArabic,
        onTap: (index) {
          HapticFeedback.selectionClick();
          navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
        },
      ),
    );
  }
}

class _KayanBottomNavBar extends StatelessWidget {
  const _KayanBottomNavBar({
    required this.currentIndex,
    required this.isArabic,
    required this.onTap,
  });

  final int currentIndex;
  final bool isArabic;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: KayanDesignTokens.border)),
        boxShadow: KayanDesignTokens.shadowS,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final isActive = index == currentIndex;
              return Expanded(
                child: _NavBarItem(
                  tab: tab,
                  isActive: isActive,
                  isArabic: isArabic,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.tab,
    required this.isActive,
    required this.isArabic,
    required this.onTap,
  });

  final _TabItem tab;
  final bool isActive;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = isArabic ? tab.labelAr : tab.label;
    final color = isActive ? KayanDesignTokens.kBlue : KayanDesignTokens.muted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 20 : 0,
            decoration: BoxDecoration(
              color: KayanDesignTokens.kBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Icon(isActive ? tab.activeIcon : tab.icon, size: 22, color: color),
          const SizedBox(height: 2),
          Text(label, style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}
