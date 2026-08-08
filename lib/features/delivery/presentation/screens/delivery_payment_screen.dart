import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../providers/delivery_providers.dart';

/// Matches design/html/97-or-payment.html
class DeliveryPaymentScreen extends ConsumerStatefulWidget {
  const DeliveryPaymentScreen({super.key});

  @override
  ConsumerState<DeliveryPaymentScreen> createState() => _DeliveryPaymentScreenState();
}

class _DeliveryPaymentScreenState extends ConsumerState<DeliveryPaymentScreen> {
  int _method = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final total = ref.watch(deliveryCartSubtotalProvider) + 5;
    final methods = ar
        ? ['بطاقة مدى / فيزا', 'Apple Pay', 'الدفع عند الاستلام', 'محفظة كيان']
        : ['Mada / Visa card', 'Apple Pay', 'Cash on delivery', 'KAYAN Wallet'];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: KayanDesignTokens.kBlueDeep,
        elevation: 0,
        title: Text(ar ? 'طريقة الدفع' : 'Payment method', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            '${ar ? 'الإجمالي' : 'Total'}: ${total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
            style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep),
          ),
          const SizedBox(height: 20),
          ...List.generate(methods.length, (i) {
            final selected = _method == i;
            return GestureDetector(
              onTap: () => setState(() => _method = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: KayanDesignTokens.border)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: KayanDesignTokens.bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.payments_rounded, color: KayanDesignTokens.kBlue),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Text(methods[i], style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlueDeep))),
                    Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? KayanDesignTokens.oOrange : KayanDesignTokens.muted),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: KayanDesignPrimaryButton(
            label: ar ? 'تأكيد الطلب' : 'Place order',
            onPressed: () {
              ref.read(deliveryCartProvider.notifier).clear();
              context.go(AppRoutes.deliverySuccess);
            },
          ),
        ),
      ),
    );
  }
}
