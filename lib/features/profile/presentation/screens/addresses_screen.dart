// Addresses — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class _Address {
  const _Address({required this.id, required this.label, required this.line, this.isDefault = false});
  final String id;
  final String label;
  final String line;
  final bool isDefault;
}

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  late List<_Address> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = const [
      _Address(id: '1', label: 'المنزل', line: 'الرياض، حي النخيل، شارع الملك فهد', isDefault: true),
      _Address(id: '2', label: 'العمل', line: 'الرياض، حي العليا، برج المملكة'),
    ];
  }

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
              KayanLightTopBar(title: ar ? 'عناويني' : 'My addresses', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: _addresses.map((a) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: a.isDefault ? KayanDesignTokens.kBlue : KayanDesignTokens.border),
                        boxShadow: KayanDesignTokens.shadowS,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(a.label, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                              if (a.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: KayanDesignTokens.kBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(99)),
                                  child: Text(ar ? 'افتراضي' : 'Default', style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlue)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(a.line, style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              KayanCtaButton(
                label: ar ? 'إضافة عنوان' : 'Add address',
                trailingIcon: Icons.add_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () => context.push(AppRoutes.addAddress),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
