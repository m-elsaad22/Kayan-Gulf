// Classifieds home — matches design/html/113-cl-dashboard.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/admin_data_service.dart';
import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../data/models/ad_models.dart';

final _classifiedsProvider = FutureProvider.autoDispose<List<AdModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return AdminDataService.instance.getClassifiedAds();
});

const _homeCategories = [
  (Icons.directions_car_rounded, 'سيارات', 'Cars', 'vehicles'),
  (Icons.apartment_rounded, 'عقارات', 'Real Estate', 'realestate'),
  (Icons.work_rounded, 'وظائف', 'Jobs', 'jobs'),
  (Icons.smartphone_rounded, 'إلكترونيات', 'Electronics', 'electronics'),
  (Icons.chair_rounded, 'أثاث', 'Furniture', 'furniture'),
  (Icons.more_horiz_rounded, 'المزيد', 'More', 'other'),
];

class ClassifiedsHomeScreen extends ConsumerStatefulWidget {
  const ClassifiedsHomeScreen({super.key});

  @override
  ConsumerState<ClassifiedsHomeScreen> createState() => _ClassifiedsHomeScreenState();
}

class _ClassifiedsHomeScreenState extends ConsumerState<ClassifiedsHomeScreen> {
  final Set<String> _favorites = {};

  IconData _categoryIcon(String slug) => switch (slug) {
        'vehicles' => Icons.directions_car_rounded,
        'realestate' => Icons.apartment_rounded,
        'jobs' => Icons.work_rounded,
        'electronics' => Icons.smartphone_rounded,
        'furniture' => Icons.chair_rounded,
        'fashion' => Icons.checkroom_rounded,
        'sports' => Icons.sports_soccer_rounded,
        'kids' => Icons.child_care_rounded,
        'books' => Icons.menu_book_rounded,
        _ => Icons.sell_rounded,
      };

  String _priceLabel(AdModel ad, bool ar) {
    if (ad.isFree) return ar ? 'مجاني' : 'Free';
    final unit = ar ? 'ر.س' : 'SAR';
    final price = ad.price?.toStringAsFixed(0) ?? '—';
    if (ad.categorySlug == 'realestate' && ad.isNegotiable) {
      return '$price $unit/${ar ? 'سنة' : 'yr'}';
    }
    return '$price $unit';
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final adsAsync = ref.watch(_classifiedsProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'إعلانات كيان' : 'KAYAN Classifieds',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.go(AppRoutes.home),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KayanHeroIconButton(
                  icon: Icons.favorite_border_rounded,
                  onTap: () => context.push(AppRoutes.savedAds),
                ),
                const SizedBox(width: 8),
                KayanHeroIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () => context.push(AppRoutes.classifiedsNotifications),
                ),
              ],
            ),
            searchHint: ar ? 'ابحث عن سيارة، عقار، أو منتج...' : 'Search cars, property, products...',
            onSearchTap: () => context.push(AppRoutes.searchAds),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 100),
              children: [
                Center(
                  child: KayanCtaButton(
                    label: ar ? 'أضف إعلانك' : 'Post your ad',
                    trailingIcon: Icons.add_rounded,
                    variant: KayanCtaVariant.gold,
                    onPressed: () => context.push(AppRoutes.postAd),
                  ),
                ),
                const SizedBox(height: 20),
                KayanCategoryPillRow(
                  isArabic: ar,
                  iconGradient: KayanDesignTokens.gradBlue,
                  items: _homeCategories
                      .map((c) => KayanCategoryPill(icon: c.$1, labelAr: c.$2, labelEn: c.$3))
                      .toList(),
                  onPillTap: (index) {
                    if (index == _homeCategories.length - 1) {
                      context.push(AppRoutes.adsList);
                      return;
                    }
                    context.push(AppRoutes.adsList);
                  },
                ),
                const SizedBox(height: 24),
                KayanSectionHeader(
                  title: ar ? 'أحدث الإعلانات' : 'Latest ads',
                  action: ar ? 'عرض الكل' : 'See all',
                  actionColor: KayanDesignTokens.kBlue,
                  onAction: () => context.push(AppRoutes.adsList),
                ),
                const SizedBox(height: 14),
                adsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      ar ? 'تعذّر تحميل الإعلانات' : 'Could not load ads',
                      textAlign: TextAlign.center,
                      style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                    ),
                  ),
                  data: (ads) {
                    final latest = ads.take(8).toList();
                    if (latest.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          ar ? 'لا توجد إعلانات حالياً' : 'No ads yet',
                          textAlign: TextAlign.center,
                          style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                        ),
                      );
                    }
                    return Column(
                      children: latest.map((ad) {
                        final location = ad.district.isNotEmpty
                            ? '${ad.city} · ${ad.timeAgo(ar)}'
                            : '${ad.city} · ${ad.timeAgo(ar)}';
                        return KayanClassifiedAdCard(
                          title: ad.title,
                          locationLine: location,
                          priceLabel: _priceLabel(ad, ar),
                          icon: _categoryIcon(ad.categorySlug),
                          isFeatured: ad.isFeatured || ad.isBoosted,
                          featuredLabel: ar ? 'مميز' : 'Featured',
                          isFavorited: _favorites.contains(ad.id),
                          onTap: () => context.push(AppRoutes.adPath(ad.slug)),
                          onFavorite: () => setState(() {
                            if (_favorites.contains(ad.id)) {
                              _favorites.remove(ad.id);
                            } else {
                              _favorites.add(ad.id);
                            }
                          }),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.myAds),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: KayanDesignTokens.gradBlue,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: KayanDesignTokens.shadowS,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.list_alt_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ar ? 'إعلاناتي' : 'My ads',
                                style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              Text(
                                ar ? 'إدارة ونشر إعلاناتك' : 'Manage and publish your listings',
                                style: KayanDesignTokens.cairo(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
