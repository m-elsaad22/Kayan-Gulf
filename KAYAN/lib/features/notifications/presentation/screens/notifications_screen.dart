// ============================================================
// KAYAN — Notifications Screen
// lib/features/notifications/presentation/screens/notifications_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/providers/locale_provider.dart';

// ── Notification Model ────────────────────────────────────────
enum NotifType { order, service, promo, chat, system }

class _Notif {
  final String   id, titleAr, titleEn, bodyAr, bodyEn, icon;
  final NotifType type;
  bool           isRead;
  final DateTime  date;
  final String?  actionRoute;

  _Notif({required this.id, required this.titleAr, required this.titleEn,
    required this.bodyAr, required this.bodyEn, required this.icon,
    required this.type, this.isRead = false, required this.date, this.actionRoute});
}

Color _notifColor(NotifType t) => switch (t) {
  NotifType.order   => AppColors.royalBlue,
  NotifType.service => AppColors.categoryTeal,
  NotifType.promo   => AppColors.metallicGold,
  NotifType.chat    => AppColors.categoryGreen,
  NotifType.system  => AppColors.textSecondary,
};

final _now = DateTime.now();

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});
  @override ConsumerState<NotificationsScreen> createState() => _NSState();
}

class _NSState extends ConsumerState<NotificationsScreen> {
  late List<_Notif> _notifs = [
    _Notif(id:'n1', titleAr:'تم شحن طلبك', titleEn:'Your Order Shipped',
        bodyAr:'طلبك KYN-8472936 في الطريق إليك! التوصيل خلال 1-2 يوم.',
        bodyEn:'Your order KYN-8472936 is on the way! Delivery in 1-2 days.',
        icon:'📦', type:NotifType.order, isRead:false, date:_now.subtract(const Duration(minutes:10))),
    _Notif(id:'n2', titleAr:'الفني في الطريق 🛠️', titleEn:'Technician On The Way',
        bodyAr:'محمد الغامدي في طريقه إليك. الوصول المتوقع: 25 دقيقة.',
        bodyEn:'Mohammed Al-Ghamdi is heading your way. ETA: 25 minutes.',
        icon:'🔧', type:NotifType.service, isRead:false, date:_now.subtract(const Duration(hours:1))),
    _Notif(id:'n3', titleAr:'عرض خاص لك! ⚡', titleEn:'Special Offer Just For You!',
        bodyAr:'خصم 20% على جميع خدمات التنظيف اليوم فقط. استخدم كود: CLEAN20',
        bodyEn:'20% off all cleaning services today only. Use code: CLEAN20',
        icon:'🎁', type:NotifType.promo, isRead:false, date:_now.subtract(const Duration(hours:3))),
    _Notif(id:'n4', titleAr:'رسالة جديدة', titleEn:'New Message',
        bodyAr:'أحمد محمد: هل السعر قابل للتفاوض؟',
        bodyEn:'Ahmed Mohammed: Is the price negotiable?',
        icon:'💬', type:NotifType.chat, isRead:false, date:_now.subtract(const Duration(hours:5))),
    _Notif(id:'n5', titleAr:'تم تأكيد طلبك ✓', titleEn:'Order Confirmed ✓',
        bodyAr:'تم تأكيد طلبك بنجاح. رقم الطلب: KYN-7361825',
        bodyEn:'Your order has been confirmed. Order: KYN-7361825',
        icon:'✅', type:NotifType.order, isRead:true, date:_now.subtract(const Duration(days:1))),
    _Notif(id:'n6', titleAr:'اكسب نقاط مضاعفة! 🌟', titleEn:'Double Points Weekend!',
        bodyAr:'هذا الأسبوع فقط: نقاط ولاء مضاعفة على جميع مشترياتك.',
        bodyEn:'This weekend only: Double loyalty points on all purchases.',
        icon:'⭐', type:NotifType.promo, isRead:true, date:_now.subtract(const Duration(days:2))),
    _Notif(id:'n7', titleAr:'تحديث التطبيق متاح', titleEn:'App Update Available',
        bodyAr:'الإصدار الجديد 1.2.0 متاح للتنزيل. ميزات جديدة رائعة!',
        bodyEn:'Version 1.2.0 is available. Exciting new features!',
        icon:'🔄', type:NotifType.system, isRead:true, date:_now.subtract(const Duration(days:3))),
  ];

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() { for (final n in _notifs) n.isRead = true; });
  }

  void _markRead(String id) {
    setState(() { _notifs.firstWhere((n) => n.id == id).isRead = true; });
  }

  void _delete(String id) {
    setState(() => _notifs = _notifs.where((n) => n.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);

    // Group by date
    final today     = _notifs.where((n) => _isToday(n.date)).toList();
    final yesterday = _notifs.where((n) => _isYesterday(n.date)).toList();
    final older     = _notifs.where((n) => !_isToday(n.date) && !_isYesterday(n.date)).toList();

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(isArabic ? 'الإشعارات' : 'Notifications',
              style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
          if (_unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppColors.royalBlue, borderRadius: BorderRadius.circular(10)),
              child: Text('$_unreadCount', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
          ],
        ]),
        leading: IconButton(
          icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop()),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(isArabic ? 'قراءة الكل' : 'Mark All Read',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.royalBlue))),
        ],
      ),

      body: _notifs.isEmpty
          ? _EmptyNotifs(isArabic: isArabic)
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (today.isNotEmpty)     ...[_GroupHeader(isArabic ? 'اليوم'   : 'Today',     isArabic), ...today.map((n) => _NotifTile(notif:n, isArabic:isArabic, onTap:() => _markRead(n.id), onDelete:() => _delete(n.id)))],
                if (yesterday.isNotEmpty) ...[_GroupHeader(isArabic ? 'أمس'     : 'Yesterday', isArabic), ...yesterday.map((n) => _NotifTile(notif:n, isArabic:isArabic, onTap:() => _markRead(n.id), onDelete:() => _delete(n.id)))],
                if (older.isNotEmpty)     ...[_GroupHeader(isArabic ? 'قديمة'   : 'Older',     isArabic), ...older.map((n) => _NotifTile(notif:n, isArabic:isArabic, onTap:() => _markRead(n.id), onDelete:() => _delete(n.id)))],
              ],
            ),
    );
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool _isYesterday(DateTime d) {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return d.year == y.year && d.month == y.month && d.day == y.day;
  }
}

