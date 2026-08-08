import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إلغاء الحجز — light design
class CancelBookingScreen extends ConsumerStatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  ConsumerState<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends ConsumerState<CancelBookingScreen> {
  int _reason = 0;
  final _detailsCtrl = TextEditingController();

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final reasons = ar
        ? ['تغيير الموعد', 'وجدت بديلاً', 'سعر مرتفع', 'سبب آخر']
        : ['Schedule change', 'Found alternative', 'High price', 'Other'];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'إلغاء الحجز' : 'Cancel booking', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Text(ar ? 'سبب الإلغاء' : 'Cancellation reason', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              KayanFilterSlotRow(labels: reasons, selectedIndex: _reason, onSelected: (i) => setState(() => _reason = i)),
              const SizedBox(height: 14),
              KayanDesignTextField(
                label: ar ? 'تفاصيل إضافية' : 'Additional details',
                controller: _detailsCtrl,
                hint: ar ? 'اختياري' : 'Optional',
                icon: Icons.notes_rounded,
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'تأكيد الإلغاء' : 'Confirm cancellation',
                variant: KayanCtaVariant.blue,
                trailingIcon: Icons.cancel_outlined,
                onPressed: () => context.push(AppRoutes.cancelOtp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
