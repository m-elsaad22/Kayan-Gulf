import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إعادة جدولة الحجز — light design
class RescheduleBookingScreen extends ConsumerStatefulWidget {
  const RescheduleBookingScreen({super.key});

  @override
  ConsumerState<RescheduleBookingScreen> createState() => _RescheduleBookingScreenState();
}

class _RescheduleBookingScreenState extends ConsumerState<RescheduleBookingScreen> {
  int _dayTab = 0;
  int _timeTab = 1;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final days = ar ? ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء'] : ['Sun', 'Mon', 'Tue', 'Wed'];
    final times = ar ? ['09:00', '12:00', '15:00', '18:00'] : ['09:00', '12:00', '15:00', '18:00'];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'إعادة جدولة' : 'Reschedule', onBack: () => context.pop()),
              const SizedBox(height: 16),
              Text(ar ? 'اختر التاريخ' : 'Select date', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              KayanFilterSlotRow(labels: days, selectedIndex: _dayTab, onSelected: (i) => setState(() => _dayTab = i)),
              const SizedBox(height: 16),
              Text(ar ? 'اختر الوقت' : 'Select time', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              KayanFilterSlotRow(labels: times, selectedIndex: _timeTab, onSelected: (i) => setState(() => _timeTab = i)),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'حفظ الموعد الجديد' : 'Save new slot',
                variant: KayanCtaVariant.green,
                trailingIcon: Icons.check_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم تحديث الموعد' : 'Booking rescheduled')),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
