// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class SellerInfoScreen extends ConsumerWidget {
  final String sellerId;
  const SellerInfoScreen({super.key, required this.sellerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    AdSeller seller = const AdSeller(id: 's1', name: 'KAYAN Seller');
    for (final ad in mockAds) {
      if (ad.seller?.id == sellerId) {
        seller = ad.seller!;
        break;
      }
    }

    return Phase5ClassifiedsScaffold(
      titleAr: 'معلومات البائع',
      titleEn: 'Seller Info',
      subtitleAr: seller.name,
      subtitleEn: seller.name,
      children: [
        Phase5ClassifiedsCard(
          icon: Icons.verified_user_outlined,
          titleAr: 'عضو موثّق',
          titleEn: 'Verified member',
          bodyAr: seller.isVerified ? 'حساب موثّق' : 'غير موثّق',
          bodyEn: seller.isVerified ? 'Verified account' : 'Not verified',
        ),
        Phase5ClassifiedsCard(
          icon: Icons.campaign_outlined,
          titleAr: 'إعلانات نشطة',
          titleEn: 'Active ads',
          bodyAr: '${seller.totalAds} إعلان',
          bodyEn: '${seller.totalAds} ads',
        ),
        Phase5ClassifiedsCard(
          icon: Icons.star_rate_rounded,
          titleAr: 'التقييم',
          titleEn: 'Rating',
          bodyAr: '${seller.rating.toStringAsFixed(1)} / 5',
          bodyEn: '${seller.rating.toStringAsFixed(1)} / 5',
        ),
        Phase5ClassifiedsCard(
          icon: Icons.calendar_today_outlined,
          titleAr: 'عضو منذ',
          titleEn: 'Member for',
          bodyAr: '${seller.memberDays} يوم',
          bodyEn: '${seller.memberDays} days',
        ),
        ElevatedButton(
          onPressed: () => context.pop(),
          child: Text(ar ? 'رجوع' : 'Back'),
        ),
      ],
    );
  }
}
