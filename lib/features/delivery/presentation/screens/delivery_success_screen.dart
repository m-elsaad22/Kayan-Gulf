import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// Matches design/html/98-or-success.html
class DeliverySuccessScreen extends ConsumerWidget {
  const DeliverySuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: KayanDesignTokens.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      gradient: KayanDesignTokens.gradGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                ar ? 'تم تأكيد طلبك!' : 'Order confirmed!',
                style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep),
              ),
              const SizedBox(height: 10),
              Text(
                ar ? 'سيصلك طلبك خلال 25-35 دقيقة' : 'Your order will arrive in 25-35 minutes',
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.text2, height: 1.7),
              ),
              const Spacer(),
              KayanDesignPrimaryButton(
                label: ar ? 'تتبع الطلب' : 'Track order',
                onPressed: () => context.go(AppRoutes.deliveryTracking),
                gradient: KayanDesignTokens.gradGreen,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(AppRoutes.delivery),
                child: Text(ar ? 'العودة للرئيسية' : 'Back to home', style: KayanDesignTokens.cairo(color: KayanDesignTokens.kBlue, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
