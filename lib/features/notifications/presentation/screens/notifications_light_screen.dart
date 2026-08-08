// Home notifications hub — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

class NotificationsLightScreen extends ConsumerStatefulWidget {
  const NotificationsLightScreen({super.key});

  @override
  ConsumerState<NotificationsLightScreen> createState() => _NotificationsLightScreenState();
}

class _NotifItem {
  const _NotifItem({
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

class _NotificationsLightScreenState extends ConsumerState<NotificationsLightScreen> {
  late List<_NotifItem> _items = const [
    _NotifItem(
      icon: Icons.local_shipping_outlined,
      titleAr: 'تم شحن طلبك',
      titleEn: 'Order shipped',
      bodyAr: 'طلبك KYN-8472936 في الطريق إليك',
      bodyEn: 'Order KYN-8472936 is on the way',
      timeAr: '10 د',
      timeEn: '10m ago',
      gradient: KayanDesignTokens.gradOrange,
      unread: true,
    ),
    _NotifItem(
      icon: Icons.home_repair_service_outlined,
      titleAr: 'الفني في الطريق',
      titleEn: 'Technician on the way',
      bodyAr: 'محمد الغامدي — الوصول خلال 25 دقيقة',
      bodyEn: 'Mohammed Al-Ghamdi — ETA 25 min',
      timeAr: '1 س',
      timeEn: '1h ago',
      gradient: KayanDesignTokens.gradGreen,
      unread: true,
    ),
    _NotifItem(
      icon: Icons.local_offer_outlined,
      titleAr: 'عرض خاص لك',
      titleEn: 'Special offer',
      bodyAr: 'خصم 20% على خدمات التنظيف — CLEAN20',
      bodyEn: '20% off cleaning — code CLEAN20',
      timeAr: '3 س',
      timeEn: '3h ago',
      gradient: KayanDesignTokens.gradGold,
      unread: true,
    ),
    _NotifItem(
      icon: Icons.chat_bubble_outline_rounded,
      titleAr: 'رسالة جديدة',
      titleEn: 'New message',
      bodyAr: 'أحمد محمد: هل السعر قابل للتفاوض؟',
      bodyEn: 'Ahmed: Is the price negotiable?',
      timeAr: '5 س',
      timeEn: '5h ago',
      gradient: KayanDesignTokens.gradBlue,
      unread: false,
    ),
    _NotifItem(
      icon: Icons.system_update_outlined,
      titleAr: 'تحديث التطبيق',
      titleEn: 'App update',
      bodyAr: 'الإصدار 1.2.0 متاح للتنزيل',
      bodyEn: 'Version 1.2.0 is available',
      timeAr: 'أمس',
      timeEn: 'Yesterday',
      gradient: LinearGradient(colors: [KayanDesignTokens.muted, KayanDesignTokens.text2]),
      unread: false,
    ),
  ];

  void _markAllRead() {
    setState(() {
      _items = _items.map((n) => _NotifItem(
        icon: n.icon,
        titleAr: n.titleAr,
        titleEn: n.titleEn,
        bodyAr: n.bodyAr,
        bodyEn: n.bodyEn,
        timeAr: n.timeAr,
        timeEn: n.timeEn,
        gradient: n.gradient,
        unread: false,
      )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final unread = _items.where((n) => n.unread).length;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'الإشعارات' : 'Notifications',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
            trailing: unread > 0
                ? KayanHeroIconButton(
                    icon: Icons.done_all_rounded,
                    onTap: _markAllRead,
                  )
                : null,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: _items.map((n) {
                return KayanNotificationItem(
                  icon: n.icon,
                  title: ar ? n.titleAr : n.titleEn,
                  body: ar ? n.bodyAr : n.bodyEn,
                  time: ar ? n.timeAr : n.timeEn,
                  iconGradient: n.gradient,
                  unread: n.unread,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
