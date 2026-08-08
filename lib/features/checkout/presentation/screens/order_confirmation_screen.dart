import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../ecommerce/product/presentation/providers/product_providers.dart';

/// تأكيد الطلب — light design
class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final summary = ref.watch(cartProvider).summary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'تأكيد الطلب' : 'Order confirmation', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    KayanOfferBanner(
                      title: ar ? 'ملخص الطلب' : 'Order summary',
                      subtitle: '${summary.itemCount} ${ar ? 'منتجات' : 'items'} · ${summary.total.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                      gradient: KayanDesignTokens.gradOrange,
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(icon: Icons.location_on_outlined, title: ar ? 'العنوان' : 'Address', value: ar ? 'حي النخيل، الرياض' : 'Al Nakheel, Riyadh'),
                    _InfoRow(icon: Icons.credit_card_rounded, title: ar ? 'الدفع' : 'Payment', value: ar ? 'بطاقة بنكية' : 'Card'),
                    _InfoRow(icon: Icons.local_shipping_outlined, title: ar ? 'التوصيل' : 'Delivery', value: ar ? '2-3 أيام عمل' : '2-3 business days'),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تأكيد الطلب' : 'Place order',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () {
                  ref.read(cartProvider.notifier).clear();
                  context.pushReplacement(AppRoutes.orderSuccessPath('KYN-${DateTime.now().millisecondsSinceEpoch % 10000000}'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: KayanDesignTokens.bg, borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM), border: Border.all(color: KayanDesignTokens.border)),
        child: Row(
          children: [
            Icon(icon, color: KayanDesignTokens.oOrange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                  Text(value, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
