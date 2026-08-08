import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// استرداد النقاط — light design
class PointsRefundScreen extends ConsumerStatefulWidget {
  const PointsRefundScreen({super.key});

  @override
  ConsumerState<PointsRefundScreen> createState() => _PointsRefundScreenState();
}

class _PointsRefundScreenState extends ConsumerState<PointsRefundScreen> {
  final _pointsCtrl = TextEditingController(text: '500');
  final _reasonCtrl = TextEditingController();

  @override
  void dispose() {
    _pointsCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'استرداد النقاط' : 'Points refund', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: KayanDesignTokens.gradGold,
                  borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Color(0xFF402C00)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ar ? 'رصيد النقاط' : 'Points balance', style: KayanDesignTokens.cairo(fontSize: 12, color: const Color(0xFF402C00))),
                          Text('1,840 ${ar ? 'نقطة' : 'pts'}', style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF402C00))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              KayanDesignTextField(
                label: ar ? 'عدد النقاط' : 'Points amount',
                controller: _pointsCtrl,
                hint: '500',
                icon: Icons.redeem_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                label: ar ? 'سبب الاسترداد' : 'Refund reason',
                controller: _reasonCtrl,
                hint: ar ? 'مثال: إلغاء طلب' : 'e.g. order cancellation',
                icon: Icons.notes_rounded,
              ),
              const SizedBox(height: 16),
              Text(
                ar ? 'يتم مراجعة طلب الاسترداد خلال 24–48 ساعة' : 'Refund requests are reviewed within 24–48 hours',
                style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted),
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'تقديم طلب الاسترداد' : 'Submit refund request',
                variant: KayanCtaVariant.blue,
                trailingIcon: Icons.send_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم إرسال طلب الاسترداد' : 'Refund request submitted')),
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
