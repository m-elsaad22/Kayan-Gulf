// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class RecentViewsScreen extends ConsumerWidget {
  const RecentViewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final recent = mockAds.take(5).toList();

    return Phase5ClassifiedsScaffold(
      titleAr: 'شوهد مؤخراً',
      titleEn: 'Recently Viewed',
      subtitleAr: 'آخر الإعلانات التي زرتها.',
      subtitleEn: 'Ads you viewed recently.',
      children: recent
          .map(
            (ad) => Phase5ClassifiedsCard(
              icon: Icons.history_rounded,
              titleAr: ad.title,
              titleEn: ad.title,
              bodyAr: ad.timeAgo(true),
              bodyEn: ad.timeAgo(false),
              onTap: () => context.push(AppRoutes.adPath(ad.slug)),
            ),
          )
          .toList(),
    );
  }
}
