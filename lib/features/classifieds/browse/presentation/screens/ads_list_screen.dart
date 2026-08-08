// Ads list / browse — light design
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../data/models/ad_models.dart';
import '../../../presentation/providers/classifieds_providers.dart';

final _sortProvider = StateProvider<AdSortOption>((_) => AdSortOption.newest);

class AdsListScreen extends ConsumerStatefulWidget {
  const AdsListScreen({super.key, this.categorySlug});

  final String? categorySlug;

  @override
  ConsumerState<AdsListScreen> createState() => _AdsListScreenState();
}

class _AdsListScreenState extends ConsumerState<AdsListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text.trim()));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _title(bool ar) {
    if (widget.categorySlug == null) return ar ? 'الإعلانات' : 'Classifieds';
    final cat = mockAdCategories.firstWhere(
      (c) => c.slug == widget.categorySlug,
      orElse: () => mockAdCategories.first,
    );
    return ar ? cat.nameAr : cat.nameEn;
  }

  IconData _icon(String slug) => switch (slug) {
        'vehicles' => Icons.directions_car_rounded,
        'realestate' => Icons.apartment_rounded,
        'jobs' => Icons.work_rounded,
        'electronics' => Icons.smartphone_rounded,
        'furniture' => Icons.chair_rounded,
        _ => Icons.sell_rounded,
      };

  String _price(AdModel ad, bool ar) {
    if (ad.isFree) return ar ? 'مجاني' : 'Free';
    final unit = ar ? 'ر.س' : 'SAR';
    return '${ad.price?.toStringAsFixed(0)} $unit';
  }

  AdFilter get _filter => AdFilter(
        categorySlug: widget.categorySlug,
        search: _query.isEmpty ? null : _query,
        sort: ref.watch(_sortProvider),
      );

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final sort = ref.watch(_sortProvider);
    final adsAsync = ref.watch(adsListProvider(_filter));
    final sortLabels = ar
        ? ['الأحدث', 'سعر ↑', 'سعر ↓']
        : ['Newest', 'Price ↑', 'Price ↓'];
    final sortOpts = [AdSortOption.newest, AdSortOption.priceAsc, AdSortOption.priceDesc];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: _title(ar),
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
            trailing: KayanHeroIconButton(icon: Icons.add_rounded, onTap: () => context.push(AppRoutes.postAd)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: KayanDesignTextField(
              label: ar ? 'بحث' : 'Search',
              controller: _searchCtrl,
              hint: ar ? 'ابحث في الإعلانات...' : 'Search ads...',
              icon: Icons.search_rounded,
            ),
          ),
          const SizedBox(height: 8),
          KayanFilterSlotRow(
            labels: sortLabels,
            selectedIndex: sortOpts.indexOf(sort),
            onSelected: (i) {
              HapticFeedback.selectionClick();
              ref.read(_sortProvider.notifier).state = sortOpts[i];
            },
          ),
          Expanded(
            child: adsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (ads) => ads.isEmpty
                ? Center(
                    child: Text(ar ? 'لا توجد إعلانات' : 'No ads found', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                    children: ads.map((ad) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: KayanClassifiedAdCard(
                          title: ad.title,
                          locationLine: '${ad.city} · ${ad.timeAgo(ar)}',
                          priceLabel: _price(ad, ar),
                          icon: _icon(ad.categorySlug),
                          isFeatured: ad.isBoosted,
                          featuredLabel: ar ? 'مميز' : 'Featured',
                          onTap: () => context.push(AppRoutes.adPath(ad.slug)),
                        ),
                      );
                    }).toList(),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
