// ============================================================
// KAYAN — Classifieds Home Screen
// lib/features/classifieds/browse/presentation/screens/classifieds_home_screen.dart
//
// Layout:
//   1. SliverAppBar: "الإعلانات" + search + post button
//   2. Featured/Boosted ads carousel (gold border)
//   3. Category pills (horizontal scroll)
//   4. Recent ads grid (2-col masonry-style)
//   5. "My Ads" shortcut card
//   6. Post free ad CTA strip
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
import '../../data/models/ad_models.dart';

final _classifiedsProvider = FutureProvider.autoDispose<List<AdModel>>(
  (ref) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockAds;
  },
);

class ClassifiedsHomeScreen extends ConsumerStatefulWidget {
  const ClassifiedsHomeScreen({super.key});

  @override
  ConsumerState<ClassifiedsHomeScreen> createState() =>
      _ClassifiedsHomeScreenState();
}

class _ClassifiedsHomeScreenState
    extends ConsumerState<ClassifiedsHomeScreen> {
  String? _selectedCatSlug;

  @override
  Widget build(BuildContext context) {
    final isArabic  = ref.watch(isArabicProvider);
    final adsAsync  = ref.watch(_classifiedsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // ── SliverAppBar ──────────────────────────────────
          _ClassifiedsAppBar(isArabic: isArabic),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Featured ads ─────────────────────────
                _FeaturedAdsStrip(
                  ads:      adsAsync.value?.where((a) => a.isFeatured || a.isBoosted).toList() ?? [],
                  isArabic: isArabic,
                ),

                const SizedBox(height: 20),

                // ── Category pills ────────────────────────
                _CategoryFilter(
                  selected:  _selectedCatSlug,
                  isArabic:  isArabic,
                  onSelect:  (slug) => setState(() =>
                      _selectedCatSlug = _selectedCatSlug == slug ? null : slug),
                ),

                const SizedBox(height: 20),

                // ── Section header ────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                  child: Row(
                    children: [
                      Container(width: 3, height: 18, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'أحدث الإعلانات' : 'Latest Ads',
                        style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.adsList),
                        child: Text(isArabic ? 'عرض الكل' : 'See All', style: AppTextStyles.seeAll),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Ads grid ──────────────────────────────
                adsAsync.when(
                  loading: () => _AdsGridSkeleton(),
                  error:   (_, __) => const SizedBox.shrink(),
                  data:    (ads) {
                    final filtered = _selectedCatSlug == null
                        ? ads
                        : ads.where((a) => a.categorySlug == _selectedCatSlug).toList();
                    if (filtered.isEmpty) {
                      return _EmptyCategory(isArabic: isArabic);
                    }
                    return _AdsGrid(ads: filtered, isArabic: isArabic);
                  },
                ),

                const SizedBox(height: 20),

                // ── My ads shortcut ───────────────────────
                _MyAdsCard(isArabic: isArabic),

                const SizedBox(height: 16),

                // ── Post free ad CTA ──────────────────────
                _PostAdBanner(isArabic: isArabic),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // ── Floating post button ──────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.push(AppRoutes.postAd);
        },
        backgroundColor: AppColors.metallicGold,
        foregroundColor: AppColors.bgPrimary,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(
          isArabic ? 'نشر إعلان' : 'Post Ad',
          style: AppTextStyles.buttonSmall.copyWith(color: AppColors.bgPrimary),
        ),
        elevation: 8,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// APP BAR
// ──────────────────────────────────────────────────────────────
class _ClassifiedsAppBar extends StatelessWidget {
  final bool isArabic;
  const _ClassifiedsAppBar({required this.isArabic});

  @override
  Widget build(BuildContext context) => SliverAppBar(
    pinned:          true,
    expandedHeight:  120,
    backgroundColor: AppColors.bgSurface,
    flexibleSpace: FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(children: [
                Text(isArabic ? 'الإعلانات المبوّبة' : 'Classifieds',
                    style: isArabic ? AppTextStyles.arabicHeadlineSmall : AppTextStyles.headlineSmall),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.myAds),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard.withOpacity(0.7),
                      borderRadius: AppBorderRadius.pill,
                      border: Border.all(color: AppColors.borderDefault),
                    ),
                    child: Row(children: [
                      const Icon(Icons.list_alt_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 5),
                      Text(isArabic ? 'إعلاناتي' : 'My Ads',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
            ],
          ),
        )),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        color: AppColors.bgSurface,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: GestureDetector(
          onTap: () => context.push(AppRoutes.adsList),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: AppBorderRadius.pill,
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Row(children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Expanded(child: Text(
                isArabic ? 'ابحث في الإعلانات...' : 'Search classifieds...',
                style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textMuted),
              )),
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.royalBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isArabic ? 'فلتر' : 'Filter',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.royalBlue)),
              ),
            ]),
          ),
        ),
      ),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// FEATURED ADS STRIP
