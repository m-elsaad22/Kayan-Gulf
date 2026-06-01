// ============================================================
// KAYAN — Wallet Screen
// lib/features/wallet/presentation/screens/wallet_screen.dart
//
// Features:
//   • Balance hero card with gradient + gold shimmer
//   • Quick actions: Top Up, Transfer, Pay, History
//   • Transaction list with category icons and colored amounts
//   • Loyalty points section
//   • Referral bonus card
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/providers/locale_provider.dart';

// ── Transaction Model ─────────────────────────────────────────
class _Txn {
  final String   id, titleAr, titleEn, icon;
  final double   amount;
  final bool     isCredit;
  final DateTime date;
  final String   statusAr, statusEn;
  const _Txn({
    required this.id, required this.titleAr, required this.titleEn,
    required this.icon, required this.amount, required this.isCredit,
    required this.date, this.statusAr = 'مكتمل', this.statusEn = 'Completed',
  });
}

final _transactions = [
  _Txn(id:'t1', titleAr:'استرداد طلب', titleEn:'Order Refund', icon:'↩️',
      amount:150, isCredit:true, date:DateTime.now().subtract(const Duration(hours:2))),
  _Txn(id:'t2', titleAr:'دفع طلب KYN-7836', titleEn:'Order KYN-7836', icon:'🛒',
      amount:299, isCredit:false, date:DateTime.now().subtract(const Duration(days:1))),
  _Txn(id:'t3', titleAr:'شحن المحفظة', titleEn:'Wallet Top Up', icon:'💳',
      amount:500, isCredit:true, date:DateTime.now().subtract(const Duration(days:2))),
  _Txn(id:'t4', titleAr:'مكافأة الإحالة', titleEn:'Referral Reward', icon:'🎁',
      amount:25, isCredit:true, date:DateTime.now().subtract(const Duration(days:3))),
  _Txn(id:'t5', titleAr:'دفع خدمة تكييف', titleEn:'AC Service Payment', icon:'❄️',
      amount:120, isCredit:false, date:DateTime.now().subtract(const Duration(days:5))),
  _Txn(id:'t6', titleAr:'كاشباك مشتريات', titleEn:'Purchase Cashback', icon:'💰',
      amount:18, isCredit:true, date:DateTime.now().subtract(const Duration(days:7))),
];

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Text(isArabic ? 'محفظة كيان' : 'KAYAN Wallet',
            style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(
          icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop()),
        actions: [
          IconButton(icon: const Icon(Icons.history_rounded, size: 22), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Balance Card ──────────────────────────────
          _BalanceCard(isArabic: isArabic),

          const SizedBox(height: 20),

          // ── Quick Actions ─────────────────────────────
          _QuickActions(isArabic: isArabic),

          const SizedBox(height: 24),

          // ── Loyalty Points ────────────────────────────
          _LoyaltyCard(isArabic: isArabic),

          const SizedBox(height: 20),

          // ── Referral ──────────────────────────────────
          _ReferralCard(isArabic: isArabic),

          const SizedBox(height: 24),

          // ── Transactions ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Row(children: [
              Container(width: 3, height: 18, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(isArabic ? 'آخر المعاملات' : 'Recent Transactions',
                  style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
              const Spacer(),
              Text(isArabic ? 'عرض الكل' : 'See All', style: AppTextStyles.seeAll),
            ]),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Container(
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
              child: Column(children: _transactions.asMap().entries.map((e) =>
                Column(children: [
                  _TxnTile(txn: e.value, isArabic: isArabic),
                  if (e.key < _transactions.length - 1)
                    const Padding(padding: EdgeInsets.only(left: 68), child: Divider(height: 1, color: AppColors.borderSubtle)),
                ])).toList()),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Balance Card ──────────────────────────────────────────────
class _BalanceCard extends StatefulWidget {
  final bool isArabic;
  const _BalanceCard({required this.isArabic});
  @override State<_BalanceCard> createState() => _BCState();
}
class _BCState extends State<_BalanceCard> with SingleTickerProviderStateMixin {
  bool _hidden = false;
  late AnimationController _shimmer;
  late Animation<double>   _sx;
  @override void initState() { super.initState(); _shimmer = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(); _sx = Tween<double>(begin: -1.5, end: 2.5).animate(CurvedAnimation(parent: _shimmer, curve: Curves.easeInOut)); }
  @override void dispose() { _shimmer.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ar = widget.isArabic;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF0A1F3B), Color(0xFF1A3A6E), Color(0xFF0E2444)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
        ),
        child: Stack(children: [
          // Gold shimmer sweep
          AnimatedBuilder(animation: _sx, builder: (_, __) => Positioned.fill(child: Container(decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [Colors.transparent, AppColors.gold.withOpacity(0.04), AppColors.gold.withOpacity(0.08), AppColors.gold.withOpacity(0.04), Colors.transparent],
                stops: const [0, 0.3, 0.5, 0.7, 1],
                begin: Alignment(_sx.value - 1, 0), end: Alignment(_sx.value + 1, 0)))))),
          // Content
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.account_balance_wallet_rounded, color: AppColors.gold, size: 20),
              const SizedBox(width: 8),
              Text(ar ? 'محفظة كيان' : 'KAYAN Wallet', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              GestureDetector(onTap: () => setState(() => _hidden = !_hidden), child: Icon(_hidden ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textMuted, size: 18)),
            ]),
            const SizedBox(height: 12),
            Text(ar ? 'الرصيد المتاح' : 'Available Balance', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              _hidden
                  ? Container(width: 120, height: 36, decoration: BoxDecoration(color: AppColors.bgCard2, borderRadius: BorderRadius.circular(8)))
                  : ShaderMask(shaderCallback: (b) => AppGradients.goldPremium.createShader(b),
                      child: const Text('250.00', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white))),
              const SizedBox(width: 8),
              Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(ar ? 'ر.س' : 'SAR', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold))),
            ]),
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.borderGold),
            const SizedBox(height: 12),
            Row(children: [
              _BalanceStat(ar ? 'إجمالي المشحون' : 'Total Loaded', '1,250 ${ar?"ر.س":"SAR"}'),
              const SizedBox(width: 24),
              _BalanceStat(ar ? 'إجمالي المنفق' : 'Total Spent', '1,000 ${ar?"ر.س":"SAR"}'),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.success.withOpacity(0.3))),
                child: Text(ar ? '✓ نشط' : '✓ Active', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success))),
            ]),
          ]),
        ]),
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label, value;
  const _BalanceStat(this.label, this.value);
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 9)),
    Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
  ]);
}

