import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// دفع PayPal — light design
class PaypalPaymentScreen extends ConsumerWidget {
  const PaypalPaymentScreen({super.key});

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
              KayanLightTopBar(title: ar ? 'دفع PayPal' : 'PayPal payment', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 24),
                    Center(child: Icon(Icons.account_balance_wallet_rounded, size: 64, color: KayanDesignTokens.kBlue)),
                    const SizedBox(height: 16),
                    Text(ar ? 'سيتم فتح بوابة PayPal الآمنة' : 'Secure PayPal gateway will open', textAlign: TextAlign.center, style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: KayanDesignTokens.bg, borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM), border: Border.all(color: KayanDesignTokens.border)),
                      child: Text(ar ? 'حماية المشتري حسب سياسات PayPal' : 'Buyer protection per PayPal policies', style: KayanDesignTokens.cairo(fontSize: 13)),
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'متابعة عبر PayPal' : 'Continue with PayPal',
                trailingIcon: Icons.open_in_new_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () => context.push(AppRoutes.orderConfirmation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
