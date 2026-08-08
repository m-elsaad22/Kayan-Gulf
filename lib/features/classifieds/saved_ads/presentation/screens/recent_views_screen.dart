// Recently viewed — light design matching cl-* screens
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class RecentViewsScreen extends ConsumerStatefulWidget {
  const RecentViewsScreen({super.key});

  @override
  ConsumerState<RecentViewsScreen> createState() => _RecentViewsScreenState();
}

class _RecentViewsScreenState extends ConsumerState<RecentViewsScreen> {
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
    final recent = mockAds.take(6).toList();

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'شوهد مؤخراً' : 'Recently viewed',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Text(
                  ar ? 'آخر الإعلانات التي زرتها' : 'Ads you viewed recently',
                  style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.text2, height: 1.8),
                ),
                const SizedBox(height: 14),
                if (recent.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        ar ? 'لا توجد مشاهدات بعد' : 'No views yet',
                        style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                      ),
                    ),
                  )
                else
                  ...recent.map((ad) {
                    return KayanClassifiedAdCard(
                      title: ad.title,
                      locationLine: '${ad.city} · ${ad.timeAgo(ar)}',
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
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
