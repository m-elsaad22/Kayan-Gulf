// ============================================================
// KAYAN — My Ads Screen
// lib/features/classifieds/my_ads/presentation/screens/my_ads_screen.dart
//
// Features:
//   • Tab bar: الكل / نشط / موقوف / مُباع / منتهي
//   • Ad cards with stats (views, favorites, days left)
//   • Quick actions: Edit / Pause-Resume / Boost / Delete
//   • Boost bottom sheet with pricing
//   • Empty state with CTA
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

Color _statusColor(String s) => switch (s) {
  'ACTIVE'  => AppColors.success,
  'PAUSED'  => AppColors.warning,
  'SOLD'    => AppColors.royalBlue,
  'EXPIRED' => AppColors.error,
  _         => AppColors.textMuted,
};

class MyAdsScreen extends ConsumerStatefulWidget {
  const MyAdsScreen({super.key});
  @override
  ConsumerState<MyAdsScreen> createState() => _MyAdsState();
}

class _MyAdsState extends ConsumerState<MyAdsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  late List<MyAdModel> _ads;

  final _statusFilters = <String?>[null, 'ACTIVE', 'PAUSED', 'SOLD', 'EXPIRED'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _statusFilters.length, vsync: this);
    _ads = List.from(mockMyAds);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  List<MyAdModel> _filtered(String? status) =>
      status == null ? _ads : _ads.where((a) => a.status == status).toList();

  void _togglePause(String adId) {
    setState(() {
      _ads = _ads.map((m) {
        if (m.ad.id != adId) return m;
        final newStatus = m.status == 'ACTIVE' ? 'PAUSED' : 'ACTIVE';
        return MyAdModel(ad: m.ad, status: newStatus, daysLeft: m.daysLeft, canBoost: m.canBoost);
      }).toList();
    });
  }

  void _deleteAd(String adId) {
    setState(() => _ads = _ads.where((m) => m.ad.id != adId).toList());
    final isArabic = ref.read(isArabicProvider);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isArabic ? 'تم حذف الإعلان' : 'Ad deleted'),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
    ));
  }

  void _showBoostSheet(BuildContext context, MyAdModel m, bool isArabic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgBottomSheet,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _BoostSheet(myAd: m, isArabic: isArabic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Text(isArabic ? 'إعلاناتي' : 'My Ads',
            style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(
          icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop()),
        actions: [
          IconButton(
            icon: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(10)),
              child: Text(isArabic ? '+ نشر' : '+ Post',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.bgPrimary, fontWeight: FontWeight.w700))),
            onPressed: () => context.push(AppRoutes.postAd),
          ),
        ],
        bottom: TabBar(
          controller:           _tab,
          isScrollable:         true,
          tabAlignment:         TabAlignment.start,
          indicatorColor:       AppColors.royalBlue,
          indicatorWeight:      2,
          labelColor:           AppColors.royalBlue,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle:    AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTextStyles.labelMedium,
          padding:       EdgeInsets.zero,
          tabs: [
            Tab(text: isArabic ? 'الكل (${_ads.length})' : 'All (${_ads.length})'),
            Tab(text: isArabic ? 'نشط' : 'Active'),
            Tab(text: isArabic ? 'موقوف' : 'Paused'),
            Tab(text: isArabic ? 'مُباع' : 'Sold'),
            Tab(text: isArabic ? 'منتهي' : 'Expired'),
          ],
        ),
      ),

      // Stats bar
      body: Column(children: [
        _StatsBar(ads: _ads, isArabic: isArabic),

        Expanded(child: TabBarView(
          controller: _tab,
          children: _statusFilters.map((f) {
            final list = _filtered(f);
            if (list.isEmpty) return _EmptyAds(isArabic: isArabic);
            return ListView.separated(
              padding:     const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount:   list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _MyAdCard(
                myAd:       list[i],
                isArabic:   isArabic,
                onToggle:   () => _togglePause(list[i].ad.id),
                onBoost:    () => _showBoostSheet(context, list[i], isArabic),
                onEdit:     () => context.push(AppRoutes.editAdPath(list[i].ad.id)),
                onDelete:   () => _showDeleteDialog(context, list[i].ad.id, isArabic),
              ),
            );
          }).toList(),
        )),
      ]),
    );
  }

  void _showDeleteDialog(BuildContext ctx, String adId, bool isArabic) {
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: Text(isArabic ? 'حذف الإعلان؟' : 'Delete Ad?'),
      content: Text(isArabic ? 'هل أنت متأكد؟ لا يمكن التراجع عن الحذف.' : 'Are you sure? This action cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(isArabic ? 'إلغاء' : 'Cancel')),
        TextButton(onPressed: () { Navigator.pop(ctx); _deleteAd(adId); },
            child: Text(isArabic ? 'حذف' : 'Delete', style: const TextStyle(color: AppColors.error))),
      ],
    ));
  }
}