// ── Quick Actions ─────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  final bool isArabic;
  const _QuickActions({required this.isArabic});
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.add_rounded,             isArabic?'شحن':'Top Up',      AppColors.royalBlue),
      (Icons.send_rounded,            isArabic?'تحويل':'Transfer',   AppColors.categoryTeal),
      (Icons.qr_code_rounded,         isArabic?'دفع':'Pay',          AppColors.categoryPurple),
      (Icons.receipt_long_rounded,    isArabic?'السجل':'History',    AppColors.categoryOrange),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Row(children: actions.map((a) => Expanded(child: GestureDetector(
        onTap: () => HapticFeedback.lightImpact(),
        child: Column(children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(color: a.$3.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: a.$3.withOpacity(0.25))),
              child: Icon(a.$1, size: 24, color: a.$3)),
          const SizedBox(height: 6),
          Text(a.$2, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
        ]),
      ))).toList()),
    );
  }
}

// ── Loyalty Card ──────────────────────────────────────────────
class _LoyaltyCard extends StatelessWidget {
  final bool isArabic;
  const _LoyaltyCard({required this.isArabic});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: AppGradients.card, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderGold)),
      child: Column(children: [
        Row(children: [
          const Text('⭐', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isArabic ? 'نقاط الولاء' : 'Loyalty Points', style: AppTextStyles.titleSmall),
            Text(isArabic ? 'المستوى: ذهبي 🥇' : 'Level: Gold 🥇', style: AppTextStyles.caption.copyWith(color: AppColors.metallicGold)),
          ]),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('1,840', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.metallicGold)),
            Text(isArabic ? 'نقطة' : 'points', style: AppTextStyles.caption),
          ]),
        ]),
        const SizedBox(height: 14),
        // Progress to next tier
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(isArabic ? 'التقدم نحو البلاتينيوم' : 'Progress to Platinum', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
            const Text('1,840 / 5,000', style: TextStyle(fontSize: 10, color: AppColors.metallicGold, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 1840/5000, minHeight: 6, backgroundColor: AppColors.bgCard2, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.metallicGold))),
          const SizedBox(height: 4),
          Text(isArabic ? 'تحتاج 3,160 نقطة للوصول إلى البلاتينيوم 💎' : '3,160 more points to reach Platinum 💎', style: AppTextStyles.caption.copyWith(fontSize: 9, color: AppColors.textMuted)),
        ]),
        const SizedBox(height: 12),
        // Redeem button
        GestureDetector(
          onTap: () {},
          child: Container(height: 38, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(isArabic ? 'استبدال النقاط' : 'Redeem Points',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.bgPrimary, fontWeight: FontWeight.w700)))),
        ),
      ]),
    ),
  );
}

