// ============================================================
// KAYAN — Ad Detail Screen
// lib/features/classifieds/ad_detail/presentation/screens/ad_detail_screen.dart
//
// Layout:
//   1. Photo gallery (SliverAppBar PageView + thumbnails)
//   2. Title + price + badges (boosted, negotiable, free)
//   3. Info strip (location, date, views)
//   4. Condition badge
//   5. Description (expandable)
//   6. Seller card (avatar, stats, rating) + Trust indicators
//   7. Safety tips
//   8. Similar ads (horizontal)
//   9. Sticky bottom: Call + WhatsApp + Chat buttons
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../../../../classifieds/browse/data/models/ad_models.dart';

final _adDetailProvider = FutureProvider.autoDispose
    .family<AdModel, String>((ref, slug) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return mockAds.firstWhere(
    (a) => a.slug == slug,
    orElse: () => mockAds.first,
  );
});

class AdDetailScreen extends ConsumerStatefulWidget {
  final String adSlug;
  const AdDetailScreen({super.key, required this.adSlug});

  @override
  ConsumerState<AdDetailScreen> createState() => _AdDetailState();
}

class _AdDetailState extends ConsumerState<AdDetailScreen> {
  final _galCtrl = PageController();
  int  _galIdx   = 0;
  bool _fav      = false;
  bool _descExp  = false;

  @override
  void dispose() { _galCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final adAsync  = ref.watch(_adDetailProvider(widget.adSlug));

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: adAsync.when(
        loading: () => const _AdDetailSkeleton(),
        error:   (e, _) => Center(child: Text(e.toString())),
        data: (ad) => Stack(children: [
          CustomScrollView(slivers: [
            // ── Gallery App Bar ───────────────────────────
            _GalleryAppBar(
              ad:         ad,
              galCtrl:    _galCtrl,
              galIdx:     _galIdx,
              isFav:      _fav,
              onPage:     (i) => setState(() => _galIdx = i),
              onFav:      () => setState(() => _fav = !_fav),
              onShare:    () => HapticFeedback.lightImpact(),
              isArabic:   isArabic,
            ),

            SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Badges ─────────────────────────────
                  Wrap(spacing: 6, children: [
                    if (ad.isBoosted) _Badge('⭐ ${isArabic ? "مميز" : "Featured"}', AppColors.metallicGold),
                    if (ad.isFree)    _Badge('🎁 ${isArabic ? "مجاني" : "Free"}',   AppColors.success),
                    if (ad.isNegotiable) _Badge(isArabic ? 'قابل للتفاوض' : 'Negotiable', AppColors.categoryTeal),
                    _Badge(_conditionLabel(ad.condition, isArabic), AppColors.royalBlue),
                  ]),
                  const SizedBox(height: 10),

                  // ── Title ──────────────────────────────
                  Text(ad.title,
                      style: isArabic
                          ? AppTextStyles.arabicHeadlineMedium.copyWith(fontSize: 20)
                          : AppTextStyles.headlineMedium),
                  const SizedBox(height: 10),

                  // ── Price ──────────────────────────────
                  ad.isFree
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.success, AppColors.successDark]), borderRadius: BorderRadius.circular(12)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Text('🎁', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(isArabic ? 'مجاني — يُعطى هدية' : 'Free — Give Away',
                                style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
                          ]),
                        )
                      : Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text('${ad.price!.toInt()} ${isArabic ? "ر.س" : "SAR"}',
                              style: AppTextStyles.priceHero.copyWith(fontSize: 28, color: AppColors.metallicGold)),
                          if (ad.isNegotiable) ...[
                            const SizedBox(width: 10),
                            Text(isArabic ? '(قابل للتفاوض)' : '(Negotiable)',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.categoryTeal,
                                    fontStyle: FontStyle.italic)),
                          ],
                        ]),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.borderSubtle),
                  const SizedBox(height: 14),

                  // ── Info strip ─────────────────────────
                  Wrap(spacing: 16, runSpacing: 8, children: [
                    _InfoChip(Icons.location_on_rounded, AppColors.royalBlue,
                        '${ad.city}${ad.district.isNotEmpty ? " · ${ad.district}" : ""}'),
                    _InfoChip(Icons.access_time_rounded, AppColors.textMuted, ad.timeAgo(isArabic)),
                    _InfoChip(Icons.visibility_outlined, AppColors.textMuted, '${ad.viewCount} ${isArabic ? "مشاهدة" : "views"}'),
                    _InfoChip(Icons.favorite_border_rounded, AppColors.error, '${ad.favoriteCount} ${isArabic ? "مفضلة" : "saved"}'),
                  ]),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.borderSubtle),
                  const SizedBox(height: 16),

                  // ── Description ────────────────────────
                  Row(children: [
                    Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text(isArabic ? 'وصف الإعلان' : 'Description',
                        style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
                  ]),
                  const SizedBox(height: 10),
                  AnimatedSize(duration: const Duration(milliseconds: 250), curve: Curves.easeOut,
                    child: Text(ad.description ?? '',
                        maxLines: _descExp ? null : 4,
                        overflow: _descExp ? null : TextOverflow.fade,
                        style: (isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium)
                            .copyWith(color: AppColors.textSecondary, height: 1.65))),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => setState(() => _descExp = !_descExp),
                    child: Text(_descExp ? (isArabic ? 'عرض أقل' : 'Show less') : (isArabic ? 'عرض المزيد' : 'Show more'),
                        style: AppTextStyles.seeAll)),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.borderSubtle),
                  const SizedBox(height: 16),
                ],
              )),

              // ── Seller Card ───────────────────────────
              if (ad.seller != null) _SellerCard(seller: ad.seller!, isArabic: isArabic),

              const SizedBox(height: 16),

              // ── Safety Tips ───────────────────────────
              _SafetyTips(isArabic: isArabic),

              const SizedBox(height: 20),

              // ── Similar Ads ───────────────────────────
              _SimilarAdsRow(
                ads:      mockAds.where((a) => a.id != ad.id && a.categorySlug == ad.categorySlug).take(4).toList(),
                isArabic: isArabic,
              ),

              const SizedBox(height: 100),
            ])),
          ]),

          // ── Sticky bottom contact bar ─────────────────
          Positioned(bottom: 0, left: 0, right: 0,
            child: _ContactBar(ad: ad, isArabic: isArabic)),
        ]),
      ),
    );
  }

  String _conditionLabel(AdCondition c, bool ar) =>
      ar ? c.labelAr() : c.labelEn();
}

