// Service address — light design (28-hs-address.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class AddressEntryScreen extends ConsumerStatefulWidget {
  const AddressEntryScreen({super.key});

  @override
  ConsumerState<AddressEntryScreen> createState() => _AddressEntryScreenState();
}

class _AddressEntryScreenState extends ConsumerState<AddressEntryScreen> {
  final _districtCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _districtCtrl.dispose();
    _streetCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
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
              KayanLightTopBar(title: ar ? 'عنوان الخدمة' : 'Service address', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: KayanDesignTokens.bg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: KayanDesignTokens.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map_rounded, color: KayanDesignTokens.kGreen, size: 32),
                            const SizedBox(height: 8),
                            Text(ar ? 'حدد الموقع على الخريطة' : 'Pick location on map', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    KayanDesignTextField(label: ar ? 'الحي' : 'District', hint: ar ? 'مثال: النخيل' : 'e.g. Al Nakheel', icon: Icons.location_city_rounded, controller: _districtCtrl),
                    const SizedBox(height: 16),
                    KayanDesignTextField(label: ar ? 'الشارع' : 'Street', hint: ar ? 'اسم الشارع' : 'Street name', icon: Icons.signpost_rounded, controller: _streetCtrl),
                    const SizedBox(height: 16),
                    KayanDesignTextField(label: ar ? 'تعليمات الوصول' : 'Access notes', hint: ar ? 'رقم الشقة، البوابة...' : 'Apt, gate...', icon: Icons.notes_rounded, controller: _notesCtrl),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'متابعة' : 'Continue',
                trailingIcon: Icons.arrow_back_rounded,
                variant: KayanCtaVariant.green,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
