// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/app_routes.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class PendingAdsScreen extends ConsumerWidget {
  const PendingAdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = mockMyAds.take(2).toList();

    return Phase5ClassifiedsScaffold(
      titleAr: 'إعلانات قيد المراجعة',
      titleEn: 'Pending Ads',
      subtitleAr: 'بانتظار موافقة فريق كيان.',
      subtitleEn: 'Awaiting KAYAN team approval.',
      children: pending.isEmpty
          ? [
              Phase5ClassifiedsCard(
                icon: Icons.hourglass_top_rounded,
                titleAr: 'لا توجد إعلانات معلّقة',
                titleEn: 'No pending ads',
                bodyAr: 'جميع إعلاناتك منشورة.',
                bodyEn: 'All your ads are live.',
              ),
            ]
          : pending
              .map(
                (myAd) => Phase5ClassifiedsCard(
                  icon: Icons.pending_actions_rounded,
                  titleAr: myAd.ad.title,
                  titleEn: myAd.ad.title,
                  bodyAr: 'قيد المراجعة • ${myAd.ad.city}',
                  bodyEn: 'Under review • ${myAd.ad.city}',
                  onTap: () => context.push(AppRoutes.adPath(myAd.ad.slug)),
                ),
              )
              .toList(),
    );
  }
}
