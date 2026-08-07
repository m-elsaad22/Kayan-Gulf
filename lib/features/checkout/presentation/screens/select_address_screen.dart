import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// اختيار عنوان التوصيل — light design
class SelectAddressScreen extends ConsumerStatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  ConsumerState<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends ConsumerState<SelectAddressScreen> {
  int _selected = 0;

  static const _addresses = [
    ('المنزل', 'Home', 'حي النخيل، الرياض', 'Al Nakheel, Riyadh'),
    ('العمل', 'Work', 'حي العليا، الرياض', 'Olaya, Riyadh'),
  ];

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'اختيار العنوان' : 'Select address', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    for (var i = 0; i < _addresses.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: _selected == i ? KayanDesignTokens.kBlue.withValues(alpha: 0.06) : KayanDesignTokens.surface,
                          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                          child: InkWell(
                            onTap: () => setState(() => _selected = i),
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                                border: Border.all(color: _selected == i ? KayanDesignTokens.kBlue : KayanDesignTokens.border, width: _selected == i ? 1.5 : 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: KayanDesignTokens.kBlue),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(ar ? _addresses[i].$1 : _addresses[i].$2, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                        Text(ar ? _addresses[i].$3 : _addresses[i].$4, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                                      ],
                                    ),
                                  ),
                                  if (_selected == i) const Icon(Icons.check_circle_rounded, color: KayanDesignTokens.kBlue),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () => context.push(AppRoutes.checkoutAddAddress),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(ar ? 'إضافة عنوان جديد' : 'Add new address'),
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'متابعة' : 'Continue',
                trailingIcon: Icons.arrow_back_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () => context.push(AppRoutes.checkoutPaymentMethod),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
