// ============================================================
// KAYAN — Add Address Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/premium/premium_widgets.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _label = TextEditingController(text: 'Home');
  final _city = TextEditingController(text: 'Riyadh');
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
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          Directionality.of(context) == TextDirection.rtl
              ? 'تم حفظ العنوان'
              : 'Address saved',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ar = Directionality.of(context) == TextDirection.rtl;
    return PremiumScaffold(
      title: ar ? 'إضافة عنوان' : 'Add Address',
      subtitle: ar ? 'عنوان دقيق لتوصيل أسرع' : 'Precise address for faster delivery',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GlassPanel(
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.royalBlue.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderActive),
                    ),
                    child: const Icon(Icons.location_on_rounded, color: AppColors.royalBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ar
                          ? 'أضف تفاصيل العنوان كما تظهر على بوابة المبنى أو الخريطة.'
                          : 'Add details as they appear on the building entrance or map.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GlassPanel(
              child: Column(
                children: [
                  _Field(controller: _label, label: ar ? 'اسم العنوان' : 'Address label', icon: Icons.bookmark_rounded),
                  const SizedBox(height: 12),
                  _Field(controller: _city, label: ar ? 'المدينة' : 'City', icon: Icons.location_city_rounded),
                  const SizedBox(height: 12),
                  _Field(controller: _district, label: ar ? 'الحي' : 'District', icon: Icons.map_rounded),
                  const SizedBox(height: 12),
                  _Field(controller: _street, label: ar ? 'الشارع' : 'Street', icon: Icons.signpost_rounded),
                  const SizedBox(height: 12),
                  _Field(controller: _building, label: ar ? 'رقم المبنى' : 'Building number', icon: Icons.apartment_rounded, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _Field(controller: _notes, label: ar ? 'ملاحظات اختيارية' : 'Optional notes', icon: Icons.notes_rounded, required: false, maxLines: 3),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _defaultAddress,
                    onChanged: (v) => setState(() => _defaultAddress = v),
                    title: Text(ar ? 'اجعله العنوان الافتراضي' : 'Set as default address', style: AppTextStyles.bodyMedium),
                    subtitle: Text(ar ? 'سيستخدم في الطلبات والحجوزات القادمة' : 'Used for upcoming orders and bookings', style: AppTextStyles.caption),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PremiumActionButton(
              label: _saving ? (ar ? 'جار الحفظ...' : 'Saving...') : (ar ? 'حفظ العنوان' : 'Save Address'),
              icon: Icons.check_rounded,
              onTap: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool required;
  final int maxLines;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.required = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: required
          ? (value) => value == null || value.trim().isEmpty ? label : null
          : null,
      decoration: InputDecoration(prefixIcon: Icon(icon), labelText: label),
    );
  }
}
