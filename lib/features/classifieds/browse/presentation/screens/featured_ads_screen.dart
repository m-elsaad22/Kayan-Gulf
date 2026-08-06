// Featured ads — light design matching classifieds cl-* screens
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../data/models/ad_models.dart';

class FeaturedAdsScreen extends ConsumerStatefulWidget {
  const FeaturedAdsScreen({super.key});

  @override
  ConsumerState<FeaturedAdsScreen> createState() => _FeaturedAdsScreenState();
}

class _FeaturedAdsScreenState extends ConsumerState<FeaturedAdsScreen> {
  final Set<String> _favorites = {};

  IconData _icon(String slug) => switch (slug) {
        'vehicles' => Icons.directions_car_rounded,
        'realestate' => Icons.apartment_rounded,
        'electronics' => Icons.smartphone_rounded,
        _ => Icons.sell_rounded,
      };

  String _price(AdModel ad, bool ar) {
    if (ad.isFree) return ar ? 'مجاني' : 'Free';
    return '${ad.price?.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}';
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final featured = mockAds.where((a) => a.isFeatured || a.isBoosted).toList();
    final display = featured.isEmpty ? mockAds.take(5).toList() : featured;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'إعلانات مميزة' : 'Featured ads',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                KayanOfferBanner(
                  title: ar ? 'إعلانات مروّجة' : 'Promoted listings',
                  subtitle: ar ? 'أفضل العروض في أعلى النتائج' : 'Top offers in search results',
                  gradient: KayanDesignTokens.gradGold,
                ),
                const SizedBox(height: 16),
                ...display.map((ad) {
                  return KayanClassifiedAdCard(
                    title: ad.title,
                    locationLine: ad.city,
                    priceLabel: _price(ad, ar),
                    icon: _icon(ad.categorySlug),
                    isFeatured: true,
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
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