// ── Referral Card ─────────────────────────────────────────────
class _ReferralCard extends StatelessWidget {
  final bool isArabic;
  const _ReferralCard({required this.isArabic});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: AppBorderRadius.card, boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))]),
      child: Row(children: [
        const Text('🎁', style: TextStyle(fontSize: 28)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(isArabic ? 'ادعُ صديقاً واحصل على 25 ر.س' : 'Refer a friend, get 25 SAR!',
              style: AppTextStyles.titleSmall),
          Text(isArabic ? 'وصديقك يحصل على 15 ر.س أيضاً' : 'Your friend gets 15 SAR too',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
        ])),
        GestureDetector(
          onTap: () { HapticFeedback.lightImpact(); Clipboard.setData(const ClipboardData(text: 'KAYAN-MAHMOUD')); },
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Column(children: [
              Text(isArabic ? 'كودك' : 'Your Code', style: const TextStyle(fontSize: 8, color: Colors.white70)),
              const Text('KAYAN-CODE', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ])),
        ),
      ]),
    ),
  );
}

// ── Transaction Tile ──────────────────────────────────────────
class _TxnTile extends StatelessWidget {
  final _Txn txn;
  final bool  isArabic;
  const _TxnTile({required this.txn, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final d = txn.date;
    final months = isArabic
        ? ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر']
        : ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final diff = DateTime.now().difference(d);
    final dateStr = diff.inDays == 0 ? (isArabic ? 'اليوم' : 'Today') :
                    diff.inDays == 1 ? (isArabic ? 'أمس'   : 'Yesterday') :
                    '${d.day} ${months[d.month-1]}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        // Icon
        Container(width: 42, height: 42, decoration: BoxDecoration(
          color: (txn.isCredit ? AppColors.success : AppColors.error).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(txn.icon, style: const TextStyle(fontSize: 20)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(isArabic ? txn.titleAr : txn.titleEn, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          Text(dateStr, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${txn.isCredit ? "+" : "-"}${txn.amount.toInt()} ${isArabic ? "ر.س" : "SAR"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                  color: txn.isCredit ? AppColors.success : AppColors.error)),
          Text(isArabic ? txn.statusAr : txn.statusEn, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
        ]),
      ]),
    );
  }
}

// extension for gold color in wallet card
extension on AppColors {
  static const Color gold = Color(0xFFD4AF37);
}
