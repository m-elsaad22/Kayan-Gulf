// Booking calendar — light design
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../../services/browse/data/models/service_models.dart';

class BookingCalendarScreen extends ConsumerStatefulWidget {
  const BookingCalendarScreen({super.key, required this.serviceSlug});

  final String serviceSlug;

  @override
  ConsumerState<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends ConsumerState<BookingCalendarScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeSlot? _selectedSlot;
  int _selectedAddr = 0;
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  late final List<DateTime> _days = List.generate(14, (i) => DateTime.now().add(Duration(days: i + 1)));
  final _addresses = ['حي النخيل، شارع الملك فهد، الرياض', 'حي العليا، الرياض', 'إضافة عنوان جديد...'];

  List<TimeSlot> get _slots => generateSlots(_selectedDate);

  void _proceed() {
    final ar = ref.read(isArabicProvider);
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ar ? 'يرجى اختيار وقت' : 'Please select a time slot'), backgroundColor: KayanDesignTokens.danger),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    context.push(AppRoutes.bookingConfirm, extra: {
      'serviceSlug': widget.serviceSlug,
      'date': _selectedDate.toIso8601String(),
      'slot': _selectedSlot!.id,
      'slotLabel': _selectedSlot!.label,
      'address': _addresses[_selectedAddr < 2 ? _selectedAddr : 0],
      'notes': _notesCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final dayNames = ar ? ['أح', 'إث', 'ث', 'أر', 'خ', 'ج', 'س'] : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final monthNames = ar
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'اختر الموعد' : 'Choose date & time', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    _SectionLabel(ar ? 'اختر التاريخ' : 'Select date'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _days.length,
                        itemBuilder: (_, i) {
                          final d = _days[i];
                          final sel = _isSameDay(d, _selectedDate);
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _selectedDate = d;
                                _selectedSlot = null;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 58,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                gradient: sel ? KayanDesignTokens.gradGreen : null,
                                color: sel ? null : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: sel ? Colors.transparent : KayanDesignTokens.border),
                                boxShadow: sel ? KayanDesignTokens.shadowS : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(dayNames[d.weekday % 7], style: KayanDesignTokens.cairo(fontSize: 10, color: sel ? Colors.white70 : KayanDesignTokens.muted)),
                                  Text('${d.day}', style: KayanDesignTokens.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: sel ? Colors.white : KayanDesignTokens.text2)),
                                  Text(monthNames[d.month - 1], style: KayanDesignTokens.cairo(fontSize: 8, color: sel ? Colors.white60 : KayanDesignTokens.muted)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionLabel(ar ? 'اختر الوقت' : 'Select time'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _slots.map((slot) {
                        final sel = _selectedSlot?.id == slot.id;
                        final avail = slot.isAvailable;
                        return GestureDetector(
                          onTap: avail
                              ? () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _selectedSlot = slot);
                                }
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: sel ? KayanDesignTokens.gradGreen : null,
                              color: sel ? null : (avail ? Colors.white : KayanDesignTokens.bg),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: sel ? Colors.transparent : KayanDesignTokens.border),
                            ),
                            child: Text(
                              slot.label,
                              style: KayanDesignTokens.cairo(
                                fontWeight: FontWeight.w700,
                                color: sel ? Colors.white : (avail ? KayanDesignTokens.text2 : KayanDesignTokens.muted),
                              ).copyWith(decoration: !avail ? TextDecoration.lineThrough : null),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    _SectionLabel(ar ? 'عنوان الخدمة' : 'Service address'),
                    const SizedBox(height: 10),
                    ...List.generate(_addresses.length, (i) {
                      final isAdd = i == _addresses.length - 1;
                      final sel = _selectedAddr == i;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedAddr = i);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: sel && !isAdd ? KayanDesignTokens.kGreen.withValues(alpha: 0.08) : Colors.white,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            border: Border.all(color: sel ? KayanDesignTokens.kGreen : KayanDesignTokens.border, width: sel ? 1.5 : 1),
                          ),
                          child: Row(
                            children: [
                              Icon(isAdd ? Icons.add_location_alt_outlined : Icons.location_on_outlined, size: 18, color: KayanDesignTokens.kGreen),
                              const SizedBox(width: 10),
                              Expanded(child: Text(_addresses[i], style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: isAdd ? KayanDesignTokens.kBlue : KayanDesignTokens.text2))),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    _SectionLabel(ar ? 'ملاحظات (اختياري)' : 'Notes (optional)'),
                    const SizedBox(height: 8),
                    KayanDesignTextField(
                      label: ar ? 'ملاحظات' : 'Notes',
                      hint: ar ? 'أي تفاصيل إضافية للفني...' : 'Any additional details...',
                      icon: Icons.note_outlined,
                      controller: _notesCtrl,
                    ),
                  ],
                ),
              ),
              if (_selectedSlot != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: KayanDesignTokens.kGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_rounded, size: 14, color: KayanDesignTokens.kGreen),
                        const SizedBox(width: 6),
                        Text('${_selectedDate.day}/${_selectedDate.month} — ${_selectedSlot!.label}', style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: KayanDesignTokens.kGreen)),
                      ],
                    ),
                  ),
                ),
              KayanCtaButton(
                label: ar ? 'متابعة لتأكيد الحجز' : 'Continue to confirm',
                variant: KayanCtaVariant.green,
                onPressed: _selectedSlot != null ? _proceed : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 14));
  }
}