class _GroupHeader extends StatelessWidget {
  final String label;
  final bool   isArabic;
  const _GroupHeader(this.label, this.isArabic);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
    child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, letterSpacing: 0.5)),
  );
}

class _NotifTile extends StatelessWidget {
  final _Notif       notif;
  final bool         isArabic;
  final VoidCallback onTap, onDelete;
  const _NotifTile({required this.notif, required this.isArabic, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = _notifColor(notif.type);
    return Dismissible(
      key:       ValueKey(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) { HapticFeedback.mediumImpact(); onDelete(); },
      background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), color: AppColors.error,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.delete_rounded, color: Colors.white, size: 22),
          Text(isArabic ? 'حذف' : 'Delete', style: const TextStyle(color: Colors.white, fontSize: 10)),
        ])),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: notif.isRead ? Colors.transparent : AppColors.royalBlue.withOpacity(0.04),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Icon
            Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(notif.icon, style: const TextStyle(fontSize: 20)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(isArabic ? notif.titleAr : notif.titleEn,
                    style: AppTextStyles.bodySmall.copyWith(fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700))),
                const SizedBox(width: 8),
                Text(_timeAgo(notif.date, isArabic), style: AppTextStyles.caption.copyWith(fontSize: 9)),
              ]),
              const SizedBox(height: 3),
              Text(isArabic ? notif.bodyAr : notif.bodyEn,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
            const SizedBox(width: 8),
            // Unread dot
            if (!notif.isRead)
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.royalBlue, shape: BoxShape.circle)),
          ]),
        ),
      ),
    );
  }

  String _timeAgo(DateTime d, bool ar) {
    final diff = DateTime.now().difference(d);
    if (ar) {
      if (diff.inMinutes < 60) return '${diff.inMinutes}د';
      if (diff.inHours < 24)   return '${diff.inHours}س';
      return '${diff.inDays}ي';
    }
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24)   return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class _EmptyNotifs extends StatelessWidget {
  final bool isArabic;
  const _EmptyNotifs({required this.isArabic});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textMuted),
    const SizedBox(height: 16),
    Text(isArabic ? 'لا توجد إشعارات' : 'No Notifications',
        style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
    const SizedBox(height: 8),
    Text(isArabic ? 'ستظهر هنا إشعاراتك عند وصولها' : 'Your notifications will appear here',
        style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary)),
  ]));
}
