// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routing/app_routes.dart';
import '../providers/locale_provider.dart';

class QuickSwitchScreen extends ConsumerWidget {
  const QuickSwitchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    final modules = [
      (Icons.home_rounded, ar ? 'الرئيسية' : 'Home', AppRoutes.dashboard),
      (Icons.storefront_rounded, ar ? 'المتجر' : 'Shop', AppRoutes.shop),
      (Icons.handyman_rounded, ar ? 'الخدمات' : 'Services', AppRoutes.services),
      (Icons.campaign_rounded, ar ? 'الإعلانات' : 'Classifieds', AppRoutes.classifieds),
      (Icons.person_rounded, ar ? 'حسابي' : 'Profile', AppRoutes.profile),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(title: Text(ar ? 'تبديل سريع' : 'Quick Switch')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.heroDiagonal),
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: modules
              .map(
                (m) => Material(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.go(m.$3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(m.$1, size: 36, color: AppColors.royalBlue),
                        const SizedBox(height: 8),
                        Text(
                          m.$2,
                          style: ar
                              ? AppTextStyles.arabicTitleSmall
                              : AppTextStyles.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
