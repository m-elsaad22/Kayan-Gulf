// Favorites — matches design/html/110-or-favorites.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../data/mock/delivery_mock_data.dart';
import '../../data/models/delivery_models.dart';

class DeliveryFavoritesScreen extends ConsumerWidget {
  const DeliveryFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final favorites = mockDeliveryFavoriteSlugs
        .map(findDeliveryVendor)
        .whereType<DeliveryVendor>()
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'المفضلة' : 'Favorites', onBack: () => context.pop()),
              const SizedBox(height: 10),
              Expanded(
                child: favorites.isEmpty
                    ? Center(child: Text(ar ? 'لا توجد مفضلات' : 'No favorites yet', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)))
                    : ListView(
                        children: favorites.map((v) {
                          return KayanVendorCard(
                            name: v.name(ar),
                            rating: v.rating,
                            reviews: v.reviewCount,
                            eta: v.eta(ar),
                            isOpen: v.isOpen,
                            deliveryLabel: v.deliveryFee(ar),
                            icon: v.icon,
                            onTap: () => context.push(AppRoutes.deliveryVendorPath(v.slug)),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
