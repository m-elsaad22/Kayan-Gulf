// Shop checkout — light design (63-sh-payment.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../features/checkout/presentation/providers/checkout_providers.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../product/presentation/providers/product_providers.dart';

class ShopCheckoutScreen extends ConsumerStatefulWidget {
  const ShopCheckoutScreen({super.key});

  @override
  ConsumerState<ShopCheckoutScreen> createState() => _ShopCheckoutScreenState();
}

class _ShopCheckoutScreenState extends ConsumerState<ShopCheckoutScreen> {
  int _payMethod = 2; // default COD for KSA
  bool _processing = false;
  String? _error;

  PaymentMethod get _selected => switch (_payMethod) {
        0 => PaymentMethod.card,
        1 => PaymentMethod.wallet,
        _ => PaymentMethod.cod,
      };

  Future<void> _pay() async {
    setState(() {
      _processing = true;
      _error = null;
    });
    final checkout = ref.read(checkoutProvider.notifier);
    checkout.selectPayment(_selected);
    final ok = await checkout.placeOrder(method: _selected);
    if (!mounted) return;

    if (!ok) {
      final msg = ref.read(checkoutProvider).errorMessage ?? 'order_failed';
      setState(() {
        _processing = false;
        _error = msg;
      });
      return;
    }

    await ref.read(cartProvider.notifier).clear();
    if (!mounted) return;
    context.pushReplacement(AppRoutes.shopSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final summary = ref.watch(cartProvider).summary;
    final options = ar
        ? ['بطاقة بنكية', 'محفظة كيان', 'الدفع عند الاستلام']
        : ['Card', 'Wallet', 'Cash on delivery'];
    final icons = [
      Icons.credit_card_rounded,
      Icons.account_balance_wallet_rounded,
      Icons.payments_rounded,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'الدفع' : 'Payment',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 14),
              KayanOfferBanner(
                title: ar ? 'ملخص الطلب' : 'Order summary',
                subtitle:
                    '${summary.itemCount} ${ar ? 'منتجات' : 'items'} · ${summary.total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                gradient: KayanDesignTokens.gradOrange,
              ),
              const SizedBox(height: 16),
              Text(
                ar ? 'طريقة الدفع' : 'Payment method',
                style: KayanDesignTokens.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: KayanDesignTokens.text2,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(options.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: KayanPayOptionRow(
                          icon: icons[i],
                          label: options[i],
                          selected: _payMethod == i,
                          onTap: () => setState(() => _payMethod = i),
                        ),
                      );
                    }),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        ar
                            ? 'تعذر إتمام الطلب. تأكد من تسجيل الدخول وعنوان التوصيل.'
                            : 'Could not place order. Sign in and set a delivery address.',
                        style: KayanDesignTokens.cairo(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ],
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