// ──────────────────────────────────────────────────────────────
class _FeaturedAdsStrip extends StatelessWidget {
  final List<AdModel> ads;
  final bool          isArabic;
  const _FeaturedAdsStrip({required this.ads, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) return const SizedBox.shrink();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        child: Row(children: [
          Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(isArabic ? '⭐ إعلانات مميزة' : '⭐ Featured Ads',
              style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        ]),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          itemCount: ads.length,
          itemBuilder: (_, i) => _FeaturedAdCard(ad: ads[i], isArabic: isArabic),
        ),
      ),
    ]);
  }
}

class _FeaturedAdCard extends StatelessWidget {
  final AdModel ad;
  final bool    isArabic;
  const _FeaturedAdCard({required this.ad, required this.isArabic});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(AppRoutes.adPath(ad.slug)),
    child: Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppBorderRadius.card,
        border: Border.all(color: AppColors.borderGold, width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.metallicGold.withOpacity(0.08), blurRadius: 12)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image
        Stack(children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 120, width: double.infinity,
              child: ad.hasImages
                  ? CachedNetworkImage(imageUrl: ad.mainImageUrl, fit: BoxFit.cover,
                      placeholder: (_, __) => const ShimmerBox(width: double.infinity, height: 120),
                      errorWidget: (_, __, ___) => Container(color: AppColors.bgCard2,
                          child: const Icon(Icons.image_outlined, color: AppColors.textMuted, size: 32)))
                  : Container(color: AppColors.bgCard2,
                      child: Center(child: Text(ad.categoryNameAr != null ? '📦' : '📦', style: const TextStyle(fontSize: 36)))),
            ),
          ),
          Positioned(top: 8, left: 8, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(6)),
            child: const Text('⭐ مميز', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black)),
          )),
        ]),

        Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ad.title, style: isArabic ? AppTextStyles.arabicBodyMedium.copyWith(fontWeight: FontWeight.w600)
              : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(children: [
            Text(
              ad.isFree ? (isArabic ? 'مجاني 🎁' : 'Free 🎁') : '${ad.price!.toInt()} ${isArabic ? "ر.س" : "SAR"}',
              style: AppTextStyles.priceMedium.copyWith(
                color: ad.isFree ? AppColors.success : AppColors.metallicGold),
            ),
            if (ad.isNegotiable) ...[
              const SizedBox(width: 6),
              _Pill(isArabic ? 'قابل للتفاوض' : 'Negotiable', AppColors.categoryTeal),
            ],
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.location_on_outlined, size: 10, color: AppColors.textMuted),
            const SizedBox(width: 3),
            Text('${ad.city}${ad.district.isNotEmpty ? " • ${ad.district}" : ""}',
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
          ]),
        ])),
      ]),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// CATEGORY FILTER PILLS
// ──────────────────────────────────────────────────────────────
class _CategoryFilter extends StatelessWidget {
  final String?  selected;
  final bool     isArabic;
  final ValueChanged<String> onSelect;
  const _CategoryFilter({required this.selected, required this.isArabic, required this.onSelect});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      children: [
        // All pill
        _FilterPill(
          label: isArabic ? 'الكل' : 'All',
          icon:  '🔷',
          selected: selected == null,
          onTap: () => onSelect(''),
        ),
        ...mockAdCategories.map((cat) => _FilterPill(
          label:    isArabic ? cat.nameAr : cat.nameEn,
          icon:     cat.emoji,
          selected: selected == cat.slug,
          onTap:    () => onSelect(cat.slug),
        )),
      ],
    ),
  );
}

