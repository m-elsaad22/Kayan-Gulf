import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

class _ServiceNotif {
  const _ServiceNotif({
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.timeAr,
    required this.timeEn,
    required this.gradient,
    this.unread = false,
  });

  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String timeAr;
  final String timeEn;
  final LinearGradient gradient;
  final bool unread;
}

/// إشعارات الخدمات — light design
class ServiceNotificationsScreen extends ConsumerStatefulWidget {
  const ServiceNotificationsScreen({super.key});

  @override
  ConsumerState<ServiceNotificationsScreen> createState() => _ServiceNotificationsScreenState();
}

class _ServiceNotificationsScreenState extends ConsumerState<ServiceNotificationsScreen> {
  late List<_ServiceNotif> _items = const [
    _ServiceNotif(
      icon: Icons.home_repair_service_outlined,
      titleAr: 'تم تأكيد الحجز',
      titleEn: 'Booking confirmed',
      bodyAr: 'تنظيف منزلي — الأحد 10 صباحاً',
      bodyEn: 'Home cleaning — Sunday 10 AM',
      timeAr: '15 د',
      timeEn: '15m ago',
      gradient: KayanDesignTokens.gradGreen,
      unread: true,
    ),
    _ServiceNotif(
      icon: Icons.engineering_outlined,
      titleAr: 'الفني في الطريق',
      titleEn: 'Technician on the way',
      bodyAr: 'أحمد — الوصول خلال 20 دقيقة',
      bodyEn: 'Ahmed — ETA 20 min',
      timeAr: '1 س',
      timeEn: '1h ago',
      gradient: KayanDesignTokens.gradOrange,
      unread: true,
    ),
    _ServiceNotif(
      icon: Icons.check_circle_outline_rounded,
      titleAr: 'اكتملت الخدمة',
      titleEn: 'Service completed',
      bodyAr: 'صيانة مكيف — يمكنك التقييم الآن',
      bodyEn: 'AC maintenance — rate your experience',
      timeAr: 'أمس',
      timeEn: 'Yesterday',
      gradient: KayanDesignTokens.gradBlue,
    ),
    _ServiceNotif(
      icon: Icons.local_offer_outlined,
      titleAr: 'عرض خدمات',
      titleEn: 'Service offer',
      bodyAr: 'خصم 15% على التنظيف العميق',
      bodyEn: '15% off deep cleaning',
      timeAr: '2 يوم',
      timeEn: '2d ago',
      gradient: KayanDesignTokens.gradGold,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: KayanLightTopBar(
                title: ar ? 'إشعارات الخدمات' : 'Service notifications',
                onBack: () => context.pop(),
                trailing: TextButton(
                  onPressed: () => setState(() {
                    _items = _items.map((n) => _ServiceNotif(
                      icon: n.icon,
                      titleAr: n.titleAr,
                      titleEn: n.titleEn,
                      bodyAr: n.bodyAr,
                      bodyEn: n.bodyEn,
                      timeAr: n.timeAr,
                      timeEn: n.timeEn,
                      gradient: n.gradient,
                    )).toList();
                  }),
                  child: Text(
                    ar ? 'قراءة الكل' : 'Mark all read',
                    style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                itemCount: _items.length,
                itemBuilder: (context, i) {
                  final n = _items[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: n.unread ? KayanDesignTokens.surface : Colors.white,
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        border: Border.all(color: n.unread ? KayanDesignTokens.kBlue.withValues(alpha: 0.25) : KayanDesignTokens.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(gradient: n.gradient, borderRadius: BorderRadius.circular(12)),
                            child: Icon(n.icon, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        ar ? n.titleAr : n.titleEn,
                                        style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep),
                                      ),
                                    ),
                                    Text(ar ? n.timeAr : n.timeEn, style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(ar ? n.bodyAr : n.bodyEn, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.text2)),
                              ],
                            ),
                          ),
                          if (n.unread)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 6),
                              decoration: const BoxDecoration(color: KayanDesignTokens.kBlue, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
