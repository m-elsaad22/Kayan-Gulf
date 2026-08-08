import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../widgets/admin_scaffold.dart';

class AdminColorsScreen extends StatefulWidget {
  const AdminColorsScreen({super.key});

  @override
  State<AdminColorsScreen> createState() => _AdminColorsScreenState();
}

class _AdminColorsScreenState extends State<AdminColorsScreen> {
  late TextEditingController _primary;
  late TextEditingController _accent;
  late TextEditingController _gold;
  late TextEditingController _turquoise;

  @override
  void initState() {
    super.initState();
    final c = AdminDataService.instance.getThemeColors();
    _primary = TextEditingController(text: c.primaryHex);
    _accent = TextEditingController(text: c.accentHex);
    _gold = TextEditingController(text: c.goldHex);
    _turquoise = TextEditingController(text: c.turquoiseHex);
    for (final c in [_primary, _accent, _gold, _turquoise]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _primary.dispose();
    _accent.dispose();
    _gold.dispose();
    _turquoise.dispose();
    super.dispose();
  }

  Color _parse(String hex) => KayanDesignTokens.colorFromHex(hex);

  Future<void> _save() async {
    await AdminDataService.instance.saveThemeColors(
      AdminThemeColors(
        primaryHex: _primary.text.trim(),
        accentHex: _accent.text.trim(),
        goldHex: _gold.text.trim(),
        turquoiseHex: _turquoise.text.trim(),
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الألوان — ستنعكس فوراً')),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إعدادات الألوان',
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          KayanDesignTextField(label: 'اللون الأساسي', controller: _primary, hint: '#0A2B5E', icon: Icons.palette_outlined),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'لون التمييز', controller: _accent, hint: '#1E6FD9', icon: Icons.color_lens_outlined),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'الذهبي', controller: _gold, hint: '#C9A227', icon: Icons.star_outline_rounded),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'الفيروزي', controller: _turquoise, hint: '#00B4A0', icon: Icons.water_drop_outlined),
          const SizedBox(height: 16),
          Row(
            children: [
              _swatch(_parse(_primary.text)),
              _swatch(_parse(_accent.text)),
              _swatch(_parse(_gold.text)),
              _swatch(_parse(_turquoise.text)),
            ],
          ),
          const SizedBox(height: 20),
          KayanCtaButton(label: 'حفظ الألوان', variant: KayanCtaVariant.blue, trailingIcon: Icons.save_rounded, onPressed: _save),
        ],
      ),
    );
  }

  Widget _swatch(Color color) => Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: KayanDesignTokens.border),
        ),
      );
}
