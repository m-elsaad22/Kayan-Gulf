// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class SavedAdsScreen extends ConsumerWidget {
  const SavedAdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final saved = mockAds.where((a) => a.isFavorited).toList();
    final display = saved.isEmpty ? mockAds.take(3).toList() : saved;

    return Phase5ClassifiedsScaffold(
      titleAr: 'الإعلانات المحفوظة',
      titleEn: 'Saved Ads',
      subtitleAr: 'إعلاناتك المفضلة في مكان واحد.',
      subtitleEn: 'Your favorite listings in one place.',
      children: display
          .map(
            (ad) => Phase5ClassifiedsCard(
              icon: Icons.bookmark_rounded,
              titleAr: ad.title,
              titleEn: ad.title,
              bodyAr: '${ad.city} • ${ad.timeAgo(true)}',
              bodyEn: '${ad.city} • ${ad.timeAgo(false)}',
              onTap: () => context.push(AppRoutes.adPath(ad.slug)),
            ),
          )
          .toList(),
    );
  }
}
