// KAYAN — Flash Deals Screen
import 'dart:async';
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
import '../../../../../shared/widgets/cards/product_card.dart';
import '../../../../../features/home/data/models/home_models.dart';
import '../../../../../features/home/presentation/providers/home_providers.dart';

class FlashDealsScreen extends ConsumerStatefulWidget {
  const FlashDealsScreen({super.key});
  @override ConsumerState<FlashDealsScreen> createState() => _FDS();
}

class _FDS extends ConsumerState<FlashDealsScreen> {
  int _secs = 7234;
  Timer? _t;
  @override void initState() { super.initState(); _t = Timer.periodic(const Duration(seconds:1), (_) { if(mounted&&_secs>0)setState(()=>_secs--); }); }
  @override void dispose() { _t?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ar    = ref.watch(isArabicProvider);
    final h = _secs~/ 3600; final m = (_secs%3600)~/60; final s = _secs%60;
    final homeAsync = ref.watch(homeDataProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface, centerTitle: true,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const Text('⚡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(ar ? 'صفقات اليوم' : 'Flash Deals', style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        ]),
        leading: IconButton(icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      ),
      body: Column(children: [
        // Countdown header
        Container(padding: const EdgeInsets.symmetric(vertical: 12), color: AppColors.error,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(ar ? 'ينتهي العرض خلال: ' : 'Ends in: ', style: const TextStyle(color: Colors.white, fontSize: 13)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(8)),
              child: Text('${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, fontFeatures: [FontFeature.tabularFigures()]))),
          ])),
        Expanded(child: homeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
          data: (home) => GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:0.65),
            itemCount: home.flashDeals.length,
            itemBuilder: (_, i) => ProductCard(product: home.flashDeals[i], showTimer: true, onTap: () => context.push(AppRoutes.productPath(home.flashDeals[i].slug))),
          ),
        )),
      ]),
    );
  }
}
