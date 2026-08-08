import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إدارة الاشتراك — light design
class ManageSubscriptionScreen extends ConsumerWidget {
  const ManageSubscriptionScreen({super.key});

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
              KayanLightTopBar(title: ar ? 'إدارة الاشتراك' : 'Manage subscription', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: KayanDesignTokens.gradGold,
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ar ? 'الخطة الحالية' : 'Current plan', style: KayanDesignTokens.cairo(color: const Color(0xFF402C00))),
                          Text('KAYAN Plus', style: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF402C00))),
                          Text(ar ? '29 ر.س / شهر' : '29 SAR / month', style: KayanDesignTokens.cairo(color: const Color(0xFF402C00).withValues(alpha: 0.85))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _RowCard(icon: Icons.event_repeat_rounded, title: ar ? 'التجديد القادم' : 'Next renewal', value: ar ? '28 أغسطس 2026' : 'Aug 28, 2026'),
                    _RowCard(icon: Icons.payment_rounded, title: ar ? 'طريقة الدفع' : 'Payment method', value: ar ? 'بطاقة •••• 4242' : 'Card •••• 4242'),
                    _RowCard(icon: Icons.local_offer_rounded, title: ar ? 'المزايا' : 'Benefits', value: ar ? 'شحن مجاني + أولوية دعم' : 'Free shipping + priority support'),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'إلغاء الاشتراك' : 'Cancel subscription',
                trailingIcon: Icons.close_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم إرسال طلب الإلغاء' : 'Cancellation requested')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  const _RowCard({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: KayanDesignTokens.bg,
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          border: Border.all(color: KayanDesignTokens.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: KayanDesignTokens.kBlue),
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
