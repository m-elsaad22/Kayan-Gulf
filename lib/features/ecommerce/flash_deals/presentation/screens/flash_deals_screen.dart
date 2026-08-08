// Flash deals — light design
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../features/home/presentation/providers/home_providers.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

class FlashDealsScreen extends ConsumerStatefulWidget {
  const FlashDealsScreen({super.key});

  @override
  ConsumerState<FlashDealsScreen> createState() => _FlashDealsScreenState();
}

class _FlashDealsScreenState extends ConsumerState<FlashDealsScreen> {
  int _secs = 7234;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _secs > 0) setState(() => _secs--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  IconData _productIcon(String id) {
    const icons = [
      Icons.spa_rounded,
      Icons.smartphone_rounded,
      Icons.shopping_bag_rounded,
      Icons.checkroom_rounded,
      Icons.diamond_rounded,
    ];
    return icons[id.hashCode.abs() % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final h = _secs ~/ 3600;
    final m = (_secs % 3600) ~/ 60;
    final s = _secs % 60;
    final countdown = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    final homeAsync = ref.watch(homeDataProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'صفقات اليوم' : 'Flash deals',
            variant: KayanSectionHeroVariant.orange,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.pop(),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flash_on_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    countdown,
                    style: KayanDesignTokens.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: KayanDesignTokens.danger,
            child: Text(
              ar ? 'ينتهي العرض خلال $countdown' : 'Ends in $countdown',
              textAlign: TextAlign.center,
              style: KayanDesignTokens.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: homeAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Text(ar ? 'تعذّر التحميل' : 'Load failed', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
              ),
              data: (home) {
                final deals = home.flashDeals;
                if (deals.isEmpty) {
                  return Center(
                    child: Text(ar ? 'لا توجد عروض حالياً' : 'No deals right now', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  children: deals.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: KayanClassifiedAdCard(
                        title: ar ? product.nameAr : product.nameEn,
                        locationLine: ar ? 'عرض محدود' : 'Limited offer',
                        priceLabel: '${product.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                        icon: _productIcon(product.id),
                        isFeatured: true,
                        featuredLabel: ar ? 'فلاش' : 'Flash',
                        accentGradient: KayanDesignTokens.gradOrange,
                        priceColor: KayanDesignTokens.oOrange,
                        onTap: () => context.push(AppRoutes.productPath(product.slug)),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
