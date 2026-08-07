import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// الدفع عند الاستلام — light design
class CodDetailsScreen extends ConsumerWidget {
  const CodDetailsScreen({super.key});

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
              KayanLightTopBar(title: ar ? 'الدفع عند الاستلام' : 'Cash on delivery', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: KayanDesignTokens.oOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM), border: Border.all(color: KayanDesignTokens.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ar ? 'المبلغ المطلوب' : 'Amount due', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
                          Text('299 ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.oOrange)),
                          Text(ar ? 'جهّز المبلغ عند وصول المندوب' : 'Prepare cash when courier arrives', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(ar ? '• قد تطبق رسوم خدمة بسيطة\n• تأكد من توفر المبلغ بالضبط' : '• Small service fee may apply\n• Ensure exact amount is ready', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2, height: 1.8)),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تأكيد الطلب' : 'Confirm order',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () => context.push(AppRoutes.orderConfirmation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
