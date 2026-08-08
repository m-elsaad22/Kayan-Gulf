import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// المحفظة الرقمية — light design
class DigitalWalletScreen extends ConsumerStatefulWidget {
  const DigitalWalletScreen({super.key});

  @override
  ConsumerState<DigitalWalletScreen> createState() => _DigitalWalletScreenState();
}

class _DigitalWalletScreenState extends ConsumerState<DigitalWalletScreen> {
  int _wallet = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final options = ar ? ['Apple Pay', 'محفظة كيان'] : ['Apple Pay', 'KAYAN Wallet'];
    final icons = [Icons.phone_iphone_rounded, Icons.account_balance_wallet_rounded];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'المحفظة الرقمية' : 'Digital wallet', onBack: () => context.pop()),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: List.generate(options.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: KayanPayOptionRow(icon: icons[i], label: options[i], selected: _wallet == i, onTap: () => setState(() => _wallet = i)),
                    );
                  }),
                ),
              ),
              KayanCtaButton(
                label: ar ? 'ادفع الآن' : 'Pay now',
                trailingIcon: Icons.check_rounded,
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
