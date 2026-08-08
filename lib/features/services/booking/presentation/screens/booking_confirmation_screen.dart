// Booking confirmation — light design
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

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  const BookingConfirmationScreen({super.key, required this.bookingData});

  final Map<String, dynamic> bookingData;

  @override
  ConsumerState<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends ConsumerState<BookingConfirmationScreen> {
  bool _loading = false;
  bool _agreed = false;

  Future<void> _confirm() async {
    if (!_agreed) return;
    HapticFeedback.heavyImpact();
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final bookingId = 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    context.go(AppRoutes.bookingSuccessPath(bookingId));
  }

  String _formatDate(String? iso, bool ar) {
    if (iso == null) return '';
    try {
      final d = DateTime.parse(iso);
      final months = ar
          ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
          : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${d.day} ${months[d.month - 1]}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final d = widget.bookingData;
    final serviceSlug = d['serviceSlug'] as String? ?? 'ac';
    final serviceAsync = ref.watch(serviceDetailProvider(serviceSlug));

    return serviceAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (service) => Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'تأكيد الحجز' : 'Confirm booking', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    KayanOfferBanner(
                      title: ar ? service.nameAr : service.nameEn,
                      subtitle: '${service.finalPrice.toInt()} ${ar ? 'ر.س' : 'SAR'} · ${ar ? 'سعر ثابت' : 'Fixed price'}',
                      gradient: KayanDesignTokens.gradGreen,
                    ),
                    const SizedBox(height: 14),
                    _DetailCard(
                      icon: Icons.event_rounded,
                      label: ar ? 'التاريخ والوقت' : 'Date & time',
                      value: '${d['slotLabel'] ?? ''} — ${_formatDate(d['date'] as String?, ar)}',
                    ),
                    _DetailCard(
                      icon: Icons.location_on_rounded,
                      label: ar ? 'عنوان الخدمة' : 'Service address',
                      value: d['address'] as String? ?? '',
                    ),
                    if (d['notes'] != null && (d['notes'] as String).isNotEmpty)
                      _DetailCard(
                        icon: Icons.note_outlined,
                        label: ar ? 'ملاحظات' : 'Notes',
                        value: d['notes'] as String,
                      ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        border: Border.all(color: KayanDesignTokens.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.payments_rounded, color: KayanDesignTokens.kGreen, size: 20),
                          const SizedBox(width: 10),
                          Expanded(child: Text(ar ? 'الدفع عند الاستلام' : 'Cash on delivery', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700))),
                          Text('${service.finalPrice.toInt()} ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kGreen)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: KayanDesignTokens.kGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        border: Border.all(color: KayanDesignTokens.kGreen.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _GuaranteeRow(ar ? 'ضمان الخدمة لمدة سنة' : '1-year service warranty'),
                          _GuaranteeRow(ar ? 'فنيون معتمدون' : 'Certified technicians'),
                          _GuaranteeRow(ar ? 'إلغاء مجاني قبل ساعتين' : 'Free cancellation 2h before'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _agreed = !_agreed);
                      },
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: _agreed ? KayanDesignTokens.kGreen : Colors.transparent,
                              border: Border.all(color: _agreed ? KayanDesignTokens.kGreen : KayanDesignTokens.border, width: 1.5),
                            ),
                            child: _agreed ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ar ? 'أوافق على شروط الخدمة وسياسة الإلغاء' : 'I agree to service terms and cancellation policy',
                              style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.text2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تأكيد الحجز' : 'Confirm booking',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.green,
                loading: _loading,
                onPressed: _agreed && !_loading ? _confirm : null,
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        border: Border.all(color: KayanDesignTokens.border),
        boxShadow: KayanDesignTokens.shadowS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: KayanDesignTokens.kBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted)),
                Text(value, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuaranteeRow extends StatelessWidget {
  const _GuaranteeRow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 14, color: KayanDesignTokens.kGreen),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.kGreen))),
        ],
      ),
    );
  }
}
