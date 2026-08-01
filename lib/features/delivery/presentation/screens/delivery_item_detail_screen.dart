import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../data/models/delivery_models.dart';
import '../providers/delivery_providers.dart';

/// Matches design/html/94b-or-item-details.html
class DeliveryItemDetailScreen extends ConsumerWidget {
  const DeliveryItemDetailScreen({
    super.key,
    required this.vendorSlug,
    required this.itemId,
  });

  final String vendorSlug;
  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final vendor = ref.watch(deliveryVendorProvider(vendorSlug));
    final cart = ref.read(deliveryCartProvider.notifier);

    DeliveryMenuItem? item;
    if (vendor != null) {
      for (final m in vendor.menu) {
        if (m.id == itemId) {
          item = m;
          break;
        }
      }
    }

    if (vendor == null || item == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('—')));
    }

    final resolvedVendor = vendor;
    final resolvedItem = item;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: KayanDesignTokens.kBlueDeep,
        elevation: 0,
        title: Text(resolvedItem.name(ar), style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: KayanDesignTokens.gradDeliveryOrange,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(resolvedItem.icon, size: 72, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(resolvedItem.name(ar), style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
            const SizedBox(height: 8),
            Text(resolvedItem.description(ar), style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.text2, height: 1.7)),
            const SizedBox(height: 16),
            Text(
              '${resolvedItem.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
              style: KayanDesignTokens.cairo(fontSize: 24, fontWeight: FontWeight.w900, color: KayanDesignTokens.oOrange),
            ),
            const Spacer(),
            KayanDesignPrimaryButton(
              label: ar ? 'أضف إلى السلة' : 'Add to cart',
              onPressed: () {
                cart.addItem(resolvedVendor, resolvedItem);
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
