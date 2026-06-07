// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../routing/app_routes.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class RejectedAdsScreen extends ConsumerWidget {
  const RejectedAdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rejected = mockMyAds.skip(2).take(1).toList();

    return Phase5ClassifiedsScaffold(
      titleAr: 'إعلانات مرفوضة',
      titleEn: 'Rejected Ads',
      subtitleAr: 'راجع السبب وأعد النشر بعد التعديل.',
      subtitleEn: 'Review the reason and republish after edits.',
      children: rejected.isEmpty
          ? [
              Phase5ClassifiedsCard(
                icon: Icons.check_circle_outline_rounded,
                titleAr: 'لا توجد إعلانات مرفوضة',
                titleEn: 'No rejected ads',
                bodyAr: 'حالة ممتازة!',
                bodyEn: 'Looking good!',
              ),
            ]
          : rejected
              .map(
                (myAd) => Phase5ClassifiedsCard(
                  icon: Icons.block_rounded,
                  color: AppColors.error,
                  titleAr: myAd.ad.title,
                  titleEn: myAd.ad.title,
                  bodyAr: 'مرفوض: صورة غير واضحة',
                  bodyEn: 'Rejected: unclear photo',
                  onTap: () => context.push(AppRoutes.editAdPath(myAd.ad.id)),
                ),
              )
              .toList(),
    );
  }
}