class _FilterPill extends StatelessWidget {
  final String   label, icon;
  final bool     selected;
  final VoidCallback onTap;
  const _FilterPill({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        gradient: selected ? AppGradients.primaryButton : null,
        color:    selected ? null : AppColors.bgCard,
        borderRadius: AppBorderRadius.pill,
        border: Border.all(color: selected ? Colors.transparent : AppColors.borderDefault),
        boxShadow: selected ? [BoxShadow(color: AppColors.royalBlue.withOpacity(0.3), blurRadius: 8)] : [],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.labelSmall.copyWith(
          color: selected ? Colors.white : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        )),
      ]),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// ADS GRID (2-col)
// ──────────────────────────────────────────────────────────────
class _AdsGrid extends StatelessWidget {
  final List<AdModel> ads;
  final bool          isArabic;
  const _AdsGrid({required this.ads, required this.isArabic});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
    child: GridView.builder(
      shrinkWrap: true,
      physics:    const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   2,
        crossAxisSpacing: 12,
        mainAxisSpacing:  12,
        childAspectRatio: 0.72,
      ),
      itemCount:   ads.length,
      itemBuilder: (_, i) => _AdCard(ad: ads[i], isArabic: isArabic),
    ),
  );
}

class _AdCard extends StatefulWidget {
  final AdModel ad;
  final bool    isArabic;
  const _AdCard({required this.ad, required this.isArabic});

  @override
  State<_AdCard> createState() => _AdCardState();
}

class _AdCardState extends State<_AdCard> {
  bool _fav = false;

  @override
  Widget build(BuildContext context) {
    final ad = widget.ad;
    final ar = widget.isArabic;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.adPath(ad.slug)),
      child: Container(
        decoration: BoxDecoration(
          color:        AppColors.bgCard,
          borderRadius: AppBorderRadius.card,
          border:       Border.all(
            color: ad.isBoosted ? AppColors.borderGold : AppColors.borderSubtle,
            width: ad.isBoosted ? 1.5 : 1,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image
          Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 120, width: double.infinity,
                child: ad.hasImages
                    ? CachedNetworkImage(imageUrl: ad.mainImageUrl, fit: BoxFit.cover,
                        placeholder: (_, __) => const ShimmerBox(width: double.infinity, height: 120),
                        errorWidget: (_, __, ___) => _AdImageFallback(ad))
                    : _AdImageFallback(ad),
              ),
            ),
            // Boosted badge
            if (ad.isBoosted)
              Positioned(top: 6, left: 6, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(5)),
                child: const Text('⭐', style: TextStyle(fontSize: 9)),
              )),
            // Free badge
            if (ad.isFree)
              Positioned(top: 6, left: 6, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(5)),
                child: const Text('مجاني', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white)),
              )),
            // Favorite
            Positioned(top: 6, right: 6, child: GestureDetector(
              onTap: () { HapticFeedback.lightImpact(); setState(() => _fav = !_fav); },
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: AppColors.bgCard.withOpacity(0.85), shape: BoxShape.circle),
                child: Icon(_fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 14, color: _fav ? AppColors.error : AppColors.textMuted),
              ),
            )),
            // Image count
            if (ad.imageUrls.length > 1)
              Positioned(bottom: 6, right: 6, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.photo_library_outlined, size: 9, color: Colors.white),
                  const SizedBox(width: 3),
                  Text('${ad.imageUrls.length}', style: const TextStyle(fontSize: 8, color: Colors.white)),
                ]),
              )),
          ]),

          // Info
          Padding(padding: const EdgeInsets.all(8), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ad.title, style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall)
                  .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 5),
              Text(
                ad.isFree
                    ? (ar ? 'مجاني 🎁' : 'Free 🎁')
                    : '${ad.price!.toInt()} ${ar ? "ر.س" : "SAR"}',
                style: AppTextStyles.priceMedium.copyWith(
                  fontSize:  16,
                  color:     ad.isFree ? AppColors.success : AppColors.metallicGold,
                ),
              ),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 9, color: AppColors.textMuted),
                const SizedBox(width: 2),
                Expanded(child: Text(ad.city, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted), overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 2),
              Row(children: [
                Text(ad.timeAgo(ar), style: AppTextStyles.caption.copyWith(color: AppColors.textDisabled, fontSize: 9)),
                const Spacer(),
                Icon(Icons.visibility_outlined, size: 9, color: AppColors.textDisabled),
                const SizedBox(width: 2),
                Text('${ad.viewCount}', style: AppTextStyles.caption.copyWith(color: AppColors.textDisabled, fontSize: 9)),
              ]),
            ],
          )),
        ]),
      ),
    );
  }
}

