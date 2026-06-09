import 'package:flutter/material.dart';

import '../../../../core/screens/kayan_screen_registry.dart';
import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_colors.dart';
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
        'screen_${e.number}': AdminDataService.instance
            .isScreenVisible('screen_${e.number}'),
    };
  }

  Future<void> _save() async {
    await AdminDataService.instance.saveScreenVisibility(_visibility);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ إظهار الشاشات')),
      );
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
              itemCount: kayanScreenRegistry.length,
              itemBuilder: (_, i) {
                final e = kayanScreenRegistry[i];
                final key = 'screen_${e.number}';
                return SwitchListTile(
                  title: Text('${e.number}. ${e.nameAr}',
                      style: const TextStyle(fontSize: 13)),
                  subtitle: Text(e.section,
                      style: TextStyle(color: AppColors.lightSubtext)),
                  value: _visibility[key] ?? true,
                  onChanged: (v) =>
                      setState(() => _visibility[key] = v),
                );
              },
            ),
          ),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.pepsiBlue,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('حفظ التغييرات'),
          ),
        ],
      ),
    );
  }
}
