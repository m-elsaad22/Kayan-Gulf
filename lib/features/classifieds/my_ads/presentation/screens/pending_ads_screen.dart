// Pending ads — light design (extends 119-cl-my-ads review flow)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class PendingAdsScreen extends ConsumerWidget {
  const PendingAdsScreen({super.key});

  IconData _icon(String slug) => switch (slug) {
        'vehicles' => Icons.directions_car_rounded,
        'realestate' => Icons.apartment_rounded,
        'electronics' => Icons.smartphone_rounded,
        _ => Icons.sell_rounded,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final pending = [mockAds[4], mockAds[6]];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'إعلانات قيد المراجعة' : 'Pending ads',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 10),
              KayanOfferBanner(
                title: ar ? 'بانتظار الموافقة' : 'Awaiting approval',
                subtitle: ar ? 'يراجع فريق كيان إعلاناتك خلال 24 ساعة' : 'KAYAN team reviews your ads within 24 hours',
                gradient: KayanDesignTokens.gradOrange,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: pending.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline_rounded, size: 48, color: KayanDesignTokens.kGreen.withValues(alpha: 0.8)),
                            const SizedBox(height: 12),
                            Text(
                              ar ? 'لا توجد إعلانات معلّقة' : 'No pending ads',
                              style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep),
                            ),
                            Text(
                              ar ? 'جميع إعلاناتك منشورة' : 'All your ads are live',
                              style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.muted),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: pending.map((ad) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: KayanDesignTokens.border),
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
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: KayanDesignTokens.kOrange.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(99),
                                            ),
                                            child: Text(
                                              ar ? 'قيد المراجعة' : 'Under review',
                                              style: KayanDesignTokens.cairo(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800,
                                                color: KayanDesignTokens.kOrange,
                                              ),
                                            ),
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
                                          const SizedBox(height: 4),
                                          Text(
                                            '${ad.city} · ${ad.timeAgo(ar)}',
                                            style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => context.push(AppRoutes.adPath(ad.slug)),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: KayanDesignTokens.kBlue,
                                          side: const BorderSide(color: KayanDesignTokens.border),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                                        ),
                                        child: Text(
                                          ar ? 'معاينة' : 'Preview',
                                          style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
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