// ── Stats Bar ─────────────────────────────────────────────────
class _StatsBar extends StatelessWidget {
  final List<MyAdModel> ads;
  final bool            isArabic;
  const _StatsBar({required this.ads, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final totalViews = ads.fold(0, (s, m) => s + m.ad.viewCount);
    final totalFavs  = ads.fold(0, (s, m) => s + m.ad.favoriteCount);
    final active     = ads.where((m) => m.status == 'ACTIVE').length;

    return Container(
      color: AppColors.bgSurface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _StatItem('${ads.length}', isArabic ? 'إجمالي الإعلانات' : 'Total Ads', AppColors.royalBlue),
        _VDivider(),
        _StatItem('$active', isArabic ? 'نشط' : 'Active', AppColors.success),
        _VDivider(),
        _StatItem('$totalViews', isArabic ? 'مشاهدة' : 'Views', AppColors.metallicGold),
        _VDivider(),
        _StatItem('$totalFavs', isArabic ? 'مفضلة' : 'Saved', AppColors.error),
      ]),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color  color;
  const _StatItem(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
    Text(label, style: AppTextStyles.caption),
  ]);
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 32, color: AppColors.borderSubtle);
}

// ── My Ad Card ────────────────────────────────────────────────
class _MyAdCard extends StatelessWidget {
  final MyAdModel    myAd;
  final bool         isArabic;
  final VoidCallback onToggle, onBoost, onEdit, onDelete;
  const _MyAdCard({required this.myAd, required this.isArabic,
    required this.onToggle, required this.onBoost, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final ad    = myAd.ad;
    final color = _statusColor(myAd.status);

    return Container(
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card,
          border: Border.all(color: myAd.status == 'ACTIVE' ? AppColors.borderSubtle : color.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Padding(padding: const EdgeInsets.fromLTRB(12, 12, 12, 10), child: Row(children: [
          // Thumbnail
          ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(width: 60, height: 60,
            child: ad.hasImages
                ? CachedNetworkImage(imageUrl: ad.mainImageUrl, fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerBox(width: 60, height: 60),
                    errorWidget: (_, __, ___) => Container(color: AppColors.bgCard2, child: const Icon(Icons.image_outlined, color: AppColors.textMuted)))
                : Container(color: AppColors.bgCard2, child: Center(child: Text(_catEmoji(ad.categorySlug), style: const TextStyle(fontSize: 26)))))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ad.title, style: (isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium).copyWith(fontWeight: FontWeight.w600),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(ad.isFree ? (isArabic ? 'مجاني' : 'Free') : '${ad.price!.toInt()} ر.س',
                style: AppTextStyles.priceMedium.copyWith(color: ad.isFree ? AppColors.success : AppColors.metallicGold)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.3))),
              child: Text(myAd.statusLabelAr(), style: AppTextStyles.badgeMedium.copyWith(color: color))),
            if (myAd.status == 'ACTIVE' && myAd.daysLeft > 0) ...[
              const SizedBox(height: 4),
              Text(isArabic ? 'متبقي ${myAd.daysLeft} يوم' : '${myAd.daysLeft} days left',
                  style: AppTextStyles.caption.copyWith(color: myAd.daysLeft <= 5 ? AppColors.warning : AppColors.textMuted)),
            ],
          ]),
        ])),

        // Stats row
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), color: AppColors.bgCard2,
          child: Row(children: [
            _StatChip(Icons.visibility_outlined, '${ad.viewCount}', isArabic ? 'مشاهدة' : 'views'),
            const SizedBox(width: 16),
            _StatChip(Icons.favorite_border_rounded, '${ad.favoriteCount}', isArabic ? 'مفضلة' : 'saved'),
            const SizedBox(width: 16),
            _StatChip(Icons.location_on_outlined, ad.city, ''),
            const Spacer(),
            if (myAd.canBoost && myAd.status == 'ACTIVE')
              GestureDetector(onTap: onBoost, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(8)),
                child: Text(isArabic ? '⭐ تمييز' : '⭐ Boost', style: AppTextStyles.badge.copyWith(color: AppColors.bgPrimary)))),
          ])),

        // Actions
        Container(decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderSubtle))),
          child: Row(children: [
            // Edit
            if (myAd.status != 'SOLD' && myAd.status != 'EXPIRED')
              _ActionBtn(Icons.edit_outlined, isArabic ? 'تعديل' : 'Edit', AppColors.royalBlue, onEdit),

            // Toggle pause/resume
            if (myAd.status == 'ACTIVE' || myAd.status == 'PAUSED') ...[
              _ADivider(),
              _ActionBtn(
                myAd.status == 'ACTIVE' ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                myAd.status == 'ACTIVE' ? (isArabic ? 'إيقاف' : 'Pause') : (isArabic ? 'تفعيل' : 'Resume'),
                myAd.status == 'ACTIVE' ? AppColors.warning : AppColors.success, onToggle),
            ],

            // Delete
            _ADivider(),
            _ActionBtn(Icons.delete_outline_rounded, isArabic ? 'حذف' : 'Delete', AppColors.error, onDelete),
          ])),
      ]),
    );
  }

  String _catEmoji(String slug) => switch (slug) {
    'electronics' => '📱', 'vehicles' => '🚗', 'realestate' => '🏠',
    'furniture' => '🛋️', 'fashion' => '👗', 'sports' => '⚽', _ => '📦',
  };
}

