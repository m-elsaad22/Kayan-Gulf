// Rejected ads — light design (extends 119-cl-my-ads rejection flow)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class RejectedAdsScreen extends ConsumerWidget {
  const RejectedAdsScreen({super.key});

  IconData _icon(String slug) => switch (slug) {
        'vehicles' => Icons.directions_car_rounded,
        'realestate' => Icons.apartment_rounded,
        'electronics' => Icons.smartphone_rounded,
        _ => Icons.sell_rounded,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final rejected = [(ad: mockAds[5], reasonAr: 'صورة غير واضحة', reasonEn: 'Unclear photo')];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'إعلانات مرفوضة' : 'Rejected ads',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 10),
              KayanOfferBanner(
                title: ar ? 'راجع السبب وأعد النشر' : 'Review reason and republish',
                subtitle: ar ? 'عدّل الإعلان ثم أرسله مجدداً للمراجعة' : 'Edit the ad and submit again for review',
                gradient: LinearGradient(
                  colors: [KayanDesignTokens.danger, KayanDesignTokens.danger.withValues(alpha: 0.75)],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: rejected.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline_rounded, size: 48, color: KayanDesignTokens.kGreen.withValues(alpha: 0.8)),
                            const SizedBox(height: 12),
                            Text(
                              ar ? 'لا توجد إعلانات مرفوضة' : 'No rejected ads',
                              style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: rejected.map((item) {
                          final ad = item.ad;
                          final reason = ar ? item.reasonAr : item.reasonEn;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: KayanDesignTokens.danger.withValues(alpha: 0.25)),
                              boxShadow: KayanDesignTokens.shadowS,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        gradient: KayanDesignTokens.gradBlue,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(_icon(ad.categorySlug), color: Colors.white, size: 28),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.block_rounded, size: 14, color: KayanDesignTokens.danger),
                                              const SizedBox(width: 4),
                                              Text(
                                                ar ? 'مرفوض' : 'Rejected',
                                                style: KayanDesignTokens.cairo(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: KayanDesignTokens.danger,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            ad.title,
                                            style: KayanDesignTokens.cairo(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: KayanDesignTokens.kBlueDeep,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: KayanDesignTokens.danger.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info_outline_rounded, size: 16, color: KayanDesignTokens.danger),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          ar ? 'السبب: $reason' : 'Reason: $reason',
                                          style: KayanDesignTokens.cairo(fontSize: 12.5, color: KayanDesignTokens.text2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                KayanCtaButton(
                                  label: ar ? 'تعديل وإعادة النشر' : 'Edit and republish',
                                  trailingIcon: Icons.edit_rounded,
                                  variant: KayanCtaVariant.blue,
                                  onPressed: () => context.push(AppRoutes.editAdPath(ad.id)),
                                ),
                              ],
                            ),
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
