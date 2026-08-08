import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../providers/delivery_providers.dart';

/// Matches design/html/94-or-restaurant-details.html
class DeliveryVendorDetailScreen extends ConsumerWidget {
  const DeliveryVendorDetailScreen({super.key, required this.vendorSlug});

  final String vendorSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final vendor = ref.watch(deliveryVendorProvider(vendorSlug));
    final cart = ref.read(deliveryCartProvider.notifier);

    if (vendor == null) {
      return Scaffold(
        appBar: AppBar(title: Text(ar ? 'غير موجود' : 'Not found')),
        body: Center(child: Text(ar ? 'المتجر غير متاح' : 'Vendor unavailable')),
      );
    }

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: vendor.name(ar),
            variant: KayanSectionHeroVariant.redOrange,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.pop(),
            ),
            trailing: KayanHeroIconButton(
              icon: Icons.shopping_cart_outlined,
              onTap: () => context.push(AppRoutes.deliveryCart),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: KayanDesignTokens.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: KayanDesignTokens.gold, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${vendor.rating} (${vendor.reviewCount})',
                        style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.schedule_rounded, color: KayanDesignTokens.muted, size: 16),
                      const SizedBox(width: 4),
                      Text(vendor.eta(ar), style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                KayanSectionHeader(title: ar ? 'القائمة' : 'Menu'),
                const SizedBox(height: 12),
                ...vendor.menu.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: KayanDesignTokens.border),
                      boxShadow: KayanDesignTokens.shadowS,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: KayanDesignTokens.gradDeliveryOrange,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(item.icon, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name(ar), style: KayanDesignTokens.cairo(fontSize: 14.5, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                              const SizedBox(height: 4),
                              Text(
                                item.description(ar),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.text2),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${item.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                                style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: KayanDesignTokens.oOrange),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => context.push(AppRoutes.deliveryItemPath(vendorSlug, item.id)),
                              icon: const Icon(Icons.info_outline_rounded, color: KayanDesignTokens.kBlue),
                            ),
                            GestureDetector(
                              onTap: () => cart.addItem(vendor, item),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  gradient: KayanDesignTokens.gradDeliveryOrange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: KayanDesignPrimaryButton(
            label: ar ? 'عرض السلة' : 'View cart',
            onPressed: () => context.push(AppRoutes.deliveryCart),
          ),
        ),
      ),
    );
  }
}
