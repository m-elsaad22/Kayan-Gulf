// ============================================================
// KAYAN — Order Detail Screen (stub)
// lib/features/orders/presentation/screens/order_detail_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/providers/locale_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        title: Text(isArabic ? 'تفاصيل الطلب' : 'Order Details'),
        leading: IconButton(
          icon: Icon(isArabic
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_rounded,
                size: 60, color: AppColors.royalBlue),
            const SizedBox(height: 16),
            Text(orderId,
                style: AppTextStyles.orderNumber.copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
