// Service detail — light design
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../presentation/providers/service_providers.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  const ServiceDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  int _faqOpen = -1;
  bool _descExpanded = false;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final svc = ref.watch(serviceDetailProvider(widget.slug));

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: svc.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (s) => Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: s.imageUrl != null
                          ? CachedNetworkImage(imageUrl: s.imageUrl!, fit: BoxFit.cover)
                          : Container(
                              color: KayanDesignTokens.kGreen.withValues(alpha: 0.15),
                              child: const Icon(Icons.build_outlined, size: 64, color: KayanDesignTokens.kGreen),
                            ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (s.categoryNameAr != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: KayanDesignTokens.kBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ar ? s.categoryNameAr! : (s.categorySlug ?? ''),
                            style: KayanDesignTokens.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(ar ? s.nameAr : s.nameEn, style: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: KayanDesignTokens.oOrange),
                          Text(' ${s.rating.toStringAsFixed(1)} (${s.totalRatings})', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                          const SizedBox(width: 12),
                          const Icon(Icons.check_circle_outline_rounded, size: 14, color: KayanDesignTokens.kGreen),
                          Text(' ${s.totalBookings} ${ar ? 'حجز' : 'jobs'}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (s.hasDiscount)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: Text(
                                '${s.basePrice.toInt()} ${ar ? 'ر.س' : 'SAR'}',
                                style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.muted).copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          Text(
                            '${s.finalPrice.toInt()} ${ar ? 'ر.س' : 'SAR'}',
                            style: KayanDesignTokens.cairo(fontSize: 24, fontWeight: FontWeight.w900, color: KayanDesignTokens.kGreen),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                          border: Border.all(color: KayanDesignTokens.border),
                          boxShadow: KayanDesignTokens.shadowS,
                        ),
                        child: Row(
                          children: [
                            _InfoChip(Icons.schedule_rounded, ar ? 'المدة' : 'Duration', '${s.estimatedDurationMin ~/ 60} ${ar ? 'ساعة' : 'hrs'}'),
                            _InfoChip(Icons.verified_rounded, ar ? 'الحالة' : 'Status', s.isAvailable ? (ar ? 'متاح' : 'Available') : (ar ? 'مشغول' : 'Busy')),
                            _InfoChip(Icons.location_on_rounded, ar ? 'التغطية' : 'Coverage', ar ? 'الرياض' : 'Riyadh'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (s.features.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(ar ? 'مميزات الخدمة' : 'Features', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                  const SizedBox(height: 10),
                  ...s.features.map((f) => Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                        child: Row(
                          children: [
                            Text(f.icon, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ar ? f.textAr : f.textEn, style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2))),
                          ],
                        ),
                      )),
                ],
                if (s.descriptionAr != null) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(ar ? 'وصف الخدمة' : 'Description', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ar ? (s.descriptionAr ?? '') : (s.descriptionEn ?? ''),
                          maxLines: _descExpanded ? null : 3,
                          overflow: _descExpanded ? null : TextOverflow.fade,
                          style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.muted, height: 1.6),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _descExpanded = !_descExpanded),
                          child: Text(_descExpanded ? (ar ? 'عرض أقل' : 'Show less') : (ar ? 'عرض المزيد' : 'Show more')),
                        ),
                      ],
                    ),
                  ),
                ],
                if (s.faqs.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(ar ? 'أسئلة شائعة' : 'FAQ', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                  ...List.generate(s.faqs.length, (i) {
                    final faq = s.faqs[i];
                    final open = _faqOpen == i;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _faqOpen = open ? -1 : i),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            border: Border.all(color: open ? KayanDesignTokens.kGreen : KayanDesignTokens.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(ar ? faq.questionAr : faq.questionEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, fontSize: 13)),
                                  ),
                                  Icon(open ? Icons.remove_rounded : Icons.add_rounded, size: 18, color: KayanDesignTokens.muted),
                                ],
                              ),
                              if (open) ...[
                                const SizedBox(height: 8),
                                Text(ar ? faq.answerAr : faq.answerEn, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted, height: 1.5)),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.paddingOf(context).bottom + 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(top: BorderSide(color: KayanDesignTokens.border)),
                  boxShadow: KayanDesignTokens.shadowS,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ar ? 'يبدأ من' : 'From', style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted)),
                        Text('${s.finalPrice.toInt()} ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: KayanDesignTokens.kGreen)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KayanCtaButton(
                        label: ar ? 'احجز الآن' : 'Book now',
                        variant: KayanCtaVariant.green,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          context.push(AppRoutes.serviceBookPath(s.slug));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: KayanDesignTokens.kGreen),
          const SizedBox(height: 4),
          Text(label, style: KayanDesignTokens.cairo(fontSize: 10, color: KayanDesignTokens.muted)),
          Text(value, style: KayanDesignTokens.cairo(fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
