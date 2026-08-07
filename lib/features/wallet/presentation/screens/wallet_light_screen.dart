// Wallet — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../profile/presentation/widgets/kayan_profile_widgets.dart';

class WalletLightScreen extends ConsumerWidget {
  const WalletLightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'المحفظة' : 'Wallet',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: KayanDesignTokens.gradBlue, borderRadius: BorderRadius.circular(20), boxShadow: KayanDesignTokens.shadowM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ar ? 'الرصيد المتاح' : 'Available balance', style: KayanDesignTokens.cairo(fontSize: 13, color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text('250 ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(ar ? '1,840 نقطة ولاء' : '1,840 loyalty points', style: KayanDesignTokens.cairo(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _ActionChip(icon: Icons.add_rounded, label: ar ? 'شحن' : 'Top up', onTap: () {})),
                    const SizedBox(width: 8),
                    Expanded(child: _ActionChip(icon: Icons.swap_horiz_rounded, label: ar ? 'تحويل' : 'Transfer', onTap: () => context.push(AppRoutes.transferPoints))),
                  ],
                ),
                const SizedBox(height: 20),
                KayanSectionHeader(title: ar ? 'آخر العمليات' : 'Recent transactions'),
                const SizedBox(height: 10),
                _TxnRow(ar: ar, title: ar ? 'استرداد طلب' : 'Order refund', amount: '+150', credit: true),
                _TxnRow(ar: ar, title: ar ? 'دفع طلب' : 'Order payment', amount: '-299', credit: false),
                _TxnRow(ar: ar, title: ar ? 'شحن المحفظة' : 'Wallet top-up', amount: '+500', credit: true),
                const SizedBox(height: 16),
                KayanProfileMenuTile(icon: Icons.history_rounded, title: ar ? 'سجل العمليات' : 'Transaction history', onTap: () => context.push(AppRoutes.earningsHistory)),
                KayanProfileMenuTile(icon: Icons.account_balance_rounded, title: ar ? 'سحب الأرباح' : 'Withdraw earnings', onTap: () => context.push(AppRoutes.withdrawEarnings)),
                KayanProfileMenuTile(icon: Icons.receipt_long_rounded, title: ar ? 'إيصال الدفع' : 'Payment receipt', onTap: () => context.push(AppRoutes.paymentReceipt)),
                KayanProfileMenuTile(icon: Icons.redeem_rounded, title: ar ? 'استبدال النقاط' : 'Redeem points', onTap: () => context.push(AppRoutes.redeemPoints)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KayanDesignTokens.border)),
        child: Column(children: [Icon(icon, color: KayanDesignTokens.kBlue), const SizedBox(height: 4), Text(label, style: KayanDesignTokens.cairo(fontSize: 11, fontWeight: FontWeight.w700))]),
      ),
    );
  }
}

class _TxnRow extends StatelessWidget {
  const _TxnRow({required this.ar, required this.title, required this.amount, required this.credit});
  final bool ar;
  final String title;
  final String amount;
  final bool credit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlueDeep))),
          Text(amount, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w900, color: credit ? KayanDesignTokens.kGreen : KayanDesignTokens.danger)),
        ],
      ),
    );
  }
}
