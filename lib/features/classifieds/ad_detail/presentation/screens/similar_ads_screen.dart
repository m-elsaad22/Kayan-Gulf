// Similar ads — matches design/html/122-cl-similar-ads.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../browse/data/models/ad_models.dart';
import '../../../presentation/providers/classifieds_providers.dart';

class SimilarAdsScreen extends ConsumerStatefulWidget {
  const SimilarAdsScreen({super.key, required this.adSlug});

  final String adSlug;

  @override
  ConsumerState<SimilarAdsScreen> createState() => _SimilarAdsScreenState();
}

class _SimilarAdsScreenState extends ConsumerState<SimilarAdsScreen> {
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
    final similarAsync = ref.watch(similarAdsProvider(widget.adSlug));

    return similarAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (similar) => Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'إعلانات مشابهة' : 'Similar ads',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 8),
              Text(
                ar
                    ? 'قد تعجبك أيضاً هذه الإعلانات في نفس الفئة'
                    : 'You might also like these ads in the same category',
                style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.text2, height: 1.8),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: similar.take(8).map((ad) {
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
        ),
      ),
    ),
    );
  }
}
