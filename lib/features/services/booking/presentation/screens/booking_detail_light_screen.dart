// Booking detail — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/service_models.dart';

class BookingDetailLightScreen extends ConsumerWidget {
  const BookingDetailLightScreen({super.key, required this.bookingId});

  final String bookingId;

  Color _statusColor(String status) => switch (status) {
        'CONFIRMED' => KayanDesignTokens.kBlue,
        'IN_PROGRESS' => KayanDesignTokens.kOrange,
        'COMPLETED' => KayanDesignTokens.kGreen,
        'CANCELLED' => KayanDesignTokens.danger,
        _ => KayanDesignTokens.muted,
      };

  String _statusLabel(String status, bool ar) {
    if (ar) return BookingModel(id: '', bookingNumber: '', serviceNameAr: '', serviceNameEn: '', serviceId: '', price: 0, scheduledAt: DateTime.now(), addressLine: '', status: status).statusAr();
    return switch (status) {
      'CONFIRMED' => 'Confirmed',
      'IN_PROGRESS' => 'In progress',
      'COMPLETED' => 'Completed',
      'CANCELLED' => 'Cancelled',
      _ => status,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final booking = mockBookings.firstWhere((b) => b.id == bookingId, orElse: () => mockBookings.first);
    final color = _statusColor(booking.status);
    final tech = booking.technician;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: booking.bookingNumber,
            variant: KayanSectionHeroVariant.green,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KayanDesignTokens.surface,
                    borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                    border: Border.all(color: KayanDesignTokens.border),
                    boxShadow: KayanDesignTokens.shadowS,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ar ? booking.serviceNameAr : booking.serviceNameEn,
                              style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(99)),
                            child: Text(_statusLabel(booking.status, ar), style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(icon: Icons.calendar_today_outlined, text: '${booking.scheduledAt.day}/${booking.scheduledAt.month}/${booking.scheduledAt.year}'),
                      _InfoRow(icon: Icons.location_on_outlined, text: booking.addressLine),
                      _InfoRow(icon: Icons.payments_outlined, text: '${booking.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}'),
                      if (booking.notes != null) _InfoRow(icon: Icons.notes_outlined, text: booking.notes!),
                    ],
                  ),
                ),
                if (tech != null) ...[
                  const SizedBox(height: 16),
                  KayanSectionHeader(title: ar ? 'الفني' : 'Technician'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: KayanDesignTokens.surface,
                      borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                      border: Border.all(color: KayanDesignTokens.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: KayanDesignTokens.kGreen,
                          child: Text(tech.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tech.name, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                              Text('${tech.rating} ⭐ · ${tech.completedJobs} ${ar ? 'مهمة' : 'jobs'}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.phone_rounded, color: KayanDesignTokens.kGreen)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline_rounded, color: KayanDesignTokens.kBlue)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (booking.status == 'IN_PROGRESS')
                  KayanCtaButton(
                    label: ar ? 'تتبع الفني' : 'Track technician',
                    trailingIcon: Icons.location_on_rounded,
                    variant: KayanCtaVariant.green,
                    onPressed: () => context.push(AppRoutes.trackingPath(booking.id)),
                  ),
                if (booking.status == 'COMPLETED')
                  KayanCtaButton(
                    label: ar ? 'تقييم الخدمة' : 'Rate service',
                    trailingIcon: Icons.star_rounded,
                    variant: KayanCtaVariant.gold,
                    onPressed: () {},
                  ),
                if (booking.status == 'CONFIRMED')
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: KayanCtaButton(
                      label: ar ? 'إلغاء الحجز' : 'Cancel booking',
                      trailingIcon: Icons.close_rounded,
                      variant: KayanCtaVariant.orange,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(ar ? 'تم إرسال طلب الإلغاء' : 'Cancellation requested')),
                        );
                      },
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: KayanDesignTokens.kBlue),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2))),
        ],
      ),
    );
  }
}
