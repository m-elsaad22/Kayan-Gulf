// ============================================================
// KAYAN — Booking Detail Screen
// lib/features/services/booking/presentation/screens/booking_detail_screen.dart
//
// Shows full booking details, technician info, status timeline,
// and quick actions (track, call, chat, cancel, review)
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

class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    // Find booking from mocks
    final booking = mockBookings.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => mockBookings.first,
    );

    final statusColor = _color(booking.status);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Text(
          booking.bookingNumber,
          style: AppTextStyles.orderNumber.copyWith(fontSize: 14),
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
            icon: const Icon(Icons.share_rounded, size: 20),
            onPressed: () => HapticFeedback.lightImpact(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status banner ──────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color:        statusColor.withOpacity(0.1),
                borderRadius: AppBorderRadius.card,
                border:       Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width:  48, height: 48,
                    decoration: BoxDecoration(
                      color:  statusColor.withOpacity(0.15),
                      shape:  BoxShape.circle,
                    ),
                    child: Icon(_icon(booking.status), size: 24, color: statusColor),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _statusLabel(booking.status, ar),
                        style: AppTextStyles.titleMedium.copyWith(
                            color: statusColor),
                      ),
                      Text(
                        _statusDesc(booking.status, ar),
                        style: AppTextStyles.bodySmall.copyWith(
                            color: statusColor.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Status Timeline ────────────────────────────
            _StatusTimeline(status: booking.status, isArabic: ar),

            const SizedBox(height: 20),

            // ── Service details ────────────────────────────
            _SectionTitle(ar ? 'تفاصيل الخدمة' : 'Service Details', ar),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:        AppColors.bgCard,
                borderRadius: AppBorderRadius.card,
                border:       Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  _DetailItem(
                    icon:  Icons.build_circle_outlined,
                    color: AppColors.royalBlue,
                    label: ar ? 'الخدمة' : 'Service',
                    value: ar ? booking.serviceNameAr : booking.serviceNameEn,
                  ),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _DetailItem(
                    icon:  Icons.event_rounded,
                    color: AppColors.categoryTeal,
                    label: ar ? 'التاريخ والوقت' : 'Date & Time',
                    value: _formatDate(booking.scheduledAt, ar),
                  ),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _DetailItem(
                    icon:  Icons.location_on_rounded,
                    color: AppColors.metallicGold,
                    label: ar ? 'عنوان الخدمة' : 'Address',
                    value: booking.addressLine,
                  ),
                  if (booking.notes != null &&
                      booking.notes!.isNotEmpty) ...[
                    const Divider(height: 20, color: AppColors.borderSubtle),
                    _DetailItem(
                      icon:  Icons.note_alt_outlined,
                      color: AppColors.categoryGreen,
                      label: ar ? 'ملاحظات' : 'Notes',
                      value: booking.notes!,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Technician ────────────────────────────────
            if (booking.technician != null) ...[
              _SectionTitle(ar ? 'الفني المختص' : 'Assigned Technician', ar),
              const SizedBox(height: 10),
              _TechnicianCard(
                tech:     booking.technician!,
                isArabic: ar,
                bookingId: booking.id,
              ),
              const SizedBox(height: 16),
            ],

            // ── Payment ───────────────────────────────────
            _SectionTitle(ar ? 'ملخص الدفع' : 'Payment Summary', ar),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient:     AppGradients.card,
                borderRadius: AppBorderRadius.card,
                border:       Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  _PayRow(ar ? 'رسوم الخدمة' : 'Service Fee',
                      '${booking.price.toInt()} ر.س', false),
                  const SizedBox(height: 8),
                  _PayRow(ar ? 'رسوم التنقل' : 'Travel Fee',
                      ar ? 'مجاني' : 'Free', false,
                      valueColor: AppColors.success),
                  const Divider(height: 20, color: AppColors.borderVisible),
                  _PayRow(ar ? 'الإجمالي' : 'Total',
                      '${booking.price.toInt()} ر.س', true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── CTA buttons ───────────────────────────────
            _ActionSection(booking: booking, isArabic: ar),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Color _color(String s) => switch (s) {
    'PENDING'     => AppColors.warning,
    'CONFIRMED'   => AppColors.royalBlue,
    'IN_PROGRESS' => AppColors.categoryTeal,
    'COMPLETED'   => AppColors.success,
    'CANCELLED'   => AppColors.error,
    _             => AppColors.textMuted,
  };

  IconData _icon(String s) => switch (s) {
    'PENDING'     => Icons.access_time_rounded,
    'CONFIRMED'   => Icons.check_circle_outline_rounded,
    'IN_PROGRESS' => Icons.build_rounded,
    'COMPLETED'   => Icons.check_circle_rounded,
    'CANCELLED'   => Icons.cancel_rounded,
    _             => Icons.info_outline_rounded,
  };

  String _statusLabel(String s, bool ar) => ar ? switch (s) {
    'PENDING'     => 'قيد الانتظار',
    'CONFIRMED'   => 'تم التأكيد',
    'IN_PROGRESS' => 'جاري التنفيذ الآن',
    'COMPLETED'   => 'اكتملت الخدمة',
    'CANCELLED'   => 'تم الإلغاء',
    _             => s,
  } : switch (s) {
    'PENDING'     => 'Pending Confirmation',
    'CONFIRMED'   => 'Booking Confirmed',
    'IN_PROGRESS' => 'Service In Progress',
    'COMPLETED'   => 'Service Completed',
    'CANCELLED'   => 'Booking Cancelled',
    _             => s,
  };

  String _statusDesc(String s, bool ar) => ar ? switch (s) {
    'PENDING'     => 'في انتظار تأكيد الحجز من الفني',
    'CONFIRMED'   => 'سيصلك الفني في الموعد المحدد',
    'IN_PROGRESS' => 'الفني يعمل في موقعك الآن',
    'COMPLETED'   => 'شكراً لاختيار كيان!',
    'CANCELLED'   => 'تم إلغاء هذا الحجز',
    _             => '',
  } : switch (s) {
    'PENDING'     => 'Waiting for technician confirmation',
    'CONFIRMED'   => 'Technician will arrive at scheduled time',
    'IN_PROGRESS' => 'Technician is working at your location',
    'COMPLETED'   => 'Thank you for choosing KAYAN!',
    'CANCELLED'   => 'This booking has been cancelled',
    _             => '',
  };

  String _formatDate(DateTime dt, bool ar) {
    final months = ar
        ? ['يناير','فبراير','مارس','أبريل','مايو','يونيو',
           'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر']
        : ['Jan','Feb','Mar','Apr','May','Jun',
           'Jul','Aug','Sep','Oct','Nov','Dec'];
    final h   = dt.hour;
    final m   = dt.minute.toString().padLeft(2, '0');
    final per = ar ? (h < 12 ? 'صباحاً' : 'مساءً') : (h < 12 ? 'AM' : 'PM');
    final dh  = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '${dt.day} ${months[dt.month - 1]} — $dh:$m $per';
  }
}

// ── Status Timeline ───────────────────────────────────────────
class _StatusTimeline extends StatelessWidget {
  final String status;
  final bool   isArabic;

  const _StatusTimeline({required this.status, required this.isArabic});

  int get _currentStep => switch (status) {
    'PENDING'     => 0,
    'CONFIRMED'   => 1,
    'IN_PROGRESS' => 2,
    'COMPLETED'   => 3,
    'CANCELLED'   => -1,
    _             => 0,
  };

  @override
  Widget build(BuildContext context) {
    if (status == 'CANCELLED') return const SizedBox.shrink();

    final steps = isArabic
        ? ['تم الحجز', 'مؤكد', 'جاري التنفيذ', 'مكتمل']
        : ['Booked', 'Confirmed', 'In Progress', 'Completed'];

    final cur = _currentStep;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        AppColors.bgCard,
        borderRadius: AppBorderRadius.card,
        border:       Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'مراحل الخدمة' : 'Service Progress',
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                // Connector
                final idx = i ~/ 2;
                final done = idx < cur;
                return Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: done
                          ? AppGradients.primaryButton
                          : null,
                      color: done ? null : AppColors.borderDefault,
                    ),
                  ),
                );
              }

              final idx  = i ~/ 2;
              final done = idx < cur;
              final now  = idx == cur;

              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width:  now ? 32 : 26,
                    height: now ? 32 : 26,
                    decoration: BoxDecoration(
                      shape:    BoxShape.circle,
                      gradient: done || now
                          ? AppGradients.primaryButton
                          : null,
                      color:    done || now ? null : AppColors.bgCard2,
                      border:   done || now ? null : Border.all(
                        color: AppColors.borderDefault,
                      ),
                      boxShadow: now ? [
                        BoxShadow(
                          color:      AppColors.royalBlue.withOpacity(0.4),
                          blurRadius: 12,
                        ),
                      ] : [],
                    ),
                    child: Icon(
                      done ? Icons.check_rounded : Icons.circle,
                      size:  done ? 14 : 8,
                      color: done || now
                          ? Colors.white
                          : AppColors.borderDefault,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[idx],
                    style: AppTextStyles.caption.copyWith(
                      color:      done || now
                          ? AppColors.royalBlue
                          : AppColors.textDisabled,
                      fontWeight: now ? FontWeight.w700 : FontWeight.w400,
                      fontSize:   9,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Technician Card ───────────────────────────────────────────
class _TechnicianCard extends StatelessWidget {
  final TechnicianModel tech;
  final bool            isArabic;
  final String          bookingId;

  const _TechnicianCard({
    required this.tech,
    required this.isArabic,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color:        AppColors.bgCard,
      borderRadius: AppBorderRadius.card,
      border:       Border.all(color: AppColors.borderSubtle),
    ),
    child: Row(
      children: [
        // Avatar
        Container(
          width:  56, height: 56,
          decoration: BoxDecoration(
            gradient:  AppGradients.primaryButton,
            shape:     BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:      AppColors.royalBlue.withOpacity(0.25),
                blurRadius: 12,
              ),
            ],
          ),
          child: Center(
            child: Text(
              tech.name.isNotEmpty ? tech.name[0] : '?',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize:   24,
                fontWeight: FontWeight.w700,
                color:      Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    tech.name,
                    style: isArabic
                        ? AppTextStyles.arabicTitleSmall
                        : AppTextStyles.titleSmall,
                  ),
                  if (tech.isVerified) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified_rounded,
                        size: 14, color: AppColors.royalBlue),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      size: 12, color: AppColors.starFilled),
                  Text(
                    ' ${tech.rating.toStringAsFixed(1)}',
                    style: AppTextStyles.rating.copyWith(fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '· ${tech.completedJobs} ${isArabic ? "حجز" : "jobs"}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Action buttons
        Row(
          children: [
            _CircleAction(
              icon:  Icons.phone_rounded,
              color: AppColors.success,
              onTap: () => HapticFeedback.mediumImpact(),
            ),
            const SizedBox(width: 8),
            _CircleAction(
              icon:  Icons.chat_bubble_outline_rounded,
              color: AppColors.royalBlue,
              onTap: () => HapticFeedback.lightImpact(),
            ),
            const SizedBox(width: 8),
            _CircleAction(
              icon:  Icons.location_on_rounded,
              color: AppColors.categoryTeal,
              onTap: () =>
                  context.push(AppRoutes.trackingPath(bookingId)),
            ),
          ],
        ),
      ],
    ),
  );
}

class _CircleAction extends StatelessWidget {
  final IconData     icon;
  final Color        color;
  final VoidCallback onTap;
  const _CircleAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width:  38, height: 38,
      decoration: BoxDecoration(
        color:        color.withOpacity(0.1),
        shape:        BoxShape.circle,
        border:       Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(icon, size: 18, color: color),
    ),
  );
}

// ── Helpers ───────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  final bool   isArabic;
  const _SectionTitle(this.text, this.isArabic);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 3, height: 16,
        decoration: BoxDecoration(
          gradient:     AppGradients.goldButton,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        text,
        style: isArabic
            ? AppTextStyles.arabicTitleMedium
            : AppTextStyles.titleMedium,
      ),
    ],
  );
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final String   label;
  final String   value;
  const _DetailItem({
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
        width:  32, height: 32,
        decoration: BoxDecoration(
          color:        color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _PayRow extends StatelessWidget {
  final String label, value;
  final bool   bold;
  final Color? valueColor;
  const _PayRow(this.label, this.value, this.bold, {this.valueColor});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color:      bold ? AppColors.textPrimary : AppColors.textSecondary,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      Text(
        value,
        style: (bold ? AppTextStyles.priceMedium : AppTextStyles.labelMedium)
            .copyWith(color: valueColor),
      ),
    ],
  );
}

// ── Action Section ────────────────────────────────────────────
class _ActionSection extends StatelessWidget {
  final BookingModel booking;
  final bool         isArabic;
  const _ActionSection({required this.booking, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final st = booking.status;

    return Column(
      children: [
        // Track button for active bookings
        if (st == 'IN_PROGRESS' || st == 'CONFIRMED')
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              context.push(AppRoutes.trackingPath(booking.id));
            },
            child: Container(
              height: 52,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'تتبع الفني مباشرة' : 'Track Technician Live',
                    style: isArabic
                        ? AppTextStyles.arabicButton
                        : AppTextStyles.buttonMedium,
                  ),
                ],
              ),
            ),
          ),

        if (st == 'COMPLETED') ...[
          // Review CTA (gold)
          GestureDetector(
            onTap: () => HapticFeedback.mediumImpact(),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient:     AppGradients.goldButton,
                borderRadius: AppBorderRadius.button,
                boxShadow: [
                  BoxShadow(
                    color:      AppColors.metallicGold.withOpacity(0.4),
                    blurRadius: 14,
                    offset:     const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.bgPrimary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'قيّم الخدمة ⭐' : 'Leave a Review ⭐',
                    style: (isArabic
                            ? AppTextStyles.arabicButton
                            : AppTextStyles.buttonMedium)
                        .copyWith(color: AppColors.bgPrimary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Rebook
          GestureDetector(
            onTap: () =>
                context.push(AppRoutes.servicePath(booking.serviceId)),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color:        AppColors.bgCard,
                borderRadius: AppBorderRadius.button,
                border:       Border.all(color: AppColors.borderActive),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_rounded,
                      color: AppColors.royalBlue, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'إعادة الحجز' : 'Book Again',
                    style: (isArabic
                            ? AppTextStyles.arabicButton
                            : AppTextStyles.buttonMedium)
                        .copyWith(color: AppColors.royalBlue),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Cancel button for pending/confirmed
        if (st == 'PENDING' || st == 'CONFIRMED') ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => HapticFeedback.mediumImpact(),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color:        AppColors.errorBg,
                borderRadius: AppBorderRadius.button,
                border:       Border.all(color: AppColors.borderError),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.close_rounded,
                      color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'إلغاء الحجز' : 'Cancel Booking',
                    style: (isArabic
                            ? AppTextStyles.arabicButton
                            : AppTextStyles.buttonMedium)
                        .copyWith(color: AppColors.error),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
