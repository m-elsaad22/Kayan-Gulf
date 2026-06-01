// KAYAN — Boost Ad Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';

class BoostAdScreen extends ConsumerStatefulWidget {
  final String adId;
  const BoostAdScreen({super.key, required this.adId});
  @override ConsumerState<BoostAdScreen> createState() => _BAS();
}

class _BAS extends ConsumerState<BoostAdScreen> {
  int  _plan   = 1;
  bool _loading = false;

  final _plans = [
    (7,  25,  '3× مشاهدات', '3× Views', Icons.trending_up_rounded),
    (14, 45,  '5× مشاهدات', '5× Views', Icons.rocket_launch_rounded),
    (30, 75,  '10× مشاهدات','10× Views',Icons.star_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface, centerTitle: true,
        title: Text(ar ? 'تمييز الإعلان' : 'Boost Ad',
            style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.pagePadding), child: Column(children: [
        // Header
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppGradients.goldPremium, borderRadius: AppBorderRadius.card),
          child: Column(children: [
            const Text('⭐', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(ar ? 'بوّس إعلانك واحصل على مزيد من المشاهدات' : 'Boost your ad for more views and inquiries',
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.bgPrimary), textAlign: TextAlign.center),
          ])),

        const SizedBox(height: 24),

        // Plans
        Text(ar ? 'اختر خطة التمييز' : 'Choose Boost Plan',
            style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        const SizedBox(height: 12),
        ..._plans.asMap().entries.map((e) => GestureDetector(
          onTap: () => setState(() => _plan = e.key),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: _plan == e.key ? AppGradients.goldPremium : null,
              color:    _plan == e.key ? null : AppColors.bgCard,
              borderRadius: AppBorderRadius.card,
              border: Border.all(color: _plan == e.key ? Colors.transparent : AppColors.borderSubtle),
              boxShadow: _plan == e.key ? [BoxShadow(color: AppColors.metallicGold.withOpacity(0.3), blurRadius: 16)] : [],
            ),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: (_plan == e.key ? AppColors.bgPrimary : AppColors.metallicGold).withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(e.value.$5, color: _plan == e.key ? AppColors.bgPrimary : AppColors.metallicGold, size: 24)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${e.value.$1} ${ar ? "يوم" : "days"}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _plan == e.key ? AppColors.bgPrimary : AppColors.textPrimary)),
                Text(ar ? e.value.$3 : e.value.$4,
                    style: TextStyle(fontSize: 12, color: _plan == e.key ? AppColors.bgPrimary.withOpacity(0.7) : AppColors.textSecondary)),
              ])),
              Text('${e.value.$2} ${ar ? "ر.س" : "SAR"}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _plan == e.key ? AppColors.bgPrimary : AppColors.metallicGold)),
            ])),
        )),

        const SizedBox(height: 24),

        // Stats comparison
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
          child: Column(children: [
            Text(ar ? 'مع التمييز تحصل على:' : 'With Boost you get:', style: ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
            const SizedBox(height: 12),
            ...[
              ('📍', ar ? 'ظهور في أعلى نتائج البحث' : 'Top placement in search results'),
              ('🔔', ar ? 'إشعار للمهتمين بفئتك' : 'Notification to interested users'),
              ('🏆', ar ? 'شارة "مميز" على إعلانك' : '"Featured" badge on your ad'),
              ('📊', ar ? 'تقارير مفصلة للمشاهدات' : 'Detailed view analytics'),
            ].map((f) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
              Text(f.$1, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Text(f.$2, style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary)),
            ]))),
          ])),

        const SizedBox(height: 24),

        // Pay button
        GestureDetector(
          onTap: _loading ? null : () async {
            setState(() => _loading = true);
            await Future.delayed(const Duration(seconds: 2));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ar ? 'تم تمييز الإعلان بنجاح! ⭐' : 'Ad boosted successfully! ⭐'),
                backgroundColor: AppColors.metallicGold,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
              ));
              context.pop();
            }
          },
          child: Container(height: 54, decoration: BoxDecoration(gradient: AppGradients.goldButton, borderRadius: AppBorderRadius.button,
              boxShadow: [BoxShadow(color: AppColors.metallicGold.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))]),
            child: Center(child: _loading
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
              : Text('${ar ? "ادفع الآن •" : "Pay Now •"} ${_plans[_plan].$2} ${ar ? "ر.س" : "SAR"}',
                  style: (ar ? AppTextStyles.arabicButton : AppTextStyles.buttonLarge).copyWith(color: AppColors.bgPrimary)))),
        ),
      ])),
    );
  }
}