// ──────────────────────────────────────────────────────────────
// GALLERY APP BAR
// ──────────────────────────────────────────────────────────────
class _GalleryAppBar extends StatelessWidget {
  final AdModel  ad;
  final PageController galCtrl;
  final int      galIdx;
  final bool     isFav, isArabic;
  final ValueChanged<int> onPage;
  final VoidCallback onFav, onShare;

  const _GalleryAppBar({
    required this.ad, required this.galCtrl, required this.galIdx,
    required this.isFav, required this.isArabic,
    required this.onPage, required this.onFav, required this.onShare,
  });

  @override
  Widget build(BuildContext context) => SliverAppBar(
    expandedHeight: ad.imageUrls.length > 1 ? 310 : 260,
    pinned: true, backgroundColor: AppColors.bgScaffold,
    leading: GestureDetector(
      onTap: () => context.pop(),
      child: Container(margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.bgCard.withOpacity(0.9), shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary))),
    actions: [
      GestureDetector(onTap: onShare, child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.bgCard.withOpacity(0.9), shape: BoxShape.circle), width: 40, height: 40,
          child: const Icon(Icons.share_rounded, size: 18))),
      GestureDetector(onTap: onFav, child: Container(margin: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
          decoration: BoxDecoration(color: AppColors.bgCard.withOpacity(0.9), shape: BoxShape.circle), width: 40, height: 40,
          child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 18, color: isFav ? AppColors.error : AppColors.textPrimary))),
    ],
    flexibleSpace: FlexibleSpaceBar(background: Stack(children: [
      // Main gallery
      ad.imageUrls.isEmpty
          ? Container(color: AppColors.bgCard2, child: Center(child: Text(_catEmoji(ad.categorySlug), style: const TextStyle(fontSize: 80))))
          : PageView.builder(
              controller: galCtrl, onPageChanged: onPage,
              itemCount: ad.imageUrls.length,
              itemBuilder: (_, i) => CachedNetworkImage(imageUrl: ad.imageUrls[i], fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.bgCard2),
                  errorWidget: (_, __, ___) => Container(color: AppColors.bgCard2,
                      child: const Icon(Icons.image_outlined, size: 48, color: AppColors.textMuted)))),

      // Gradient overlay
      const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.imageOverlayBottom))),

      // Dot indicator
      if (ad.imageUrls.length > 1)
        Positioned(bottom: ad.imageUrls.length > 1 ? 68 : 12, left: 0, right: 0,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(ad.imageUrls.length, (i) =>
            AnimatedContainer(duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == galIdx ? 16 : 6, height: 6,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
                  color: i == galIdx ? AppColors.metallicGold : Colors.white.withOpacity(0.5)))))),

      // Thumbnail row
      if (ad.imageUrls.length > 1)
        Positioned(
          bottom: 8,
          left: 12,
          right: 12,
          child: SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ad.imageUrls.length,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => galCtrl.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 52,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: i == galIdx
                          ? AppColors.metallicGold
                          : Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: ad.imageUrls[i],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ])),
  );

  String _catEmoji(String slug) => switch (slug) {
    'electronics' => '📱', 'vehicles' => '🚗', 'realestate' => '🏠',
    'furniture' => '🛋️', 'fashion' => '👗', 'jobs' => '💼',
    'sports' => '⚽', 'kids' => '🧸', 'books' => '📚', _ => '📦',
  };
}

