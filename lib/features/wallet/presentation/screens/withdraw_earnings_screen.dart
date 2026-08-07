import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// سحب الأرباح — light design
class WithdrawEarningsScreen extends ConsumerStatefulWidget {
  const WithdrawEarningsScreen({super.key});

  @override
  ConsumerState<WithdrawEarningsScreen> createState() => _WithdrawEarningsScreenState();
}

class _WithdrawEarningsScreenState extends ConsumerState<WithdrawEarningsScreen> {
  final _amount = TextEditingController(text: '250');
  bool _processing = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'سحب الأرباح' : 'Withdraw earnings', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: KayanDesignTokens.kGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        border: Border.all(color: KayanDesignTokens.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ar ? 'المبلغ المتاح' : 'Available amount', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
                          Text('1,250 ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.kGreen)),
                          Text(ar ? 'الحد الأدنى للسحب 100 ر.س' : 'Minimum withdrawal 100 SAR', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: KayanDesignTokens.bg, borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM), border: Border.all(color: KayanDesignTokens.border)),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_rounded, color: KayanDesignTokens.kBlue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ar ? 'الحساب البنكي' : 'Bank account', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                Text('IBAN **** 2048', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _amount, label: ar ? 'مبلغ السحب' : 'Withdrawal amount', icon: Icons.payments_outlined, keyboardType: TextInputType.number),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تأكيد السحب' : 'Confirm withdrawal',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.green,
                loading: _processing,
                onPressed: _processing
                    ? null
                    : () async {
                        setState(() => _processing = true);
                        await Future.delayed(const Duration(milliseconds: 800));
                        if (!context.mounted) return;
                        setState(() => _processing = false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ar ? 'تم إرسال طلب السحب' : 'Withdrawal submitted')));
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