class _StatChip extends StatelessWidget {
  final IconData icon; final String value, label;
  const _StatChip(this.icon, this.value, this.label);
  @override Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 11, color: AppColors.textMuted),
    const SizedBox(width: 3),
    Text('$value${label.isNotEmpty ? " $label" : ""}', style: AppTextStyles.caption),
  ]);
}

class _ActionBtn extends StatelessWidget {
  final IconData ic; final String label; final Color color; final VoidCallback onTap;
  const _ActionBtn(this.ic, this.label, this.color, this.onTap);
  @override Widget build(BuildContext context) => Expanded(child: TextButton.icon(
    onPressed: () { HapticFeedback.lightImpact(); onTap(); },
    icon:  Icon(ic, size: 14, color: color),
    label: Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
  ));
}

class _ADivider extends StatelessWidget {
  @override Widget build(BuildContext context) => Container(width: 1, height: 32, color: AppColors.borderSubtle);
}

// ── Boost Bottom Sheet ────────────────────────────────────────
class _BoostSheet extends StatefulWidget {
  final MyAdModel myAd;
  final bool      isArabic;
  const _BoostSheet({required this.myAd, required this.isArabic});
  @override State<_BoostSheet> createState() => _BSState();
}

class _BSState extends State<_BoostSheet> {
  int    _selected = 1; // 0=7d, 1=14d, 2=30d
  bool   _loading  = false;

  final _plans = [
    (7,  25,  '3× مشاهدات أكثر',  '3× More Views'),
    (14, 45,  '5× مشاهدات أكثر',  '5× More Views'),
    (30, 75,  '10× مشاهدات أكثر', '10× More Views'),
  ];

  @override
  Widget build(BuildContext context) {
    final ar = widget.isArabic;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderDefault, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Row(children: [
            const Text('⭐', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(ar ? 'تمييز إعلانك' : 'Boost Your Ad', style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
          ]),
          const SizedBox(height: 6),
          Text(ar ? 'احصل على مزيد من المشاهدات والاستفسارات' : 'Get more views and inquiries',
              style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          // Plans
          ..._plans.asMap().entries.map((e) => GestureDetector(
            onTap: () => setState(() => _selected = e.key),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: _selected == e.key ? AppGradients.goldPremium : null,
                color: _selected == e.key ? null : AppColors.bgCard,
                borderRadius: AppBorderRadius.sm,
                border: Border.all(color: _selected == e.key ? Colors.transparent : AppColors.borderSubtle)),
              child: Row(children: [
                AnimatedContainer(duration: const Duration(milliseconds: 200), width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle,
                  color: _selected == e.key ? AppColors.bgPrimary.withOpacity(0.3) : Colors.transparent,
                  border: Border.all(color: _selected == e.key ? AppColors.bgPrimary : AppColors.borderDefault, width: _selected == e.key ? 2 : 1.5)),
                  child: _selected == e.key ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${e.value.$1} ${ar ? "يوم" : "days"}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _selected == e.key ? AppColors.bgPrimary : AppColors.textPrimary)),
                  Text(ar ? e.value.$3 : e.value.$4, style: TextStyle(fontSize: 11, color: _selected == e.key ? AppColors.bgPrimary.withOpacity(0.7) : AppColors.textSecondary)),
                ])),
                Text('${e.value.$2} ${ar ? "ر.س" : "SAR"}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _selected == e.key ? AppColors.bgPrimary : AppColors.metallicGold)),
              ])),
          )),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _loading ? null : () async {
              setState(() => _loading = true);
              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) Navigator.pop(context);
            },
            child: Container(height: 50, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: AppBorderRadius.button,
                boxShadow: [BoxShadow(color: AppColors.metallicGold.withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 4))]),
              child: Center(child: _loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                : Text('${ar ? "تمييز الآن •" : "Boost Now •"} ${_plans[_selected].$2} ${ar ? "ر.س" : "SAR"}',
                    style: (ar ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium).copyWith(color: AppColors.bgPrimary)))),
          ),
        ]),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────
class _EmptyAds extends StatelessWidget {
  final bool isArabic;
  const _EmptyAds({required this.isArabic});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.campaign_outlined, size: 64, color: AppColors.textMuted),
    const SizedBox(height: 16),
    Text(isArabic ? 'لا توجد إعلانات' : 'No Ads Yet', style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
    const SizedBox(height: 8),
    Text(isArabic ? 'انشر أول إعلان لك مجاناً الآن!' : 'Post your first ad for free now!',
        style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary)),
    const SizedBox(height: 24),
    GestureDetector(onTap: () => context.push(AppRoutes.postAd), child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
      decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: AppBorderRadius.button,
          boxShadow: [BoxShadow(color: AppColors.metallicGold.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]),
      child: Text(isArabic ? 'نشر إعلان مجاني' : 'Post Free Ad',
          style: (isArabic ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium).copyWith(color: AppColors.bgPrimary)))),
  ]));
}