// ──────────────────────────────────────────────────────────────
// SELLER CARD
// ──────────────────────────────────────────────────────────────
class _SellerCard extends StatelessWidget {
  final AdSeller seller;
  final bool     isArabic;
  const _SellerCard({required this.seller, required this.isArabic});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
      child: Column(children: [
        Row(children: [
          // Avatar
          Container(width: 52, height: 52, decoration: BoxDecoration(gradient: AppGradients.primaryButton, shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.25), blurRadius: 10)]),
            child: Center(child: Text(seller.name[0], style: const TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(seller.name, style: isArabic ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
              if (seller.isVerified) ...[const SizedBox(width: 6), const Icon(Icons.verified_rounded, size: 14, color: AppColors.royalBlue)],
            ]),
            const SizedBox(height: 3),
            Row(children: [
              const Icon(Icons.star_rounded, size: 12, color: AppColors.starFilled),
              Text(' ${seller.rating.toStringAsFixed(1)}', style: AppTextStyles.rating.copyWith(fontSize: 12)),
              const SizedBox(width: 8),
              Text('· ${seller.totalAds} ${isArabic ? "إعلان" : "ads"}', style: AppTextStyles.caption),
              const SizedBox(width: 8),
              Text('· ${isArabic ? "منذ ${seller.memberDays} يوم" : "${seller.memberDays} days"}',
                  style: AppTextStyles.caption),
            ]),
          ])),
          TextButton(
            onPressed: () {},
            child: Text(isArabic ? 'عرض كل إعلاناته' : 'All Ads',
                style: AppTextStyles.seeAll),
          ),
        ]),

        const SizedBox(height: 12),
        const Divider(color: AppColors.borderSubtle, height: 1),
        const SizedBox(height: 12),

        // Trust indicators
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _TrustItem(Icons.check_circle_outline_rounded, AppColors.success,
              isArabic ? 'هوية مؤكدة' : 'ID Verified'),
          _TrustItem(Icons.phone_outlined, AppColors.royalBlue,
              isArabic ? 'هاتف مؤكد' : 'Phone OK'),
          _TrustItem(Icons.access_time_rounded, AppColors.metallicGold,
              isArabic ? 'متجاوب سريع' : 'Fast Reply'),
        ]),
      ]),
    ),
  );
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final String   label;
  const _TrustItem(this.icon, this.color, this.label);
  @override
  Widget build(BuildContext context) => Column(children: [
    Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: color)),
    const SizedBox(height: 4),
    Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9), textAlign: TextAlign.center),
  ]);
}

// ──────────────────────────────────────────────────────────────
// SAFETY TIPS
// ──────────────────────────────────────────────────────────────
class _SafetyTips extends StatelessWidget {
  final bool isArabic;
  const _SafetyTips({required this.isArabic});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.06),
        borderRadius: AppBorderRadius.md,
        border: Border.all(color: AppColors.warning.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.security_rounded, size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Text(isArabic ? 'نصائح الأمان' : 'Safety Tips',
              style: AppTextStyles.titleSmall.copyWith(color: AppColors.warning)),
        ]),
        const SizedBox(height: 8),
        ...(isArabic ? [
          'لا تُحوّل أموالاً قبل رؤية المنتج شخصياً',
          'تحقق من الشيك والوثائق قبل الإغلاق',
          'الق في مكان عام عند الاستلام',
        ] : [
          'Never transfer money before seeing the item in person',
          'Verify documents before closing any deal',
          'Meet in a public place when picking up',
        ]).map((tip) => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.arrow_right_rounded, size: 14, color: AppColors.warning),
            const SizedBox(width: 4),
            Expanded(child: Text(tip, style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary))),
          ]),
        )),
      ]),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// SIMILAR ADS
