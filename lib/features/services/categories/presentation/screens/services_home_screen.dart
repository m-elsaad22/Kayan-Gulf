// Services home — matches design/html/24-hs-dashboard.html
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

const _homeCategories = [
  (Icons.cleaning_services_rounded, 'تنظيف', 'Cleaning'),
  (Icons.ac_unit_rounded, 'تكييف', 'AC'),
  (Icons.bolt_rounded, 'كهرباء', 'Electric'),
  (Icons.plumbing_rounded, 'سباكة', 'Plumbing'),
  (Icons.pest_control_rounded, 'حشرات', 'Pests'),
  (Icons.shield_rounded, 'أمن', 'Security'),
];

const _popularServices = [
  ('صيانة وتنظيف تكييف', 'AC service & clean', Icons.ac_unit_rounded, 4.8, '2.1K', '60 د', '60 min', '120'),
  ('تسليك مجاري', 'Drain unclog', Icons.plumbing_rounded, 4.7, '980', '45 د', '45 min', '80'),
  ('تنظيف شامل', 'Deep cleaning', Icons.cleaning_services_rounded, 4.9, '1.5K', '3 س', '3 hrs', '200'),
  ('تركيب أثاث', 'Furniture assembly', Icons.handyman_rounded, 4.6, '640', '90 د', '90 min', '150'),
];

class ServicesHomeScreen extends ConsumerWidget {
  const ServicesHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'الخدمات المنزلية' : 'Home Services',
            variant: KayanSectionHeroVariant.green,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.go(AppRoutes.home),
            ),
            trailing: KayanHeroIconButton(
              icon: Icons.notifications_none_rounded,
              onTap: () => context.push(AppRoutes.notifications),
            ),
            searchHint: ar ? 'ابحث عن خدمة...' : 'Search for a service...',
            onSearchTap: () => context.push('${AppRoutes.services}/browse'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 100),
              children: [
                KayanOfferBanner(
                  title: ar ? 'خصم 30% على أول حجز' : '30% off your first booking',
                  subtitle: ar ? 'على جميع الخدمات المنزلية هذا الأسبوع' : 'On all home services this week',
                  gradient: KayanDesignTokens.gradGreen,
                ),
                KayanCategoryPillRow(
                  isArabic: ar,
                  iconGradient: KayanDesignTokens.gradGreen,
                  items: _homeCategories
                      .map((c) => KayanCategoryPill(icon: c.$1, labelAr: c.$2, labelEn: c.$3))
                      .toList(),
                ),
                const SizedBox(height: 24),
                KayanSectionHeader(
                  title: ar ? 'الأكثر طلباً' : 'Most popular',
                  action: ar ? 'عرض الكل' : 'See all',
                  actionColor: KayanDesignTokens.kGreen,
                  onAction: () => context.push('${AppRoutes.services}/browse'),
                ),
                const SizedBox(height: 14),
                ...List.generate(_popularServices.length, (i) {
                  final s = _popularServices[i];
                  return KayanServiceCard(
                    name: ar ? s.$1 : s.$2,
                    rating: s.$4,
                    reviews: s.$5,
                    duration: ar ? s.$6 : s.$7,
                    priceLabel: '${s.$8} ${ar ? 'ر.س' : 'SAR'}',
                    icon: s.$3,
                    onTap: () => context.push(AppRoutes.servicePath('service-$i')),
                    onAdd: () => context.push(AppRoutes.serviceBookPath('service-$i')),
                  );
                }),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    context.push(AppRoutes.urgentService);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFC62828), Color(0xFFE53935)]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: KayanDesignTokens.shadowM,
                    ),
                    child: Row(
                      children: [
                        const Text('🚨', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ar ? 'خدمة طوارئ ٢٤/٧' : '24/7 Emergency',
                                style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              Text(
                                ar ? 'فنيون يصلون خلال 30-60 دقيقة' : 'Technicians in 30-60 minutes',
                                style: KayanDesignTokens.cairo(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(ar ? 'اطلب' : 'Call', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.myBookings),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: KayanDesignTokens.gradBlue,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: KayanDesignTokens.shadowS,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ar ? 'حجوزاتي' : 'My bookings', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: Colors.white)),
                              Text(
                                ar ? 'لديك حجز غداً الساعة 9 صباحاً' : 'You have a booking tomorrow at 9 AM',
                                style: KayanDesignTokens.cairo(fontSize: 12, color: Colors.white70),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
