// Category browse — matches design/html/123-cl-category-browse.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/admin_data_service.dart';
import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../data/models/ad_models.dart';

class ClassifiedsCategoryBrowseScreen extends ConsumerStatefulWidget {
  const ClassifiedsCategoryBrowseScreen({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  ConsumerState<ClassifiedsCategoryBrowseScreen> createState() => _ClassifiedsCategoryBrowseScreenState();
}

class _ClassifiedsCategoryBrowseScreenState extends ConsumerState<ClassifiedsCategoryBrowseScreen> {
  final Set<String> _favorites = {};

  String _title(bool ar) {
    final cat = mockAdCategories.firstWhere(
      (c) => c.slug == widget.categorySlug,
      orElse: () => mockAdCategories.first,
    );
    if (widget.categorySlug == 'realestate') {
      return ar ? 'عقارات للإيجار' : 'Property for rent';
    }
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
    if (ad.categorySlug == 'realestate') return '${ad.price?.toStringAsFixed(0)} $unit/${ar ? 'سنة' : 'yr'}';
    return '${ad.price?.toStringAsFixed(0)} $unit';
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final ads = AdminDataService.instance
        .getClassifiedAds()
        .where((a) => a.categorySlug == widget.categorySlug)
        .toList();
    final display = ads.isEmpty ? mockAds.where((a) => a.categorySlug == widget.categorySlug).toList() : ads;
    final fallback = display.isEmpty ? mockAds.take(4).toList() : display;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: _title(ar),
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
            trailing: KayanHeroIconButton(
              icon: Icons.tune_rounded,
              onTap: () => context.push(AppRoutes.adFilters),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: fallback.map((ad) {
                return KayanClassifiedAdCard(
                  title: ad.title,
                  locationLine: ad.city,
                  priceLabel: _price(ad, ar),
                  icon: _icon(ad.categorySlug),
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
            ),
          ),
        ],
      ),
    );
  }
}
