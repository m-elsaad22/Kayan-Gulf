// KAYAN — Booking Confirmation Screen
// lib/features/services/booking/presentation/screens/booking_confirmation_screen.dart

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
import '../../../browse/data/models/service_models.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> bookingData;
  const BookingConfirmationScreen({super.key, required this.bookingData});
  @override
  ConsumerState<BookingConfirmationScreen> createState() => _BCnf();
}

class _BCnf extends ConsumerState<BookingConfirmationScreen> {
  bool _isLoading = false;
  bool _agreed    = false;

  Future<void> _confirm() async {
    if (!_agreed) return;
    HapticFeedback.heavyImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final bookingId = 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    context.go(AppRoutes.bookingSuccessPath(bookingId));
  }

  @override
  Widget build(BuildContext context) {
    final ar  = ref.watch(isArabicProvider);
    final d   = widget.bookingData;
    final service  = mockServiceDetail(d['serviceSlug'] as String? ?? 'ac');

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface, centerTitle: true,
        title: Text(ar ? 'تأكيد الحجز' : 'Confirm Booking',
            style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      ),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.pagePadding), child: Column(children: [
          // Service card
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppGradients.card, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderGold)),
            child: Column(children: [
              Row(children: [
                Container(width: 52, height: 52, decoration: BoxDecoration(color: AppColors.royalBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(14)), child: const Center(child: Text('❄️', style: TextStyle(fontSize: 26)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(ar ? service.nameAr : service.nameEn, style: ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall, maxLines: 2),
                  Text(ar ? (service.categoryNameAr ?? '') : (service.categorySlug ?? ''), style: AppTextStyles.caption.copyWith(color: AppColors.skyBlue)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${service.finalPrice.toInt()} ر.س', style: AppTextStyles.priceLarge),
                  Text(ar ? 'سعر ثابت' : 'Fixed', style: AppTextStyles.caption),
                ]),
              ]),
              const SizedBox(height: 12),
              const Divider(color: AppColors.borderSubtle),
              const SizedBox(height: 12),
              // Date/time
              _DetailRow(icon: Icons.event_rounded, color: AppColors.royalBlue,
                  label: ar ? 'التاريخ والوقت' : 'Date & Time',
                  value: '${d['slotLabel'] ?? ''} — ${_formatDate(d['date'] as String?, ar)}'),
              const SizedBox(height: 10),
              _DetailRow(icon: Icons.location_on_rounded, color: AppColors.metallicGold,
                  label: ar ? 'عنوان الخدمة' : 'Service Address',
                  value: d['address'] as String? ?? ''),
              if (d['notes'] != null && (d['notes'] as String).isNotEmpty) ...[
                const SizedBox(height: 10),
                _DetailRow(icon: Icons.note_outlined, color: AppColors.categoryGreen,
                    label: ar ? 'ملاحظات' : 'Notes', value: d['notes'] as String),
              ],
            ])),

          const SizedBox(height: 16),

          // Payment info card
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.payment_rounded, size: 16, color: AppColors.metallicGold),
                const SizedBox(width: 8),
                Text(ar ? 'طريقة الدفع' : 'Payment Method', style: ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.success.withOpacity(0.3))),
                  child: Text('💵 ${ar ? "الدفع عند الاستلام" : "Cash on Delivery"}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.success))),
                const Spacer(),
                Text('${service.finalPrice.toInt()} ر.س', style: AppTextStyles.priceMedium),
              ]),
            ])),

          const SizedBox(height: 16),

          // Guarantees
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.successBg, borderRadius: AppBorderRadius.sm, border: Border.all(color: AppColors.borderSuccess)),
            child: Column(children: [
              _GuarRow('🛡️', ar ? 'ضمان الخدمة لمدة سنة كاملة' : '1-year service warranty'),
              _GuarRow('✅', ar ? 'فنيون معتمدون ومرخصون' : 'Certified and licensed technicians'),
              _GuarRow('📞', ar ? 'يمكنك الإلغاء مجاناً قبل 2 ساعة' : 'Free cancellation up to 2 hours before'),
            ])),

          const SizedBox(height: 16),

          // Terms checkbox
          GestureDetector(
            onTap: () { HapticFeedback.selectionClick(); setState(() => _agreed = !_agreed); },
            child: Row(children: [
              AnimatedContainer(duration: const Duration(milliseconds: 200),
                width: 22, height: 22,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),
                    color: _agreed ? AppColors.royalBlue : Colors.transparent,
                    border: Border.all(color: _agreed ? AppColors.royalBlue : AppColors.borderDefault, width: 1.5)),
                child: _agreed ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null),
              const SizedBox(width: 10),
              Expanded(child: Text(ar ? 'أوافق على شروط الخدمة وسياسة الإلغاء' : 'I agree to the service terms and cancellation policy',
                  style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary))),
            ]),
          ),
        ]))),

        // Confirm CTA
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.paddingOf(context).bottom + 12),
          decoration: BoxDecoration(color: AppColors.bgSurface,
              border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, -4))]),
          child: AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: _agreed ? 1.0 : 0.45,
            child: GestureDetector(
              onTap: _agreed && !_isLoading ? _confirm : null,
              child: Container(height: 56, decoration: BoxDecoration(
                gradient: _agreed ? AppGradients.goldButton : const LinearGradient(colors: [AppColors.bgCard2, AppColors.bgCard2]),
                borderRadius: AppBorderRadius.button,
                boxShadow: _agreed ? [BoxShadow(color: AppColors.metallicGold.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))] : [],
              ),
              child: Center(child: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.bgPrimary, strokeWidth: 2)) :
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.bgPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(ar ? 'تأكيد الحجز • ${service.finalPrice.toInt()} ر.س' : 'Confirm Booking • ${service.finalPrice.toInt()} SAR',
                      style: (ar ? AppTextStyles.arabicButton : AppTextStyles.buttonLarge).copyWith(color: AppColors.bgPrimary)),
                ]))))),
        ),
      ]),
    );
  }

  String _formatDate(String? iso, bool ar) {
    if (iso == null) return '';
    try {
      final d = DateTime.parse(iso);
      final months = ar ? ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر']
          : ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${d.day} ${months[d.month - 1]}';
    } catch (_) { return ''; }
  }
}

Widget _DetailRow({required IconData icon, required Color color, required String label, required String value}) =>
  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(width: 30, height: 30, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 15, color: color)),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.caption),
      Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
    ])),
  ]);

Widget _GuarRow(String e, String t) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
  Text(e), const SizedBox(width: 8), Expanded(child: Text(t, style: AppTextStyles.bodySmall.copyWith(color: AppColors.success)))]));
