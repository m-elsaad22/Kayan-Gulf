// Ad detail — matches design/html/115-cl-ad-details.html
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

final _adDetailProvider = FutureProvider.autoDispose.family<AdModel, String>((ref, slug) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return mockAds.firstWhere((a) => a.slug == slug, orElse: () => mockAds.first);
});

class AdDetailScreen extends ConsumerStatefulWidget {
  const AdDetailScreen({super.key, required this.adSlug});

  final String adSlug;

  @override
  ConsumerState<AdDetailScreen> createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends ConsumerState<AdDetailScreen> {
  bool _fav = false;

  IconData _categoryIcon(String slug) => switch (slug) {
        'vehicles' => Icons.directions_car_rounded,
        'realestate' => Icons.apartment_rounded,
        'jobs' => Icons.work_rounded,
        'electronics' => Icons.smartphone_rounded,
        'furniture' => Icons.chair_rounded,
        _ => Icons.sell_rounded,
      };

  List<(IconData, String)> _specs(AdModel ad, bool ar) {
    if (ad.categorySlug != 'vehicles') {
      return [
        (Icons.verified_rounded, ar ? ad.condition.labelAr() : ad.condition.labelEn()),
        (Icons.category_rounded, ad.categoryNameAr ?? (ar ? 'عام' : 'General')),
        (Icons.visibility_outlined, '${ad.viewCount}'),
      ];
    }
    final year = 2018 + (ad.id.hashCode.abs() % 7);
    final km = 8000 + (ad.id.hashCode.abs() % 40000);
    return [
      (Icons.speed_rounded, ar ? '$km كم' : '$km km'),
      (Icons.calendar_today_rounded, '$year'),
      (Icons.local_gas_station_rounded, ar ? 'بنزين' : 'Petrol'),
      (Icons.settings_rounded, ar ? 'أوتوماتيك' : 'Auto'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final adAsync = ref.watch(_adDetailProvider(widget.adSlug));

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: adAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (ad) {
          final categoryLabel = ar
              ? (ad.categoryNameAr ?? ad.categorySlug)
              : (ad.categoryNameEn ?? ad.categorySlug);
          final priceLabel = ad.isFree
              ? (ar ? 'مجاني' : 'Free')
              : '${ad.price?.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}';
          final seller = ad.seller;

          return Column(
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: const BoxDecoration(gradient: KayanDesignTokens.secHeroBlue),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.12,
                        child: CustomPaint(painter: _DotPatternPainter()),
                      ),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                        child: Row(
                          children: [
                            KayanHeroIconButton(
                              icon: Icons.arrow_forward_ios_rounded,
                              onTap: () => context.pop(),
                            ),
                            const Spacer(),
                            KayanHeroIconButton(
                              icon: Icons.share_outlined,
                              onTap: () => HapticFeedback.lightImpact(),
                            ),
                            const SizedBox(width: 8),
                            KayanHeroIconButton(
                              icon: _fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              onTap: () => setState(() => _fav = !_fav),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(
                        _categoryIcon(ad.categorySlug),
                        size: 76,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -22),
                  child: KayanEntrySheet(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: KayanDesignTokens.kBlue.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                categoryLabel,
                                style: KayanDesignTokens.cairo(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: KayanDesignTokens.kBlue,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.visibility_outlined, size: 12, color: KayanDesignTokens.muted),
                                const SizedBox(width: 4),
                                Text(
                                  '${ad.viewCount} ${ar ? 'مشاهدة' : 'views'}',
                                  style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ad.title,
                          style: KayanDesignTokens.cairo(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: KayanDesignTokens.kBlueDeep,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          priceLabel,
                          style: KayanDesignTokens.cairo(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: KayanDesignTokens.kBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 14,
                          runSpacing: 6,
                          children: [
                            _MetaLine(Icons.location_on_outlined, '${ad.city}${ad.district.isNotEmpty ? '، ${ad.district}' : ''}'),
                            _MetaLine(Icons.schedule_rounded, ad.timeAgo(ar)),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          decoration: BoxDecoration(
                            color: KayanDesignTokens.bg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _specs(ad, ar)
                                .map(
                                  (s) => Column(
                                    children: [
                                      Icon(s.$1, color: KayanDesignTokens.kBlue, size: 18),
                                      const SizedBox(height: 2),
                                      Text(
                                        s.$2,
                                        style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.text2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        if ((ad.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            ad.description!,
                            style: KayanDesignTokens.cairo(
                              fontSize: 14,
                              color: KayanDesignTokens.text2,
                              height: 1.8,
                            ),
                          ),
                        ],
                        if (seller != null) ...[
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: KayanDesignTokens.border),
                              boxShadow: KayanDesignTokens.shadowS,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    gradient: KayanDesignTokens.gradBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    seller.name.isNotEmpty ? seller.name[0] : '?',
                                    style: KayanDesignTokens.cairo(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        seller.name,
                                        style: KayanDesignTokens.cairo(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: KayanDesignTokens.kBlueDeep,
                                        ),
                                      ),
                                      Text(
                                        ar
                                            ? 'معلن ${seller.isVerified ? 'موثّق' : 'فردي'} · عضو منذ ${seller.memberDays > 300 ? '2023' : '2024'}'
                                            : '${seller.isVerified ? 'Verified' : 'Individual'} · member since ${seller.memberDays > 300 ? '2023' : '2024'}',
                                        style: KayanDesignTokens.cairo(fontSize: 11.5, color: KayanDesignTokens.muted),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(
                                    gradient: KayanDesignTokens.gradBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: const Icon(Icons.phone_rounded, color: Colors.white, size: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        KayanCtaButton(
                          label: ar ? 'مراسلة البائع' : 'Message seller',
                          trailingIcon: Icons.chat_bubble_outline_rounded,
                          variant: KayanCtaVariant.blue,
                          onPressed: () => context.push(AppRoutes.classifiedsChatPath('khalid')),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.similarAdsPath(ad.slug)),
                          child: Text(
                            ar ? 'إعلانات مشابهة' : 'Similar ads',
                            style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: KayanDesignTokens.muted),
        const SizedBox(width: 4),
        Text(text, style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2)),
      ],
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const spacing = 16.0;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
