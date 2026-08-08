// Quick module switch — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../routing/app_routes.dart';
import '../providers/locale_provider.dart';
import '../widgets/design/kayan_design_widgets.dart';

class QuickSwitchScreen extends ConsumerWidget {
  const QuickSwitchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    final modules = [
      (Icons.home_rounded, ar ? 'الرئيسية' : 'Home', AppRoutes.dashboard, KayanDesignTokens.gradBlue),
      (Icons.storefront_rounded, ar ? 'المتجر' : 'Shop', AppRoutes.shop, KayanDesignTokens.gradOrange),
      (Icons.handyman_rounded, ar ? 'الخدمات' : 'Services', AppRoutes.services, KayanDesignTokens.gradGreen),
      (Icons.campaign_rounded, ar ? 'الإعلانات' : 'Classifieds', AppRoutes.classifieds, KayanDesignTokens.gradBlue),
      (Icons.person_rounded, ar ? 'حسابي' : 'Profile', AppRoutes.profile, KayanDesignTokens.gradOrange),
    ];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'تبديل سريع' : 'Quick switch', onBack: () => context.pop()),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: modules.map((m) {
                    return GestureDetector(
                      onTap: () => context.go(m.$3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                          border: Border.all(color: KayanDesignTokens.border),
                          boxShadow: KayanDesignTokens.shadowS,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(gradient: m.$4, borderRadius: BorderRadius.circular(14)),
                              child: Icon(m.$1, color: Colors.white, size: 26),
                            ),
                            const SizedBox(height: 10),
                            Text(m.$2, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
