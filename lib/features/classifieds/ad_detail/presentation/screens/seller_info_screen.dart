// Seller profile — light design (extends 115-cl-ad-details seller card)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class SellerInfoScreen extends ConsumerWidget {
  const SellerInfoScreen({super.key, required this.sellerId});

  final String sellerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    AdSeller seller = const AdSeller(id: 's1', name: 'خالد العتيبي', isVerified: true, totalAds: 12, rating: 4.8, memberDays: 400);
    for (final ad in mockAds) {
      if (ad.seller?.id == sellerId) {
        seller = ad.seller!;
        break;
      }
    }

    var sellerAds = mockAds.where((a) => a.seller?.id == seller.id).take(4).toList();
    if (sellerAds.isEmpty) sellerAds = mockAds.take(2).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'معلومات البائع' : 'Seller info',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: KayanDesignTokens.border),
                  boxShadow: KayanDesignTokens.shadowS,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(
                        seller.name.isNotEmpty ? seller.name[0] : '?',
                        style: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(seller.name, style: KayanDesignTokens.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
                          Text(
                            ar
                                ? '${seller.isVerified ? 'بائع موثّق' : 'بائع فردي'} · ${seller.totalAds} إعلان · ${seller.rating.toStringAsFixed(1)} ⭐'
                                : '${seller.isVerified ? 'Verified' : 'Individual'} · ${seller.totalAds} ads · ${seller.rating.toStringAsFixed(1)} ⭐',
                            style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  KayanStatBox(value: '${seller.totalAds}', label: ar ? 'إعلان' : 'Ads'),
                  const SizedBox(width: 10),
                  KayanStatBox(value: seller.rating.toStringAsFixed(1), label: ar ? 'تقييم' : 'Rating'),
                  const SizedBox(width: 10),
                  KayanStatBox(value: '${seller.memberDays}', label: ar ? 'يوم عضو' : 'Member days'),
                ],
              ),
              const SizedBox(height: 20),
              KayanSectionHeader(title: ar ? 'إعلانات البائع' : 'Seller listings'),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: sellerAds.map((ad) {
                    return KayanClassifiedAdCard(
                      title: ad.title,
                      locationLine: ad.city,
                      priceLabel: ad.isFree ? (ar ? 'مجاني' : 'Free') : '${ad.price?.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                      icon: Icons.sell_rounded,
                      onTap: () => context.push(AppRoutes.adPath(ad.slug)),
                    );
                  }).toList(),
                ),
              ),
              KayanCtaButton(
                label: ar ? 'مراسلة البائع' : 'Message seller',
                trailingIcon: Icons.chat_bubble_outline_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () => context.push(AppRoutes.classifiedsChatPath(seller.id)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
