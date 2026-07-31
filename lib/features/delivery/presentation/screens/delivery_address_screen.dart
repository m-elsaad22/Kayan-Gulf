import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// Matches design/html/96-or-address.html
class DeliveryAddressScreen extends ConsumerStatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  ConsumerState<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends ConsumerState<DeliveryAddressScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final addresses = ar
        ? ['المنزل — حي النرجس، الرياض', 'العمل — طريق الملك فهد']
        : ['Home — Al Narjis, Riyadh', 'Work — King Fahd Road'];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: KayanDesignTokens.kBlueDeep,
        elevation: 0,
        title: Text(ar ? 'عنوان التوصيل' : 'Delivery address', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ...List.generate(addresses.length, (i) {
            final selected = _selected == i;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected ? KayanDesignTokens.oOrange : KayanDesignTokens.border, width: selected ? 2 : 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: selected ? KayanDesignTokens.oOrange : KayanDesignTokens.kBlue),
                    const SizedBox(width: 12),
                    Expanded(child: Text(addresses[i], style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700))),
                    Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? KayanDesignTokens.oOrange : KayanDesignTokens.muted),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
            label: Text(ar ? 'إضافة عنوان جديد' : 'Add new address'),
            style: OutlinedButton.styleFrom(
              foregroundColor: KayanDesignTokens.kBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: KayanDesignTokens.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: KayanDesignPrimaryButton(
            label: ar ? 'متابعة للدفع' : 'Continue to payment',
            onPressed: () => context.push(AppRoutes.deliveryPayment),
          ),
        ),
      ),
    );
  }
}
