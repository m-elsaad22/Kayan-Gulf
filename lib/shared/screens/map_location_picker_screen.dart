import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/widgets/design/kayan_design_widgets.dart';
import '../../shared/widgets/design/kayan_entry_widgets.dart';

/// اختيار الموقع على الخريطة — light design
class MapLocationPickerScreen extends ConsumerStatefulWidget {
  const MapLocationPickerScreen({super.key});

  @override
  ConsumerState<MapLocationPickerScreen> createState() => _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends ConsumerState<MapLocationPickerScreen> {
  final _addressCtrl = TextEditingController(text: 'الرياض، حي النرجس، شارع الأمير سلطان');

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'اختيار الموقع' : 'Pick location', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: KayanDesignTokens.kGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: KayanDesignTokens.border),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.map_rounded, size: 64, color: KayanDesignTokens.kGreen),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: KayanDesignTokens.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: KayanDesignTokens.kBlue),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_addressCtrl.text, style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              KayanDesignTextField(
                label: ar ? 'العنوان التفصيلي' : 'Detailed address',
                controller: _addressCtrl,
                hint: ar ? 'الحي، الشارع، رقم المبنى' : 'District, street, building',
                icon: Icons.edit_location_alt_outlined,
              ),
              const SizedBox(height: 12),
              KayanCtaButton(
                label: ar ? 'تأكيد الموقع' : 'Confirm location',
                variant: KayanCtaVariant.green,
                trailingIcon: Icons.check_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم حفظ الموقع' : 'Location saved')),
                  );
                  context.pop(_addressCtrl.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
