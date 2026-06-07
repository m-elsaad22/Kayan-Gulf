// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class AdStatsScreen extends ConsumerWidget {
  final String adId;
  const AdStatsScreen({super.key, required this.adId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAd = mockMyAds.firstWhere(
      (m) => m.ad.id == adId,
      orElse: () => mockMyAds.first,
    );
    final ad = myAd.ad;

    return Phase5ClassifiedsScaffold(
      titleAr: 'إحصائيات الإعلان',
      titleEn: 'Ad Statistics',
      subtitleAr: ad.title,
      subtitleEn: ad.title,
      children: [
        Phase5ClassifiedsCard(
          icon: Icons.visibility_outlined,
          titleAr: 'المشاهدات',
          titleEn: 'Views',
          bodyAr: '${ad.viewCount} مشاهدة',
          bodyEn: '${ad.viewCount} views',
        ),
        Phase5ClassifiedsCard(
          icon: Icons.favorite_border_rounded,
          titleAr: 'المفضلة',
          titleEn: 'Favorites',
          bodyAr: '${ad.favoriteCount} حفظ',
          bodyEn: '${ad.favoriteCount} saves',
        ),
        Phase5ClassifiedsCard(
          icon: Icons.chat_bubble_outline_rounded,
          titleAr: 'الرسائل',
          titleEn: 'Messages',
          bodyAr: '${(ad.viewCount / 10).round()} محادثة',
          bodyEn: '${(ad.viewCount / 10).round()} chats',
        ),
        Phase5ClassifiedsCard(
          icon: Icons.trending_up_rounded,
          titleAr: 'الأداء',
          titleEn: 'Performance',
          bodyAr: ad.isBoosted ? 'إعلان مروّج' : 'إعلان عادي',
          bodyEn: ad.isBoosted ? 'Boosted listing' : 'Standard listing',
        ),
      ],
    );
  }
}
