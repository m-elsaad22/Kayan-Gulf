import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_colors.dart';
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
  }

  @override
  void dispose() {
    _primary.dispose();
    _accent.dispose();
    _gold.dispose();
    _turquoise.dispose();
    super.dispose();
  }

  Color _parse(String hex) {
    try {
      return AppColors.fromHex(hex.replaceFirst('#', ''));
    } catch (_) {
      return AppColors.royalBlue;
    }
  }

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
        children: [
          _colorField('اللون الأساسي', _primary),
          _colorField('لون التمييز', _accent),
          _colorField('الذهبي', _gold),
          _colorField('الفيروزي', _turquoise),
          const SizedBox(height: 16),
          Row(
            children: [
              _swatch(_parse(_primary.text)),
              _swatch(_parse(_accent.text)),
              _swatch(_parse(_gold.text)),
              _swatch(_parse(_turquoise.text)),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(backgroundColor: AppColors.pepsiBlue),
            child: const Text('حفظ الألوان'),
          ),
        ],
      ),
    );
  }

  Widget _colorField(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: label,
            hintText: '#0A2B5E',
            border: const OutlineInputBorder(),
          ),
        ),
      );

  Widget _swatch(Color color) => Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.silver),
        ),
      );
}
