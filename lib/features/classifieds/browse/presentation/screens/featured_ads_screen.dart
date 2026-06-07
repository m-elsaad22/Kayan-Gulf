// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../data/models/ad_models.dart';

class FeaturedAdsScreen extends ConsumerWidget {
  const FeaturedAdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final featured = mockAds.where((a) => a.isFeatured || a.isBoosted).toList();

    return Phase5ClassifiedsScaffold(
      titleAr: 'إعلانات مميزة',
      titleEn: 'Featured Ads',
      subtitleAr: 'أفضل الإعلانات المروّجة والمميزة.',
      subtitleEn: 'Top promoted and featured listings.',
      children: featured.isEmpty
          ? [
              Phase5ClassifiedsCard(
                icon: Icons.star_outline_rounded,
                titleAr: 'لا توجد إعلانات مميزة',
                titleEn: 'No featured ads',
                bodyAr: 'تحقق لاحقاً.',
                bodyEn: 'Check back later.',
              ),
            ]
          : featured
              .map(
                (ad) => Phase5ClassifiedsCard(
                  icon: Icons.star_rounded,
                  color: AppColors.metallicGold,
                  titleAr: ad.title,
                  titleEn: ad.title,
                  bodyAr: ad.isBoosted ? 'مروّج • ${ad.city}' : ad.city,
                  bodyEn: ad.isBoosted ? 'Boosted • ${ad.city}' : ad.city,
                  onTap: () => context.push(AppRoutes.adPath(ad.slug)),
                ),
              )
              .toList(),
    );
  }
}
