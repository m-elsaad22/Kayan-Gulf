// KAYAN — Service Detail Screen
// lib/features/services/browse/presentation/screens/service_detail_screen.dart

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
import '../../data/models/service_models.dart';

final _svcDetailProv = FutureProvider.autoDispose
    .family<ServiceDetailModel, String>((ref, slug) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return mockServiceDetail(slug);
});

class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String slug;
  const ServiceDetailScreen({super.key, required this.slug});
  @override
  ConsumerState<ServiceDetailScreen> createState() => _SDS();
}

class _SDS extends ConsumerState<ServiceDetailScreen> {
  final _galCtrl   = PageController();
  int  _galIdx     = 0;
  bool _descExp    = false;
  int  _faqOpen    = -1;

  @override
  void dispose() { _galCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ar  = ref.watch(isArabicProvider);
    final svc = ref.watch(_svcDetailProv(widget.slug));

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: svc.when(
        loading: () => const _Skel(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (s) => Stack(children: [
          CustomScrollView(slivers: [
            // Gallery SliverAppBar
            SliverAppBar(
              expandedHeight: 280, pinned: true,
              backgroundColor: AppColors.bgScaffold,
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: Container(margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.bgCard.withOpacity(0.9), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary))),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(children: [
                  PageView.builder(controller: _galCtrl, onPageChanged: (i) => setState(() => _galIdx = i),
                    itemCount: s.galleryUrls.isNotEmpty ? s.galleryUrls.length : 1,
                    itemBuilder: (_, i) {
                      final url = s.galleryUrls.isNotEmpty ? s.galleryUrls[i] : s.imageUrl;
                      return url != null
                          ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
                              placeholder: (_, __) => Container(color: AppColors.bgCard2),
                              errorWidget: (_, __, ___) => Container(color: AppColors.bgCard2,
                                  child: const Icon(Icons.build_outlined, size: 48, color: AppColors.textMuted)))
                          : Container(color: AppColors.bgCard2, child: const Icon(Icons.build_outlined, size: 64, color: AppColors.textMuted));
                    }),
                  const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.imageOverlayBottom))),
                  if (s.galleryUrls.length > 1)
                    Positioned(bottom: 12, left: 0, right: 0,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(s.galleryUrls.length, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _galIdx ? 16 : 6, height: 6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
                              color: i == _galIdx ? AppColors.metallicGold : Colors.white.withOpacity(0.5)))))),
                ]),
              ),
            ),

            SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header info
              Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Category + badges
                Wrap(spacing: 8, children: [
                  if (s.categoryNameAr != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.royalBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                    child: Text(ar ? s.categoryNameAr! : (s.categorySlug ?? ''), style: AppTextStyles.labelSmall.copyWith(color: AppColors.royalBlue))),
                  if (s.isEmergency) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.borderError)),
                    child: Text('🚨 ${ar ? "طارئ" : "Emergency"}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.error))),
                  if (s.hasDiscount) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                    child: Text('-${(((s.basePrice - s.finalPrice) / s.basePrice) * 100).toInt()}%', style: AppTextStyles.badgeMedium)),
                ]),
                const SizedBox(height: 10),
                Text(ar ? s.nameAr : s.nameEn, style: ar ? AppTextStyles.arabicHeadlineMedium.copyWith(fontSize: 18) : AppTextStyles.headlineSmall),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 14, color: AppColors.starFilled),
                  Text(' ${s.rating.toStringAsFixed(1)}', style: AppTextStyles.rating),
                  Text(' (${s.totalRatings} ${ar ? "تقييم" : "reviews"})', style: AppTextStyles.caption),
                  const SizedBox(width: 12),
                  const Icon(Icons.check_circle_outline_rounded, size: 13, color: AppColors.success),
                  Text(' ${s.totalBookings} ${ar ? "حجز" : "jobs"}', style: AppTextStyles.caption),
                ]),
                const SizedBox(height: 14),
                const Divider(color: AppColors.borderSubtle),
                const SizedBox(height: 14),
                // Price
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (s.hasDiscount) Text('${s.basePrice.toInt()} ر.س', style: AppTextStyles.priceOriginalMedium),
                    Text('${s.finalPrice.toInt()} ر.س', style: AppTextStyles.priceXLarge),
                    Text(s.pricingType == 'HOURLY' ? (ar ? 'في الساعة' : 'per hour') : (ar ? 'سعر ثابت' : 'fixed price'), style: AppTextStyles.caption),
                  ]),
                ]),
                const SizedBox(height: 16),
                // Info strip
                Container(padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.sm, border: Border.all(color: AppColors.borderSubtle)),
                  child: Row(children: [
                    _IC(Icons.schedule_rounded, AppColors.royalBlue, ar ? 'المدة' : 'Duration', '${s.estimatedDurationMin ~/ 60} ${ar ? "ساعة" : "hrs"}'),
                    _IC(Icons.verified_rounded, AppColors.success, ar ? 'الحالة' : 'Status', s.isAvailable ? (ar ? 'متاح' : 'Available') : (ar ? 'مشغول' : 'Busy')),
                    _IC(Icons.location_on_rounded, AppColors.metallicGold, ar ? 'التغطية' : 'Coverage', ar ? 'الرياض، جدة' : 'Riyadh, Jeddah'),
                  ])),
              ])),

              const SizedBox(height: 20),

              // Features
              if (s.features.isNotEmpty) ...[
                _SecHead(ar ? 'مميزات الخدمة' : 'Service Features', ar),
                Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3.5, crossAxisSpacing: 10, mainAxisSpacing: 8,
                    children: s.features.map((f) => Row(children: [
                      Text(f.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Expanded(child: Text(ar ? f.textAr : f.textEn,
                          style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary), maxLines: 2)),
                    ])).toList())),
                const SizedBox(height: 20),
              ],

              // Description
              if (s.descriptionAr != null) ...[
                _SecHead(ar ? 'وصف الخدمة' : 'Description', ar),
                Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  AnimatedSize(duration: const Duration(milliseconds: 250), curve: Curves.easeOut,
                    child: Text(ar ? (s.descriptionAr ?? '') : (s.descriptionEn ?? ''),
                        maxLines: _descExp ? null : 3, overflow: _descExp ? null : TextOverflow.fade,
                        style: (ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium).copyWith(color: AppColors.textSecondary, height: 1.6))),
                  const SizedBox(height: 6),
                  GestureDetector(onTap: () => setState(() => _descExp = !_descExp),
                    child: Text(_descExp ? (ar ? 'عرض أقل' : 'Show less') : (ar ? 'عرض المزيد' : 'Show more'), style: AppTextStyles.seeAll)),
                ])),
                const SizedBox(height: 20),
              ],

              // What to expect
              if (s.whatToExpect.isNotEmpty) ...[
                _SecHead(ar ? 'ماذا تتوقع؟' : 'What to Expect', ar),
                Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 0), child: Column(children: List.generate(s.whatToExpect.length, (i) =>
                  Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 22, height: 22, decoration: BoxDecoration(gradient: AppGradients.primaryButton, shape: BoxShape.circle),
                        child: Center(child: Text('${i + 1}', style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s.whatToExpect[i],
                        style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary, height: 1.5))),
                  ]))))),
                const SizedBox(height: 20),
              ],

              // Technicians
              if (s.technicians.isNotEmpty) ...[
                _SecHead(ar ? 'فنيونا' : 'Our Technicians', ar),
                const SizedBox(height: 10),
                SizedBox(height: 120, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: s.technicians.map((t) => Container(width: 130, margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.md, border: Border.all(color: AppColors.borderSubtle)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Container(width: 36, height: 36, decoration: BoxDecoration(gradient: AppGradients.primaryButton, shape: BoxShape.circle),
                            child: Center(child: Text(t.name[0], style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)))),
                        const SizedBox(width: 6),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          if (t.isVerified) Row(children: [const Icon(Icons.verified_rounded, size: 11, color: AppColors.royalBlue), Text(' ${ar ? "معتمد" : "Verified"}', style: AppTextStyles.caption.copyWith(color: AppColors.royalBlue))]),
                          Row(children: [const Icon(Icons.star_rounded, size: 10, color: AppColors.starFilled), Text(' ${t.rating}', style: AppTextStyles.caption)]),
                        ]),
                      ]),
                      const SizedBox(height: 6),
                      Text(t.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600), maxLines: 1),
                      Text('${t.completedJobs} ${ar ? "حجز" : "jobs"}', style: AppTextStyles.caption),
                    ]))).toList())),
                const SizedBox(height: 20),
              ],

              // Reviews
              if (s.reviews.isNotEmpty) ...[
                _SecHead(ar ? 'التقييمات' : 'Reviews', ar),
                ...s.reviews.take(3).map((r) => Container(margin: const EdgeInsets.fromLTRB(16, 6, 16, 0), padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.sm, border: Border.all(color: AppColors.borderSubtle)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.bgCard2, shape: BoxShape.circle),
                          child: Center(child: Text((r.userName ?? '?')[0], style: AppTextStyles.titleSmall.copyWith(color: AppColors.royalBlue)))),
                      const SizedBox(width: 8),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [Text(r.userName ?? '', style: AppTextStyles.titleSmall), if (r.isVerified) ...[const SizedBox(width: 4), const Icon(Icons.verified_rounded, size: 12, color: AppColors.success)]]),
                        Row(children: List.generate(5, (i) => Icon(i < r.rating ? Icons.star_rounded : Icons.star_border_rounded, size: 11, color: AppColors.starFilled))),
                      ])),
                      Text(r.timeAgo(ar), style: AppTextStyles.caption),
                    ]),
                    if (r.comment != null) ...[const SizedBox(height: 6), Text(r.comment!, style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary, height: 1.5))],
                  ]))),
                const SizedBox(height: 8),
                Center(child: TextButton(onPressed: () {}, child: Text(ar ? 'عرض كل التقييمات' : 'See all reviews', style: AppTextStyles.seeAll))),
                const SizedBox(height: 16),
              ],

              // FAQs
              if (s.faqs.isNotEmpty) ...[
                _SecHead(ar ? 'أسئلة شائعة' : 'FAQ', ar),
                Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: Column(children: List.generate(s.faqs.length, (i) {
                  final faq = s.faqs[i];
                  final open = _faqOpen == i;
                  return GestureDetector(onTap: () => setState(() => _faqOpen = open ? -1 : i),
                    child: Container(margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.sm, border: Border.all(color: open ? AppColors.borderActive : AppColors.borderSubtle)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(padding: const EdgeInsets.all(12), child: Row(children: [
                          Expanded(child: Text(ar ? faq.questionAr : faq.questionEn, style: (ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall).copyWith(color: open ? AppColors.royalBlue : AppColors.textPrimary))),
                          Icon(open ? Icons.remove_rounded : Icons.add_rounded, size: 16, color: AppColors.textMuted),
                        ])),
                        if (open) Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), child: Text(ar ? faq.answerAr : faq.answerEn, style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary, height: 1.5))),
                      ]));
                }))),
              ],
              const SizedBox(height: 100),
            ])),
          ]),

          // Book Now sticky bar
          Positioned(bottom: 0, left: 0, right: 0, child: Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.paddingOf(context).bottom + 12),
            decoration: BoxDecoration(color: AppColors.bgSurface, border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, -4))]),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ar ? 'يبدأ من' : 'From', style: AppTextStyles.caption),
                Text('${s.finalPrice.toInt()} ر.س', style: AppTextStyles.priceLarge),
              ]),
              const SizedBox(width: 12),
              Expanded(child: GestureDetector(
                onTap: () { HapticFeedback.mediumImpact(); context.push(AppRoutes.serviceBookPath(s.slug)); },
                child: Container(height: 52, decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: AppBorderRadius.button,
                    boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]),
                    child: Center(child: Text(ar ? 'احجز الآن' : 'Book Now', style: ar ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium))))),
              const SizedBox(width: 10),
              Container(width: 52, height: 52, decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: AppBorderRadius.button, border: Border.all(color: AppColors.borderError)),
                  child: const Icon(Icons.phone_rounded, color: AppColors.error, size: 22)),
            ])),
          ),
        ]),
      ),
    );
  }
}

Widget _IC(IconData ic, Color c, String l, String v) => Expanded(child: Column(children: [Icon(ic, size: 18, color: c), const SizedBox(height: 4), Text(l, style: AppTextStyles.caption, textAlign: TextAlign.center), Text(v, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis)]));

Widget _SecHead(String t, bool ar) => Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding), child: Row(children: [Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(t, style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium)]));

class _Skel extends StatelessWidget {
  const _Skel();
  @override
  Widget build(BuildContext context) => Column(children: [const ShimmerBox(width: double.infinity, height: 280, borderRadius: BorderRadius.zero), Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const ShimmerBox(width: double.infinity, height: 18), const SizedBox(height: 8), const ShimmerBox(width: 180, height: 14), const SizedBox(height: 16), const ShimmerBox(width: 120, height: 28), const SizedBox(height: 16), const ShimmerBox(width: double.infinity, height: 70)]))]);
}
