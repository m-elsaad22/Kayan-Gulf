// Services list — matches design/html/25-hs-service-list.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../../data/models/service_models.dart';

final servicesListProvider = FutureProvider.autoDispose.family<List<ServiceDetailModel>, String?>((ref, categoryId) async {
  await Future.delayed(const Duration(milliseconds: 300));
  final services = mockServiceCategories.map((category) => mockServiceDetail(category.slug)).toList();
  if (categoryId == null || categoryId.isEmpty) return services;
  return services.where((s) => s.slug == categoryId || s.categorySlug == categoryId).toList();
});

class ServicesListScreen extends ConsumerWidget {
  const ServicesListScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final services = ref.watch(servicesListProvider(categoryId));

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'تصفح الخدمات' : 'Browse services',
            variant: KayanSectionHeroVariant.green,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.pop(),
            ),
            searchHint: ar ? 'ابحث عن خدمة...' : 'Search services...',
          ),
          Expanded(
            child: services.when(
              loading: () => ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  ShimmerBox(width: double.infinity, height: 108, borderRadius: BorderRadius.all(Radius.circular(18))),
                  SizedBox(height: 12),
                  ShimmerBox(width: double.infinity, height: 108, borderRadius: BorderRadius.all(Radius.circular(18))),
                ],
              ),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (list) => list.isEmpty
                  ? Center(
                      child: Text(
                        ar ? 'لا توجد خدمات في هذه الفئة' : 'No services in this category',
                        style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final s = list[i];
                        return KayanServiceCard(
                          name: ar ? s.nameAr : s.nameEn,
                          rating: s.rating,
                          reviews: '${s.totalRatings}',
                          duration: ar ? '${s.estimatedDurationMin} د' : '${s.estimatedDurationMin} min',
                          priceLabel: '${s.finalPrice.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                          icon: Icons.handyman_rounded,
                          onTap: () => context.push(AppRoutes.servicePath(s.slug)),
                          onAdd: () => context.push(AppRoutes.serviceBookPath(s.slug)),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
