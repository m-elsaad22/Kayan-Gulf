// ============================================================
// KAYAN — Main Shell (Bottom Navigation)
// Light-first · 5 tabs: Home · Services · Shop · Ads · Profile
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/screen_theme.dart';
import '../shared/widgets/kayan_bottom_nav.dart';
import 'app_routes.dart';

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
      backgroundColor: context.screenBackground,
      body: navigationShell,
      bottomNavigationBar: KayanBottomNav(
        selectedIndex: currentIndex,
        isArabic: isArabic,
        onItemSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          );
        },
      ),
    );
  }
}