// ──────────────────────────────────────────────────────────────
class _SimilarAdsRow extends StatelessWidget {
  final List<AdModel> ads;
  final bool          isArabic;
  const _SimilarAdsRow({required this.ads, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding), child: Row(children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(isArabic ? 'إعلانات مشابهة' : 'Similar Ads', style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
      ])),
      const SizedBox(height: 12),
      SizedBox(height: 190, child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        itemCount: ads.length,
        itemBuilder: (_, i) {
          final ad = ads[i];
          return GestureDetector(
            onTap: () => context.push(AppRoutes.adPath(ad.slug)),
            child: Container(width: 150, margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(height: 95, width: double.infinity, child: ad.hasImages
                    ? CachedNetworkImage(imageUrl: ad.mainImageUrl, fit: BoxFit.cover, placeholder: (_, __) => const ShimmerBox(width: double.infinity, height: 95), errorWidget: (_, __, ___) => Container(color: AppColors.bgCard2))
                    : Container(color: AppColors.bgCard2, child: const Icon(Icons.image_outlined, color: AppColors.textMuted)))),
                Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(ad.title, style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(ad.isFree ? (isArabic ? 'مجاني' : 'Free') : '${ad.price!.toInt()} ر.س',
                      style: AppTextStyles.priceSmall.copyWith(color: ad.isFree ? AppColors.success : AppColors.metallicGold)),
                  const SizedBox(height: 2),
                  Text(ad.city, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
                ])),
              ])),
          );
        },
      )),
    ]);
  }
}

// ──────────────────────────────────────────────────────────────
// CONTACT BAR
// ──────────────────────────────────────────────────────────────
class _ContactBar extends StatelessWidget {
  final AdModel ad;
  final bool    isArabic;
  const _ContactBar({required this.ad, required this.isArabic});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.paddingOf(context).bottom + 12),
    decoration: BoxDecoration(color: AppColors.bgSurface,
        border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, -4))]),
    child: Row(children: [
      // Call button
      _ContactBtn(Icons.phone_rounded, AppColors.success, isArabic ? 'اتصال' : 'Call', () => HapticFeedback.mediumImpact()),
      const SizedBox(width: 8),
      // WhatsApp button
      _ContactBtn(Icons.message_rounded, const Color(0xFF25D366), 'WhatsApp', () => HapticFeedback.mediumImpact()),
      const SizedBox(width: 8),
      // Chat CTA
      Expanded(child: GestureDetector(
        onTap: () { HapticFeedback.mediumImpact(); },
        child: Container(height: 50, decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: AppBorderRadius.button,
            boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]),
          child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(isArabic ? 'مراسلة البائع' : 'Message Seller', style: isArabic ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium),
          ]))),
      )),
    ]),
  );
}

class _ContactBtn extends StatelessWidget {
  final IconData     icon;
  final Color        color;
  final String       label;
  final VoidCallback onTap;
  const _ContactBtn(this.icon, this.color, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 56, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: AppBorderRadius.button, border: Border.all(color: color.withOpacity(0.3))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 20), Text(label, style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.w600))])),
  );
}

// ──────────────────────────────────────────────────────────────
// HELPERS
// ──────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color  color;
  const _Badge(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.3))),
    child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final String   label;
  const _InfoChip(this.icon, this.color, this.label);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 13, color: color),
    const SizedBox(width: 4),
    Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
  ]);
}

class _AdDetailSkeleton extends StatelessWidget {
  const _AdDetailSkeleton();
  @override
  Widget build(BuildContext context) => Column(children: [
    const ShimmerBox(width: double.infinity, height: 260, borderRadius: BorderRadius.zero),
    Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const ShimmerBox(width: 200, height: 14), const SizedBox(height: 10),
      const ShimmerBox(width: double.infinity, height: 24), const SizedBox(height: 10),
      const ShimmerBox(width: 150, height: 32), const SizedBox(height: 16),
      const ShimmerBox(width: double.infinity, height: 80),
    ])),
  ]);
}
