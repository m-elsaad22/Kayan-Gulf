// Ad analytics — matches design/html/127-cl-ad-analytics.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class AdStatsScreen extends ConsumerWidget {
  const AdStatsScreen({super.key, required this.adId});

  final String adId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final myAd = mockMyAds.firstWhere((m) => m.ad.id == adId, orElse: () => mockMyAds.first);
    final ad = myAd.ad;
    final chats = (ad.viewCount / 32).round();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'إحصائيات الإعلان' : 'Ad analytics',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 10),
              KayanClassifiedAdCard(
                title: ad.title,
                locationLine: ad.city,
                priceLabel: ad.isFree ? (ar ? 'مجاني' : 'Free') : '${ad.price?.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                icon: Icons.directions_car_rounded,
                isFeatured: false,
                onTap: () => context.push(AppRoutes.adPath(ad.slug)),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  KayanStatBox(value: '${ad.viewCount}', label: ar ? 'مشاهدة' : 'Views'),
                  const SizedBox(width: 10),
                  KayanStatBox(value: '$chats', label: ar ? 'محادثة' : 'Chats'),
                  const SizedBox(width: 10),
                  KayanStatBox(value: '${ad.favoriteCount}', label: ar ? 'حفظ للمفضلة' : 'Saves'),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                ar ? 'أداء الإعلان هذا الأسبوع' : 'Performance this week',
                style: KayanDesignTokens.cairo(fontSize: 13.5, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 10),
              Container(
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: KayanDesignTokens.bg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [0.4, 0.65, 0.5, 0.9, 0.75, 1.0, 0.6].map((h) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          height: 88 * h,
                          decoration: const BoxDecoration(
                            gradient: KayanDesignTokens.gradBlue,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'ميّز الإعلان لمزيد من المشاهدات' : 'Promote for more views',
                trailingIcon: Icons.star_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () => context.push(AppRoutes.boostAdPath(ad.id)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
