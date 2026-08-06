// Saved ads — matches design/html/120-cl-saved-ads.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class SavedAdsScreen extends ConsumerStatefulWidget {
  const SavedAdsScreen({super.key});

  @override
  ConsumerState<SavedAdsScreen> createState() => _SavedAdsScreenState();
}

class _SavedAdsScreenState extends ConsumerState<SavedAdsScreen> {
  final Set<String> _saved = {};

  @override
  void initState() {
    super.initState();
    for (final ad in mockAds.where((a) => a.isFavorited)) {
      _saved.add(ad.id);
    }
    if (_saved.isEmpty) {
      _saved.addAll(mockAds.take(2).map((a) => a.id));
    }
  }

  IconData _icon(String slug) => switch (slug) {
        'vehicles' => Icons.directions_car_rounded,
        'realestate' => Icons.apartment_rounded,
        'electronics' => Icons.smartphone_rounded,
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
    final ads = mockAds.where((a) => _saved.contains(a.id)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'الإعلانات المحفوظة' : 'Saved ads',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ads.isEmpty
                    ? Center(
                        child: Text(
                          ar ? 'لا توجد إعلانات محفوظة' : 'No saved ads',
                          style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                        ),
                      )
                    : ListView(
                        children: ads.map((ad) {
                          return KayanClassifiedAdCard(
                            title: ad.title,
                            locationLine: ad.city,
                            priceLabel: _price(ad, ar),
                            icon: _icon(ad.categorySlug),
                            isFeatured: false,
                            isFavorited: true,
                            onTap: () => context.push(AppRoutes.adPath(ad.slug)),
                            onFavorite: () => setState(() => _saved.remove(ad.id)),
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
