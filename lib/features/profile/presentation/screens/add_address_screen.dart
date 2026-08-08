import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إضافة عنوان — light design
class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _label = TextEditingController(text: 'المنزل');
  final _city = TextEditingController(text: 'الرياض');
  final _district = TextEditingController();
  final _street = TextEditingController();
  final _building = TextEditingController();
  final _notes = TextEditingController();
  bool _defaultAddress = true;
  bool _saving = false;

  @override
  void dispose() {
    _label.dispose();
    _city.dispose();
    _district.dispose();
    _street.dispose();
    _building.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_district.text.trim().isEmpty || _street.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إكمال الحي والشارع')),
      );
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ref.read(isArabicProvider) ? 'تم حفظ العنوان' : 'Address saved')),
    );
    context.pop();
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
              KayanLightTopBar(title: ar ? 'إضافة عنوان' : 'Add address', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: KayanDesignTokens.kBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        border: Border.all(color: KayanDesignTokens.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: KayanDesignTokens.kBlue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ar ? 'أضف تفاصيل العنوان كما تظهر على الخريطة' : 'Add address details as shown on the map',
                              style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    KayanDesignTextField(controller: _label, label: ar ? 'اسم العنوان' : 'Label', hint: ar ? 'المنزل' : 'Home', icon: Icons.bookmark_outline_rounded),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _city, label: ar ? 'المدينة' : 'City', icon: Icons.location_city_outlined),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _district, label: ar ? 'الحي' : 'District', icon: Icons.map_outlined),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _street, label: ar ? 'الشارع' : 'Street', icon: Icons.signpost_outlined),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _building, label: ar ? 'رقم المبنى' : 'Building', icon: Icons.apartment_outlined, keyboardType: TextInputType.number),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _notes, label: ar ? 'ملاحظات' : 'Notes', hint: ar ? 'رقم الشقة، البوابة...' : 'Apt, gate...', icon: Icons.notes_outlined),
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _defaultAddress,
                      onChanged: (v) => setState(() => _defaultAddress = v),
                      title: Text(ar ? 'العنوان الافتراضي' : 'Default address', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700)),
                      subtitle: Text(ar ? 'يُستخدم في الطلبات القادمة' : 'Used for upcoming orders', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'حفظ العنوان' : 'Save address',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.blue,
                loading: _saving,
                onPressed: _saving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
