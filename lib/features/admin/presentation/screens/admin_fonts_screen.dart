import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../widgets/admin_scaffold.dart';

class AdminFontsScreen extends StatefulWidget {
  const AdminFontsScreen({super.key});

  @override
  State<AdminFontsScreen> createState() => _AdminFontsScreenState();
}

class _AdminFontsScreenState extends State<AdminFontsScreen> {
  double _title = 1.0;
  double _body = 1.0;
  double _caption = 1.0;

  @override
  void initState() {
    super.initState();
    final f = AdminDataService.instance.getFontSettings();
    _title = f.titleScale;
    _body = f.bodyScale;
    _caption = f.captionScale;
  }

  Future<void> _save() async {
    await AdminDataService.instance.saveFontSettings(
      AdminFontSettings(titleScale: _title, bodyScale: _body, captionScale: _caption),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ إعدادات الخط')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إعدادات الخطوط',
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _slider('حجم العناوين', _title, 18, (v) => setState(() => _title = v)),
          _slider('حجم النص', _body, 14, (v) => setState(() => _body = v)),
          _slider('حجم التسميات', _caption, 12, (v) => setState(() => _caption = v)),
          const SizedBox(height: 16),
          KayanCtaButton(label: 'حفظ الخطوط', variant: KayanCtaVariant.blue, trailingIcon: Icons.save_rounded, onPressed: _save),
        ],
      ),
    );
  }

  Widget _slider(String label, double value, double baseSize, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${value.toStringAsFixed(2)}x', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlueDeep)),
          Text('معاينة', style: KayanDesignTokens.cairo(fontSize: baseSize * value)),
          Slider(value: value, min: 0.8, max: 1.4, activeColor: KayanDesignTokens.kBlue, onChanged: onChanged),
        ],
      ),
    );
  }
}
