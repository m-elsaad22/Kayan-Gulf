import 'package:flutter/material.dart';

import '../../../../core/screens/kayan_screen_registry.dart';
import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../widgets/admin_scaffold.dart';

class AdminScreensScreen extends StatefulWidget {
  const AdminScreensScreen({super.key});

  @override
  State<AdminScreensScreen> createState() => _AdminScreensScreenState();
}

class _AdminScreensScreenState extends State<AdminScreensScreen> {
  late Map<String, bool> _visibility;

  @override
  void initState() {
    super.initState();
    _visibility = {
      for (final e in kayanScreenRegistry)
        'screen_${e.number}': AdminDataService.instance.isScreenVisible('screen_${e.number}'),
    };
  }

  Future<void> _save() async {
    await AdminDataService.instance.saveScreenVisibility(_visibility);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ إظهار الشاشات')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إدارة الشاشات',
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: kayanScreenRegistry.length,
              itemBuilder: (_, i) {
                final e = kayanScreenRegistry[i];
                final key = 'screen_${e.number}';
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                    border: Border.all(color: KayanDesignTokens.border),
                  ),
                  child: SwitchListTile(
                    title: Text('${e.number}. ${e.nameAr}', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700)),
                    subtitle: Text(e.section, style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted)),
                    value: _visibility[key] ?? true,
                    activeColor: KayanDesignTokens.kBlue,
                    onChanged: (v) => setState(() => _visibility[key] = v),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: KayanCtaButton(label: 'حفظ التغييرات', variant: KayanCtaVariant.blue, trailingIcon: Icons.save_rounded, onPressed: _save),
          ),
        ],
      ),
    );
  }
}
