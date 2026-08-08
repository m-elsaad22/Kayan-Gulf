// Service payment — light design (29-hs-payment.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  ConsumerState<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final options = ar
        ? ['بطاقة بنكية', 'محفظة كيان', 'الدفع عند الإنجاز']
        : ['Card', 'KAYAN Wallet', 'Pay on completion'];
    final icons = [Icons.credit_card_rounded, Icons.account_balance_wallet_rounded, Icons.payments_rounded];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'طريقة الدفع' : 'Payment method', onBack: () => context.pop()),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: List.generate(options.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: KayanPayOptionRow(
                        icon: icons[i],
                        label: options[i],
                        selected: _selected == i,
                        onTap: () => setState(() => _selected = i),
                      ),
                    );
                  }),
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تأكيد الدفع' : 'Confirm payment',
                trailingIcon: Icons.lock_rounded,
                variant: KayanCtaVariant.green,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
