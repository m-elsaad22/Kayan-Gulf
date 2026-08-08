// Order success — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class OrderSuccessLightScreen extends ConsumerWidget {
  const OrderSuccessLightScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(gradient: KayanDesignTokens.gradOrange, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 52),
              ),
              const SizedBox(height: 24),
              Text(ar ? 'تم الطلب بنجاح!' : 'Order placed!', style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
              const SizedBox(height: 8),
              Text(orderId, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.oOrange)),
              const SizedBox(height: 4),
              Text(ar ? 'سيتم توصيل طلبك قريباً' : 'Your order will be delivered soon', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
              const SizedBox(height: 32),
              KayanCtaButton(
                label: ar ? 'طلباتي' : 'My orders',
                trailingIcon: Icons.receipt_long_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () => context.go(AppRoutes.orders),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(ar ? 'العودة للرئيسية' : 'Back to home', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.oOrange)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
