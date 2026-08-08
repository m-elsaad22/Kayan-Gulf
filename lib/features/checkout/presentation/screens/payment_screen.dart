// Payment step — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../ecommerce/product/presentation/providers/product_providers.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, this.paymentData = const {}});

  final Map<String, dynamic> paymentData;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  int _payMethod = 0;
  bool _processing = false;

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    ref.read(cartProvider.notifier).clear();
    final orderId = 'KYN-${DateTime.now().millisecondsSinceEpoch % 10000000}';
    context.pushReplacement(AppRoutes.orderSuccessPath(orderId));
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final summary = ref.watch(cartProvider).summary;
    final options = ar ? ['بطاقة بنكية', 'محفظة كيان', 'الدفع عند الاستلام'] : ['Card', 'KAYAN Wallet', 'Cash on delivery'];
    final icons = [Icons.credit_card_rounded, Icons.account_balance_wallet_rounded, Icons.payments_rounded];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'الدفع' : 'Payment', onBack: () => context.pop()),
              const SizedBox(height: 14),
              KayanOfferBanner(
                title: ar ? 'ملخص الطلب' : 'Order summary',
                subtitle: '${summary.itemCount} ${ar ? 'منتجات' : 'items'} · ${summary.total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                gradient: KayanDesignTokens.gradOrange,
              ),
              const SizedBox(height: 16),
              Text(ar ? 'طريقة الدفع' : 'Payment method', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: List.generate(options.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: KayanPayOptionRow(icon: icons[i], label: options[i], selected: _payMethod == i, onTap: () => setState(() => _payMethod = i)),
                    );
                  }),
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تأكيد الدفع' : 'Confirm payment',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.orange,
                loading: _processing,
                onPressed: _processing ? null : _pay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
