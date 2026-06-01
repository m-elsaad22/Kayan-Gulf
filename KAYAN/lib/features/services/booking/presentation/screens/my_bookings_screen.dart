// ============================================================
// KAYAN — My Bookings Screen
// lib/features/services/booking/presentation/screens/my_bookings_screen.dart
//
// Features:
//   • Tab bar: الكل / قادمة / جارية / مكتملة / ملغية
//   • Booking cards with status badge, tech avatar, quick actions
//   • Track button → live tracking screen
//   • Cancel booking dialog
//   • Review button for completed
//   • Pull-to-refresh
//   • Empty state with CTA
// ============================================================

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
import '../../../../services/browse/data/models/service_models.dart';

// ── Status helpers ────────────────────────────────────────────

Color _statusColor(String s) => switch (s) {
  'PENDING'     => AppColors.warning,
  'CONFIRMED'   => AppColors.royalBlue,
  'IN_PROGRESS' => AppColors.categoryTeal,
  'COMPLETED'   => AppColors.success,
  'CANCELLED'   => AppColors.error,
  _             => AppColors.textMuted,
};

IconData _statusIcon(String s) => switch (s) {
  'PENDING'     => Icons.access_time_rounded,
  'CONFIRMED'   => Icons.check_circle_outline_rounded,
  'IN_PROGRESS' => Icons.build_rounded,
  'COMPLETED'   => Icons.check_circle_rounded,
  'CANCELLED'   => Icons.cancel_rounded,
  _             => Icons.info_outline_rounded,
};

bool _canTrack(String s)  => s == 'CONFIRMED' || s == 'IN_PROGRESS';
bool _canCancel(String s) => s == 'PENDING'   || s == 'CONFIRMED';
bool _canReview(String s) => s == 'COMPLETED';

// ──────────────────────────────────────────────────────────────
// SCREEN
// ──────────────────────────────────────────────────────────────

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsState();
}