class _AdImageFallback extends StatelessWidget {
  final AdModel ad;
  const _AdImageFallback(this.ad);
  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.bgCard2,
    child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(ad.categoryNameAr != null ? _catEmoji(ad.categorySlug) : '📦',
          style: const TextStyle(fontSize: 32)),
    ])),
  );
  String _catEmoji(String slug) => switch (slug) {
    'electronics' => '📱', 'vehicles' => '🚗', 'realestate' => '🏠',
    'furniture' => '🛋️', 'fashion' => '👗', 'jobs' => '💼',
    'sports' => '⚽', 'kids' => '🧸', 'books' => '📚', _ => '📦',
  };
}

// ──────────────────────────────────────────────────────────────
// MY ADS SHORTCUT
// ──────────────────────────────────────────────────────────────
class _MyAdsCard extends StatelessWidget {
  final bool isArabic;
  const _MyAdsCard({required this.isArabic});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(AppRoutes.myAds),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppGradients.primaryButton,
          borderRadius: AppBorderRadius.card,
          boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.list_alt_rounded, color: Colors.white, size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isArabic ? 'إدارة إعلاناتي' : 'Manage My Ads',
                style: isArabic ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
            Text(isArabic ? 'لديك 3 إعلانات نشطة — انقر لإدارتها' : '3 active ads — tap to manage',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white70),
        ]),
      ),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// POST AD BANNER
// ──────────────────────────────────────────────────────────────
class _PostAdBanner extends StatelessWidget {
  final bool isArabic;
  const _PostAdBanner({required this.isArabic});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(AppRoutes.postAd),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppGradients.goldPremium,
          borderRadius: AppBorderRadius.card,
          boxShadow: [BoxShadow(color: AppColors.metallicGold.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Row(children: [
          const Text('📢', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isArabic ? 'انشر إعلانك مجاناً!' : 'Post Your Ad for Free!',
                style: AppTextStyles.titleSmall.copyWith(color: AppColors.bgPrimary)),
            Text(isArabic ? 'بيع، أجّر، أو اعرض خدماتك لآلاف المستخدمين' : 'Sell, rent, or advertise to thousands',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.bgPrimary.withOpacity(0.7))),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.bgPrimary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Text(isArabic ? 'ابدأ الآن' : 'Start Now',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.bgPrimary, fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// HELPERS
// ──────────────────────────────────────────────────────────────
class _Pill extends StatelessWidget {
  final String label;
  final Color  color;
  const _Pill(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.3))),
    child: Text(label, style: AppTextStyles.badge.copyWith(color: color)),
  );
}

class _EmptyCategory extends StatelessWidget {
  final bool isArabic;
  const _EmptyCategory({required this.isArabic});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Center(child: Column(children: [
      const Icon(Icons.search_off_rounded, size: 56, color: AppColors.textMuted),
      const SizedBox(height: 12),
      Text(isArabic ? 'لا توجد إعلانات في هذه الفئة' : 'No ads in this category',
          style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium),
    ])),
  );
}

class _AdsGridSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
    child: GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72,
      children: List.generate(6, (_) => const ShimmerBox(width: double.infinity, height: double.infinity,
          borderRadius: BorderRadius.all(Radius.circular(16))))),
  );
}
