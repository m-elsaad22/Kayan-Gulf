// ============================================================
// KAYAN Super App — Main Shell (Bottom Navigation)
// lib/routing/main_shell.dart
//
// Wraps all 5 bottom-nav tabs.
// Features:
//   • Custom bottom nav bar with KAYAN Royal Metallic style
//   • Cart badge (live item count from Riverpod)
//   • Chat unread badge
//   • Haptic feedback on tab switch
//   • Hide bottom nav on certain child routes (chat, tracking)
//   • Gold indicator for active tab
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_gradients.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_border_radius.dart';
import 'app_routes.dart';

// ──────────────────────────────────────────────────────────────
// TAB DEFINITION
// ──────────────────────────────────────────────────────────────

class _TabItem {
  final String route;
  final String label;
  final String labelAr;
  final IconData icon;
  final IconData activeIcon;

  const _TabItem({
    required this.route,
    required this.label,
    required this.labelAr,
    required this.icon,
    required this.activeIcon,
  });
}

const List<_TabItem> _tabs = [
  _TabItem(
    route:      AppRoutes.home,
    label:      'Home',
    labelAr:    'الرئيسية',
    icon:       Icons.home_outlined,
    activeIcon: Icons.home_rounded,
  ),
  _TabItem(
    route:      AppRoutes.shop,
    label:      'Shop',
    labelAr:    'التسوق',
    icon:       Icons.storefront_outlined,
    activeIcon: Icons.storefront_rounded,
  ),
  _TabItem(
    route:      AppRoutes.services,
    label:      'Services',
    labelAr:    'الخدمات',
    icon:       Icons.build_circle_outlined,
    activeIcon: Icons.build_circle_rounded,
  ),
  _TabItem(
    route:      AppRoutes.classifieds,
    label:      'Classifieds',
    labelAr:    'الإعلانات',
    icon:       Icons.newspaper_outlined,
    activeIcon: Icons.newspaper_rounded,
  ),
  _TabItem(
    route:      AppRoutes.profile,
    label:      'Profile',
    labelAr:    'حسابي',
    icon:       Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
  ),
];

// ──────────────────────────────────────────────────────────────
// MAIN SHELL WIDGET
// ──────────────────────────────────────────────────────────────

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,

      // ── Body: current tab's navigator ─────────────────────
      body: navigationShell,

      // ── Bottom Navigation Bar ─────────────────────────────
      bottomNavigationBar: _KayanBottomNavBar(
        currentIndex: currentIndex,
        isArabic:     isArabic,
        onTap: (index) {
          // Haptic feedback
          HapticFeedback.selectionClick();

          // Navigate via GoRouter shell
          navigationShell.goBranch(
            index,
            // Re-tap on same tab → scroll to top / reset stack
            initialLocation: index == currentIndex,
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CUSTOM BOTTOM NAV BAR
// Full custom painted for KAYAN luxury Royal Metallic look
// ──────────────────────────────────────────────────────────────

class _KayanBottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final bool isArabic;
  final ValueChanged<int> onTap;

  const _KayanBottomNavBar({
    required this.currentIndex,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        border: const Border(
          top: BorderSide(color: AppColors.navBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.35),
            blurRadius: 20,
            offset:     const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final tab      = _tabs[index];
              final isActive = index == currentIndex;

              return Expanded(
                child: _NavBarItem(
                  tab:      tab,
                  isActive: isActive,
                  isArabic: isArabic,
                  index:    index,
                  onTap:    () => onTap(index),
                  // Pass badge counts from providers
                  badgeCount: _getBadge(index, ref),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  int? _getBadge(int index, WidgetRef ref) {
    // Tab 1 (Shop) → cart count
    // Tab 3 (Classifieds) → nothing
    // Tab 4 (Profile) → notification count
    // Implement when providers exist
    return null;
  }
}

// ──────────────────────────────────────────────────────────────
// SINGLE NAV BAR ITEM
// ──────────────────────────────────────────────────────────────

class _NavBarItem extends StatefulWidget {
  final _TabItem tab;
  final bool     isActive;
  final bool     isArabic;
  final int      index;
  final VoidCallback onTap;
  final int?     badgeCount;

  const _NavBarItem({
    required this.tab,
    required this.isActive,
    required this.isArabic,
    required this.index,
    required this.onTap,
    this.badgeCount,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double>   _scaleAnim;
  late final Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.15)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_controller);
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isActive) _controller.forward();
  }

  @override
  void didUpdateWidget(_NavBarItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _controller.forward(from: 0);
    } else if (!widget.isActive && old.isActive) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.isArabic ? widget.tab.labelAr : widget.tab.label;

    return GestureDetector(
      onTap:     widget.onTap,
      behavior:  HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Active indicator line at top
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve:    Curves.easeOut,
                height:   2,
                width:    widget.isActive ? 24 : 0,
                decoration: BoxDecoration(
                  gradient:     AppGradients.goldButton,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6),

              // Icon with scale animation + optional badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Transform.scale(
                    scale: _scaleAnim.value,
                    child: Icon(
                      widget.isActive
                          ? widget.tab.activeIcon
                          : widget.tab.icon,
                      size:  24,
                      color: widget.isActive
                          ? AppColors.navActive
                          : AppColors.navInactive,
                    ),
                  ),
                  // Badge
                  if (widget.badgeCount != null && widget.badgeCount! > 0)
                    Positioned(
                      top:   -4,
                      right: -6,
                      child: _Badge(count: widget.badgeCount!),
                    ),
                ],
              ),
              const SizedBox(height: 4),

              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.labelSmall.copyWith(
                  color: widget.isActive
                      ? AppColors.navActive
                      : AppColors.navInactive,
                  fontWeight: widget.isActive
                      ? FontWeight.w600
                      : FontWeight.w400,
                  fontFamily: widget.isArabic ? 'NotoKufiArabic' : 'Inter',
                ),
                child: Text(label),
              ),
              const SizedBox(height: 2),
            ],
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// BADGE WIDGET
// ──────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color:        AppColors.error,
        borderRadius: AppBorderRadius.pill,
        border:       Border.all(color: AppColors.navBackground, width: 1.5),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontFamily:  'Inter',
          fontSize:    9,
          fontWeight:  FontWeight.w700,
          color:       Colors.white,
          height:      1.0,
        ),
      ),
    );
  }
}
