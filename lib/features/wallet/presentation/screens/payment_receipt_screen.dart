import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إيصال الدفع — light design
class PaymentReceiptScreen extends ConsumerWidget {
  const PaymentReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'إيصال الدفع' : 'Payment receipt', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(gradient: KayanDesignTokens.gradGreen, shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('KYN-884201', textAlign: TextAlign.center, style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
                    Text(ar ? 'مدفوع بنجاح' : 'Paid successfully', textAlign: TextAlign.center, style: KayanDesignTokens.cairo(color: KayanDesignTokens.kGreen)),
                    const SizedBox(height: 24),
                    _Row(label: ar ? 'المبلغ' : 'Amount', value: '299 ${ar ? 'ر.س' : 'SAR'}'),
                    _Row(label: ar ? 'الطريقة' : 'Method', value: ar ? 'بطاقة بنكية' : 'Card'),
                    _Row(label: ar ? 'التاريخ' : 'Date', value: ar ? '7 أغسطس 2026' : 'Aug 7, 2026'),
                    _Row(label: ar ? 'التاجر' : 'Merchant', value: ar ? 'متجر كيان' : 'KAYAN Shop'),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'مشاركة الإيصال' : 'Share receipt',
                trailingIcon: Icons.share_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ar ? 'تم نسخ رقم العملية' : 'Transaction ID copied')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted))),
          Text(value, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
