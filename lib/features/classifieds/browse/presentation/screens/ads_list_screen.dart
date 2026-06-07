// KAYAN — Ads List / Browse Screen
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../../../../../core/services/admin_data_service.dart';
import '../../../../classifieds/browse/data/models/ad_models.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum _SortOpt { newest, priceAsc, priceDesc }

final _adsListProvider = StateProvider<List<AdModel>>(
  (_) => AdminDataService.instance.getClassifiedAds(),
);
final _sortProvider    = StateProvider<_SortOpt>((_) => _SortOpt.newest);
final _searchProvider  = StateProvider<String>((_) => '');

class AdsListScreen extends ConsumerStatefulWidget {
  final String? categorySlug;
  const AdsListScreen({super.key, this.categorySlug});
  @override ConsumerState<AdsListScreen> createState() => _ALS();
}

class _ALS extends ConsumerState<AdsListScreen> {
  final _searchCtrl = TextEditingController();
  bool _isGrid = false;

  @override void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ar   = ref.watch(isArabicProvider);
    final sort = ref.watch(_sortProvider);
    final q    = ref.watch(_searchProvider);

    var ads = AdminDataService.instance.getClassifiedAds().where((a) {
      if (widget.categorySlug != null && a.categorySlug != widget.categorySlug) return false;
      if (q.isNotEmpty && !a.title.contains(q) && !(a.city.contains(q))) return false;
      return true;
    }).toList();

    switch (sort) {
      case _SortOpt.priceAsc:  ads.sort((a,b) => (a.price??0).compareTo(b.price??0)); break;
      case _SortOpt.priceDesc: ads.sort((a,b) => (b.price??0).compareTo(a.price??0)); break;
      default: ads.sort((a,b) => b.createdAt.compareTo(a.createdAt));
    }

    final catName = widget.categorySlug != null
        ? mockAdCategories.firstWhere((c) => c.slug == widget.categorySlug, orElse: () => mockAdCategories.first).nameAr
        : null;

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface, centerTitle: true,
        title: Text(catName ?? (ar ? 'الإعلانات' : 'Classifieds'), style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
        actions: [
          IconButton(icon: Icon(_isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded, size: 22),
              onPressed: () => setState(() => _isGrid = !_isGrid)),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(52),
          child: Container(color: AppColors.bgSurface, padding: const EdgeInsets.fromLTRB(12,0,12,8),
            child: TextField(
              controller: _searchCtrl,
              textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
              onChanged: (v) => ref.read(_searchProvider.notifier).state = v,
              style: ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall,
              decoration: InputDecoration(
                hintText: ar ? 'ابحث في الإعلانات...' : 'Search ads...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ))),
      ),
      body: Column(children: [
        // Sort bar
        Container(height: 44, color: AppColors.bgSurface,
          child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: [
              (ar ? 'الأحدث' : 'Newest',    _SortOpt.newest),
              (ar ? 'سعر ↑' : 'Price ↑',   _SortOpt.priceAsc),
              (ar ? 'سعر ↓' : 'Price ↓',   _SortOpt.priceDesc),
            ].map((e) => GestureDetector(
              onTap: () { HapticFeedback.selectionClick(); ref.read(_sortProvider.notifier).state = e.$2; },
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: sort == e.$2 ? AppGradients.primaryButton : null,
                  color:    sort == e.$2 ? null : AppColors.bgCard,
                  borderRadius: AppBorderRadius.pill,
                  border:   Border.all(color: sort == e.$2 ? Colors.transparent : AppColors.borderDefault),
                ),
                child: Center(child: Text(e.$1, style: AppTextStyles.labelSmall.copyWith(color: sort == e.$2 ? Colors.white : AppColors.textSecondary))),
              ))).toList())),

        Expanded(child: ads.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.search_off_rounded, size: 56, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(ar ? 'لا توجد إعلانات' : 'No ads found', style: ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
            ]))
          : _isGrid
            ? GridView.builder(padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, crossAxisSpacing:10, mainAxisSpacing:10, childAspectRatio:0.72),
                itemCount: ads.length,
                itemBuilder: (_, i) => _AdGridCard(ad: ads[i], isArabic: ar))
            : ListView.separated(padding: const EdgeInsets.all(12), itemCount: ads.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _AdListCard(ad: ads[i], isArabic: ar)),
        ),
      ]),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.postAd),
        backgroundColor: AppColors.metallicGold, foregroundColor: AppColors.bgPrimary,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: Text(ar ? 'نشر' : 'Post', style: AppTextStyles.buttonSmall.copyWith(color: AppColors.bgPrimary)),
      ),
    );
  }
}

class _AdGridCard extends StatelessWidget {
  final AdModel ad; final bool isArabic;
  const _AdGridCard({required this.ad, required this.isArabic});
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(AppRoutes.adPath(ad.slug)),
    child: Container(decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: ad.isBoosted ? AppColors.borderGold : AppColors.borderSubtle)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(height: 110, width: double.infinity,
            child: ad.hasImages ? CachedNetworkImage(imageUrl: ad.mainImageUrl, fit: BoxFit.cover,
                placeholder: (_, __) => const ShimmerBox(width: double.infinity, height: 110),
                errorWidget: (_, __, ___) => Container(color: AppColors.bgCard2))
              : Container(color: AppColors.bgCard2, child: Center(child: const Icon(Icons.image_outlined, color: AppColors.textMuted, size: 32))))),
        Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ad.title, style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(ad.isFree ? (isArabic ? 'مجاني 🎁' : 'Free 🎁') : '${ad.price!.toInt()} ر.س',
              style: AppTextStyles.priceMedium.copyWith(color: ad.isFree ? AppColors.success : AppColors.metallicGold)),
          Row(children: [const Icon(Icons.location_on_outlined, size: 9, color: AppColors.textMuted), const SizedBox(width: 2), Text(ad.city, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted))]),
        ])),
      ])),
  );
}

class _AdListCard extends StatelessWidget {
  final AdModel ad; final bool isArabic;
  const _AdListCard({required this.ad, required this.isArabic});
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(AppRoutes.adPath(ad.slug)),
    child: Container(decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: ad.isBoosted ? AppColors.borderGold : AppColors.borderSubtle)),
      child: Row(children: [
        ClipRRect(borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: SizedBox(width: 90, height: 90, child: ad.hasImages
            ? CachedNetworkImage(imageUrl: ad.mainImageUrl, fit: BoxFit.cover)
            : Container(color: AppColors.bgCard2, child: const Icon(Icons.image_outlined, color: AppColors.textMuted)))),
        Expanded(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ad.title, style: (isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium).copyWith(fontWeight: FontWeight.w600), maxLines: 2),
          const SizedBox(height: 4),
          Text(ad.isFree ? (isArabic ? 'مجاني 🎁' : 'Free 🎁') : '${ad.price!.toInt()} ر.س',
              style: AppTextStyles.priceMedium.copyWith(color: ad.isFree ? AppColors.success : AppColors.metallicGold)),
          const SizedBox(height: 4),
          Row(children: [const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textMuted), const SizedBox(width: 3), Text(ad.city, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)), const SizedBox(width: 8), Text(ad.timeAgo(isArabic), style: AppTextStyles.caption.copyWith(color: AppColors.textDisabled))]),
        ]))),
      ])),
  );
}
