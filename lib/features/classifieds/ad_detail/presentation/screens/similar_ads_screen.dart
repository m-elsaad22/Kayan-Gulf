// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class SimilarAdsScreen extends ConsumerWidget {
  final String adSlug;
  const SimilarAdsScreen({super.key, required this.adSlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final current = mockAds.firstWhere(
      (a) => a.slug == adSlug,
      orElse: () => mockAds.first,
    );
    final similar = mockAds
        .where((a) =>
            a.slug != adSlug && a.categorySlug == current.categorySlug)
        .take(8)
        .toList();

    return Phase5ClassifiedsScaffold(
      titleAr: 'إعلانات مشابهة',
      titleEn: 'Similar Ads',
      subtitleAr: 'في نفس الفئة: ${current.categoryNameAr ?? ''}',
      subtitleEn: 'Same category: ${current.categoryNameEn ?? ''}',
      children: similar
          .map(
            (ad) => Phase5ClassifiedsCard(
              icon: Icons.compare_arrows_rounded,
              titleAr: ad.title,
              titleEn: ad.title,
              bodyAr: ad.isFree
                  ? 'مجاني'
                  : '${ad.price?.toInt() ?? 0} ر.س • ${ad.city}',
              bodyEn: ad.isFree
                  ? 'Free'
                  : '${ad.price?.toInt() ?? 0} SAR • ${ad.city}',
              onTap: () => context.push(AppRoutes.adPath(ad.slug)),
            ),
          )
          .toList(),
    );
  }
}
