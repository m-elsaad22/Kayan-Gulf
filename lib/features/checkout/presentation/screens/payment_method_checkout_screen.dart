import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// طريقة دفع الطلب — light design
class PaymentMethodCheckoutScreen extends ConsumerStatefulWidget {
  const PaymentMethodCheckoutScreen({super.key});

  @override
  ConsumerState<PaymentMethodCheckoutScreen> createState() => _PaymentMethodCheckoutScreenState();
}

class _PaymentMethodCheckoutScreenState extends ConsumerState<PaymentMethodCheckoutScreen> {
  int _method = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final options = ar ? ['بطاقة بنكية', 'محفظة كيان', 'الدفع عند الاستلام', 'PayPal'] : ['Card', 'KAYAN Wallet', 'Cash on delivery', 'PayPal'];
    final icons = [Icons.credit_card_rounded, Icons.account_balance_wallet_rounded, Icons.payments_rounded, Icons.paypal];

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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: KayanPayOptionRow(icon: icons[i], label: options[i], selected: _method == i, onTap: () => setState(() => _method = i)),
                    );
                  }),
                ),
              ),
              KayanCtaButton(
                label: ar ? 'متابعة' : 'Continue',
                trailingIcon: Icons.arrow_back_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () {
                  if (_method == 0) {
                    context.push(AppRoutes.checkoutAddCard);
                  } else if (_method == 1) {
                    context.push(AppRoutes.digitalWallet);
                  } else if (_method == 2) {
                    context.push(AppRoutes.codDetails);
                  } else {
                    context.push(AppRoutes.paypalPayment);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
