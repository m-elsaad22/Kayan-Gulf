import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_colors.dart';
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
      AdminFontSettings(
        titleScale: _title,
        bodyScale: _body,
        captionScale: _caption,
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ إعدادات الخط')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إعدادات الخطوط',
      body: ListView(
        children: [
          Text('حجم العناوين: ${_title.toStringAsFixed(2)}x',
              style: TextStyle(fontSize: 18 * _title)),
          Slider(
            value: _title,
            min: 0.8,
            max: 1.4,
            onChanged: (v) => setState(() => _title = v),
          ),
          Text('حجم النص: ${_body.toStringAsFixed(2)}x',
              style: TextStyle(fontSize: 14 * _body)),
          Slider(
            value: _body,
            min: 0.8,
            max: 1.4,
            onChanged: (v) => setState(() => _body = v),
          ),
          Text('حجم التسميات: ${_caption.toStringAsFixed(2)}x',
              style: TextStyle(fontSize: 12 * _caption)),
          Slider(
            value: _caption,
            min: 0.8,
            max: 1.4,
            onChanged: (v) => setState(() => _caption = v),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(backgroundColor: AppColors.pepsiBlue),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
