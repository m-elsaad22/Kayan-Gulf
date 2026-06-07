// KAYAN — Payment Screen (redirects to Checkout)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';

class PaymentScreen extends ConsumerWidget {
  final Map<String, dynamic> paymentData;
  const PaymentScreen({super.key, this.paymentData = const {}});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    // Payment is handled inside CheckoutScreen — redirect there
    WidgetsBinding.instance.addPostFrameCallback((_) => context.replace(AppRoutes.checkout));
    return Scaffold(backgroundColor: AppColors.bgScaffold,
      body: Center(child: Text(ar ? 'جارٍ التحميل...' : 'Loading...',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted))));
  }
}
