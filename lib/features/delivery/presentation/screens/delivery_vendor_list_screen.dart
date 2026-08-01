import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../providers/delivery_providers.dart';

/// Matches design/html/93-or-restaurant-list.html
class DeliveryVendorListScreen extends ConsumerWidget {
  const DeliveryVendorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final vendors = ref.watch(deliveryVendorsProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'المطاعم والمتاجر' : 'Restaurants & Stores',
            variant: KayanSectionHeroVariant.redOrange,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.pop(),
            ),
            searchHint: ar ? 'ابحث...' : 'Search...',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: vendors
                  .map(
                    (v) => KayanVendorCard(
                      name: v.name(ar),
                      rating: v.rating,
                      reviews: v.reviewCount,
                      eta: v.eta(ar),
                      isOpen: v.isOpen,
                      deliveryLabel: v.deliveryFee(ar),
                      icon: v.icon,
                      onTap: () => context.push(AppRoutes.deliveryVendorPath(v.slug)),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