class _MyBookingsState extends ConsumerState<MyBookingsScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tab;

  // Filter sets for each tab
  final _filters = <Set<String>>[
    {},                         // All
    {'PENDING', 'CONFIRMED'},   // Upcoming
    {'IN_PROGRESS'},            // In Progress
    {'COMPLETED'},              // Completed
    {'CANCELLED'},              // Cancelled
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _filters.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<BookingModel> _filtered(Set<String> f) =>
      f.isEmpty ? mockBookings : mockBookings.where((b) => f.contains(b.status)).toList();

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor:  AppColors.bgSurface,
        centerTitle:      true,
        title: Text(
          ar ? 'حجوزاتي' : 'My Bookings',
          style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(
            ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
            onPressed: () => context.push(AppRoutes.services),
            tooltip: ar ? 'حجز جديد' : 'New Booking',
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
            Tab(text: ar ? 'الكل'     : 'All'),
            Tab(text: ar ? 'قادمة'    : 'Upcoming'),
            Tab(text: ar ? 'جارية'    : 'In Progress'),
            Tab(text: ar ? 'مكتملة'   : 'Completed'),
            Tab(text: ar ? 'ملغية'    : 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: _filters.map((f) {
          final list = _filtered(f);
          if (list.isEmpty) return _EmptyBookings(isArabic: ar);
          return RefreshIndicator(
            color:       AppColors.royalBlue,
            strokeWidth: 2,
            onRefresh:   () async => setState(() {}),
            child: ListView.separated(
              padding:     const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount:   list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _BookingCard(
                booking:  list[i],
                isArabic: ar,
                onCancel: () => _showCancelDialog(context, list[i], ar),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showCancelDialog(BuildContext ctx, BookingModel b, bool ar) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(ar ? 'إلغاء الحجز؟' : 'Cancel Booking?'),
        content: Text(
          ar
              ? 'هل أنت متأكد من إلغاء حجز "${b.serviceNameAr}"؟'
              : 'Cancel booking for "${b.serviceNameEn}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              ar ? 'لا، تراجع' : 'Keep',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ar ? 'تم إلغاء الحجز بنجاح' : 'Booking cancelled'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
              ));
            },
            child: Text(
              ar ? 'نعم، إلغاء' : 'Cancel Booking',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// BOOKING CARD
// ──────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool         isArabic;
  final VoidCallback onCancel;

  const _BookingCard({
    required this.booking,
    required this.isArabic,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final st    = booking.status;
    final color = _statusColor(st);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookingPath(booking.id)),
      child: Container(
        decoration: BoxDecoration(
          color:        AppColors.bgCard,
          borderRadius: AppBorderRadius.card,
          border: Border.all(
            color: st == 'IN_PROGRESS'
                ? AppColors.categoryTeal
                : AppColors.borderSubtle,
            width: st == 'IN_PROGRESS' ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Row(
                children: [
                  // Booking number
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.bookingNumber,
                          style: AppTextStyles.orderNumber,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isArabic
                              ? booking.serviceNameAr
                              : booking.serviceNameEn,
                          style: (isArabic
                                  ? AppTextStyles.arabicBodyMedium
                                  : AppTextStyles.bodyMedium)
                              .copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:        color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border:       Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon(st), size: 12, color: color),
                        const SizedBox(width: 4),
                        Text(
                          isArabic ? booking.statusAr() : _statusEn(st),
                          style: AppTextStyles.badgeMedium.copyWith(
                              color: color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: AppColors.borderSubtle),

            // ── Details ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Date row
                  _InfoRow(
                    icon:     Icons.calendar_today_rounded,
                    color:    AppColors.royalBlue,
                    label:    isArabic ? 'الموعد' : 'Appointment',
                    value:    _formatScheduled(booking.scheduledAt, isArabic),
                  ),
                  const SizedBox(height: 8),
                  // Address
                  _InfoRow(
                    icon:  Icons.location_on_rounded,
                    color: AppColors.metallicGold,
                    label: isArabic ? 'العنوان' : 'Address',
                    value: booking.addressLine,
                  ),
                  if (booking.technician != null) ...[
                    const SizedBox(height: 8),
                    // Technician
                    _TechRow(tech: booking.technician!, isArabic: isArabic),
                  ],
                ],
              ),
            ),

            // ── Price row ────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              color: AppColors.bgCard2,
              child: Row(
                children: [
                  Text(
                    isArabic ? 'إجمالي الفاتورة' : 'Total',
                    style: AppTextStyles.caption,
                  ),
                  const Spacer(),
                  Text(
                    '${booking.price.toInt()} ${isArabic ? "ر.س" : booking.currency}',
                    style: AppTextStyles.priceMedium,
                  ),
                ],
              ),
            ),

            // ── Action buttons ────────────────────────────
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: AppColors.borderSubtle))),
              child: _ActionButtons(
                booking:  booking,
                isArabic: isArabic,
                onCancel: onCancel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusEn(String s) => switch (s) {
    'PENDING'     => 'Pending',
    'CONFIRMED'   => 'Confirmed',
    'IN_PROGRESS' => 'In Progress',
    'COMPLETED'   => 'Completed',
    'CANCELLED'   => 'Cancelled',
    _             => s,
  };

  String _formatScheduled(DateTime dt, bool ar) {
    final months = ar
        ? ['يناير','فبراير','مارس','أبريل','مايو','يونيو',
           'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر']
        : ['Jan','Feb','Mar','Apr','May','Jun',
           'Jul','Aug','Sep','Oct','Nov','Dec'];

    final now  = DateTime.now();
    final diff = dt.difference(now);
    String dateStr;

    if (diff.inDays == 0) {
      dateStr = ar ? 'اليوم' : 'Today';
    } else if (diff.inDays == 1) {
      dateStr = ar ? 'غداً' : 'Tomorrow';
    } else if (diff.inDays < 0 && diff.inDays > -7) {
      dateStr = ar ? 'منذ ${-diff.inDays} يوم' : '${-diff.inDays} days ago';
    } else {
      dateStr = '${dt.day} ${months[dt.month - 1]}';
    }

    final h   = dt.hour;
    final m   = dt.minute.toString().padLeft(2, '0');
    final per = ar ? (h < 12 ? 'ص' : 'م') : (h < 12 ? 'AM' : 'PM');
    final dh  = h > 12 ? h - 12 : (h == 0 ? 12 : h);

    return '$dateStr — $dh:$m $per';
  }
}

// ── Info Row ──────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final String   label;
  final String   value;

  const _InfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width:  28, height: 28,
        decoration: BoxDecoration(
          color:        color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value,
                style: AppTextStyles.bodySmall.copyWith(
                  color:      AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2),
          ],
        ),
      ),
    ],
  );
}

// ── Technician Row ────────────────────────────────────────────
class _TechRow extends StatelessWidget {
  final TechnicianModel tech;
  final bool            isArabic;
  const _TechRow({required this.tech, required this.isArabic});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width:  28, height: 28,
        decoration: BoxDecoration(
          gradient:  AppGradients.primaryButton,
          shape:     BoxShape.circle,
        ),
        child: Center(
          child: Text(
            tech.name.isNotEmpty ? tech.name[0] : '?',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize:   12,
              fontWeight: FontWeight.w700,
              color:      Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'الفني' : 'Technician',
              style: AppTextStyles.caption,
            ),
            Row(
              children: [
                Text(
                  tech.name,
                  style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                if (tech.isVerified)
                  const Icon(Icons.verified_rounded,
                      size: 12, color: AppColors.royalBlue),
                const SizedBox(width: 4),
                const Icon(Icons.star_rounded,
                    size: 11, color: AppColors.starFilled),
                Text(
                  ' ${tech.rating.toStringAsFixed(1)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
      // Quick call
      GestureDetector(
        onTap: () => HapticFeedback.lightImpact(),
        child: Container(
          width:  32, height: 32,
          decoration: BoxDecoration(
            color:        AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border:       Border.all(
                color: AppColors.success.withOpacity(0.3)),
          ),
          child: const Icon(Icons.phone_rounded,
              size: 15, color: AppColors.success),
        ),
      ),
      const SizedBox(width: 8),
      // Quick chat
      GestureDetector(
        onTap: () => HapticFeedback.lightImpact(),
        child: Container(
          width:  32, height: 32,
          decoration: BoxDecoration(
            color:        AppColors.royalBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border:       Border.all(
                color: AppColors.royalBlue.withOpacity(0.3)),
          ),
          child: const Icon(Icons.chat_bubble_outline_rounded,
              size: 15, color: AppColors.royalBlue),
        ),
      ),
    ],
  );
}

// ── Action Buttons ────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final BookingModel booking;
  final bool         isArabic;
  final VoidCallback onCancel;

  const _ActionButtons({
    required this.booking,
    required this.isArabic,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final st      = booking.status;
    final buttons = <Widget>[];
    bool first    = true;

    void addDiv() {
      if (!first) {
        buttons.add(Container(
            width: 1, height: 36, color: AppColors.borderSubtle));
      }
      first = false;
    }

    if (_canTrack(st)) {
      addDiv();
      buttons.add(Expanded(
        child: TextButton.icon(
          onPressed: () =>
              context.push(AppRoutes.trackingPath(booking.id)),
          icon:  const Icon(Icons.location_on_rounded,
              size: 14, color: AppColors.royalBlue),
          label: Text(
            isArabic ? 'تتبع الفني' : 'Track',
            style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.royalBlue),
          ),
        ),
      ));
    }

    if (_canReview(st)) {
      addDiv();
      buttons.add(Expanded(
        child: TextButton.icon(
          onPressed: () => HapticFeedback.lightImpact(),
          icon:  const Icon(Icons.star_outline_rounded,
              size: 14, color: AppColors.starFilled),
          label: Text(
            isArabic ? 'قيّم الخدمة' : 'Review',
            style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.starFilled),
          ),
        ),
      ));
    }

    if (_canReview(st)) {
      addDiv();
      buttons.add(Expanded(
        child: TextButton.icon(
          onPressed: () =>
              context.push(AppRoutes.servicePath(booking.serviceId)),
          icon:  const Icon(Icons.replay_rounded,
              size: 14, color: AppColors.metallicGold),
          label: Text(
            isArabic ? 'إعادة الحجز' : 'Rebook',
            style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.metallicGold),
          ),
        ),
      ));
    }

    if (_canCancel(st)) {
      addDiv();
      buttons.add(Expanded(
        child: TextButton.icon(
          onPressed: onCancel,
          icon:  const Icon(Icons.close_rounded,
              size: 14, color: AppColors.error),
          label: Text(
            isArabic ? 'إلغاء' : 'Cancel',
            style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.error),
          ),
        ),
      ));
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: Row(children: buttons),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// EMPTY STATE
// ──────────────────────────────────────────────────────────────
class _EmptyBookings extends StatelessWidget {
  final bool isArabic;
  const _EmptyBookings({required this.isArabic});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color:  AppColors.bgCard,
              shape:  BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Icon(Icons.calendar_today_outlined,
                size: 48, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          Text(
            isArabic ? 'لا توجد حجوزات' : 'No Bookings Yet',
            style: isArabic
                ? AppTextStyles.arabicTitleMedium
                : AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'احجز خدمتك الأولى الآن!'
                : 'Book your first service now!',
            style: (isArabic
                    ? AppTextStyles.arabicBodySmall
                    : AppTextStyles.bodySmall)
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.push(AppRoutes.services),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 13),
              decoration: BoxDecoration(
                gradient:     AppGradients.primaryButton,
                borderRadius: AppBorderRadius.button,
                boxShadow: [
                  BoxShadow(
                    color:      AppColors.royalBlue.withOpacity(0.35),
                    blurRadius: 14,
                    offset:     const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                isArabic ? 'استعرض الخدمات' : 'Browse Services',
                style: isArabic
                    ? AppTextStyles.arabicButton
                    : AppTextStyles.buttonMedium,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
