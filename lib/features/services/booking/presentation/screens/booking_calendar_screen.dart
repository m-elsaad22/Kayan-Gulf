// KAYAN — Booking Calendar Screen
// lib/features/services/booking/presentation/screens/booking_calendar_screen.dart

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

class BookingCalendarScreen extends ConsumerStatefulWidget {
  final String serviceSlug;
  const BookingCalendarScreen({super.key, required this.serviceSlug});
  @override
  ConsumerState<BookingCalendarScreen> createState() => _BCS();
}

class _BCS extends ConsumerState<BookingCalendarScreen> {
  DateTime  _selectedDate  = DateTime.now().add(const Duration(days: 1));
  TimeSlot? _selectedSlot;
  int       _selectedAddr  = 0;
  String    _notes         = '';
  bool      _isLoading     = false;

  // 14-day calendar
  late final List<DateTime> _days = List.generate(14, (i) => DateTime.now().add(Duration(days: i + 1)));

  List<TimeSlot> get _slots => generateSlots(_selectedDate);

  final _addresses = ['حي النخيل، شارع الملك فهد، الرياض', 'حي العليا، الرياض', 'إضافة عنوان جديد...'];

  void _proceed() async {
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ref.read(isArabicProvider) ? 'يرجى اختيار وقت' : 'Please select a time slot'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
      ));
      return;
    }
    HapticFeedback.mediumImpact();
    context.push(AppRoutes.bookingConfirm, extra: {
      'serviceSlug': widget.serviceSlug,
      'date': _selectedDate.toIso8601String(),
      'slot': _selectedSlot!.id,
      'slotLabel': _selectedSlot!.label,
      'address': _addresses[_selectedAddr < 2 ? _selectedAddr : 0],
      'notes': _notes,
    });
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle: true,
        title: Text(ar ? 'اختر الموعد' : 'Choose Date & Time',
            style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(
          icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop()),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppColors.borderSubtle)),
      ),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),

          // Date picker row
          _SecLabel(ar ? 'اختر التاريخ' : 'Select Date', ar),
          const SizedBox(height: 10),
          SizedBox(height: 80, child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            itemCount: _days.length,
            itemBuilder: (_, i) {
              final d = _days[i];
              final sel = _isSameDay(d, _selectedDate);
              final dayNames = ar
                  ? ['أح', 'إث', 'ث', 'أر', 'خ', 'ج', 'س']
                  : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
              final monthNames = ar
                  ? ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر']
                  : ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
              return GestureDetector(
                onTap: () { HapticFeedback.selectionClick(); setState(() { _selectedDate = d; _selectedSlot = null; }); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 58, margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    gradient: sel ? AppGradients.primaryButton : null,
                    color: sel ? null : AppColors.bgCard,
                    borderRadius: AppBorderRadius.md,
                    border: Border.all(color: sel ? Colors.transparent : AppColors.borderSubtle),
                    boxShadow: sel ? [BoxShadow(color: AppColors.royalBlue.withOpacity(0.3), blurRadius: 10)] : [],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(dayNames[d.weekday % 7], style: AppTextStyles.caption.copyWith(color: sel ? Colors.white70 : AppColors.textMuted)),
                    const SizedBox(height: 4),
                    Text('${d.day}', style: AppTextStyles.titleMedium.copyWith(color: sel ? Colors.white : AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(monthNames[d.month - 1], style: AppTextStyles.caption.copyWith(fontSize: 8, color: sel ? Colors.white60 : AppColors.textMuted)),
                  ]),
                ),
              );
            },
          )),

          const SizedBox(height: 20),

          // Time slots
          _SecLabel(ar ? 'اختر الوقت' : 'Select Time Slot', ar),
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Wrap(spacing: 10, runSpacing: 10, children: _slots.map((slot) {
              final sel  = _selectedSlot?.id == slot.id;
              final avail = slot.isAvailable;
              return GestureDetector(
                onTap: avail ? () { HapticFeedback.selectionClick(); setState(() => _selectedSlot = slot); } : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: sel ? AppGradients.primaryButton : null,
                    color: sel ? null : (avail ? AppColors.bgCard : AppColors.bgCard2),
                    borderRadius: AppBorderRadius.sm,
                    border: Border.all(color: sel ? Colors.transparent : (avail ? AppColors.borderDefault : AppColors.borderSubtle)),
                    boxShadow: sel ? [BoxShadow(color: AppColors.royalBlue.withOpacity(0.3), blurRadius: 8)] : [],
                  ),
                  child: Text(slot.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: sel ? Colors.white : (avail ? AppColors.textPrimary : AppColors.textDisabled),
                        decoration: !avail ? TextDecoration.lineThrough : null,
                      )),
                ),
              );
            }).toList())),

          const SizedBox(height: 20),

          // Address selection
          _SecLabel(ar ? 'عنوان الخدمة' : 'Service Address', ar),
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Column(children: List.generate(_addresses.length, (i) {
              final isAdd = i == _addresses.length - 1;
              final sel = _selectedAddr == i;
              return GestureDetector(
                onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedAddr = i); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sel && !isAdd ? AppColors.royalBlue.withOpacity(0.07) : AppColors.bgCard,
                    borderRadius: AppBorderRadius.sm,
                    border: Border.all(color: sel && !isAdd ? AppColors.borderActiveBold : (isAdd ? AppColors.borderActive : AppColors.borderSubtle), width: sel ? 1.5 : 1),
                  ),
                  child: Row(children: [
                    if (!isAdd) AnimatedContainer(duration: const Duration(milliseconds: 200),
                      width: 18, height: 18, decoration: BoxDecoration(shape: BoxShape.circle,
                          border: Border.all(color: sel ? AppColors.royalBlue : AppColors.borderDefault, width: sel ? 2 : 1.5),
                          color: sel ? AppColors.royalBlue : Colors.transparent),
                      child: sel ? const Icon(Icons.check_rounded, color: Colors.white, size: 10) : null),
                    if (isAdd) const Icon(Icons.add_location_alt_outlined, size: 18, color: AppColors.royalBlue),
                    const SizedBox(width: 10),
                    Expanded(child: Text(_addresses[i],
                        style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(
                          color: isAdd ? AppColors.royalBlue : (sel ? AppColors.royalBlue : AppColors.textPrimary)))),
                  ]),
                ),
              );
            }))),

          const SizedBox(height: 16),

          // Notes
          _SecLabel(ar ? 'ملاحظات (اختياري)' : 'Notes (Optional)', ar),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: TextField(
              maxLines: 3,
              textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
              style: ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: ar ? 'أي تفاصيل إضافية للفني...' : 'Any additional details for the technician...',
                hintStyle: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textMuted),
              ),
              onChanged: (v) => _notes = v,
            )),
        ]))),

        // Confirm bar
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.paddingOf(context).bottom + 12),
          decoration: BoxDecoration(color: AppColors.bgSurface,
              border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, -4))]),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (_selectedSlot != null)
              Padding(padding: const EdgeInsets.only(bottom: 8), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.royalBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.event_rounded, size: 14, color: AppColors.royalBlue),
                  const SizedBox(width: 6),
                  Text('${_selectedDate.day}/${_selectedDate.month} — ${_selectedSlot!.label}',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.royalBlue)),
                ]))),
            GestureDetector(
              onTap: _proceed,
              child: Container(height: 52,
                decoration: BoxDecoration(
                  gradient: _selectedSlot != null ? AppGradients.primaryButton : const LinearGradient(colors: [AppColors.bgCard2, AppColors.bgCard2]),
                  borderRadius: AppBorderRadius.button,
                  boxShadow: _selectedSlot != null ? [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))] : [],
                ),
                child: Center(child: Text(ar ? 'متابعة لتأكيد الحجز' : 'Continue to Confirm',
                    style: (ar ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium).copyWith(
                      color: _selectedSlot != null ? Colors.white : AppColors.textDisabled)))),
            ),
          ]),
        ),
      ]),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

Widget _SecLabel(String t, bool ar) => Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
  child: Text(t, style: ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall));
