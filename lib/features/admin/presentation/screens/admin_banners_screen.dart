import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/admin_scaffold.dart';

class AdminBannersScreen extends StatefulWidget {
  const AdminBannersScreen({super.key});

  @override
  State<AdminBannersScreen> createState() => _AdminBannersScreenState();
}

class _AdminBannersScreenState extends State<AdminBannersScreen> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final urls = AdminDataService.instance.getBannerUrls();
    _controllers = urls
        .map((u) => TextEditingController(text: u))
        .toList();
    if (_controllers.isEmpty) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final urls = _controllers
        .map((c) => c.text.trim())
        .where((u) => u.isNotEmpty)
        .toList();
    await AdminDataService.instance.saveBanners(urls);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ البانرات')),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إدارة البانرات',
      body: ListView(
        children: [
          ..._controllers.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: e.value,
                decoration: InputDecoration(
                  labelText: 'رابط البانر ${e.key + 1}',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => setState(
              () => _controllers.add(TextEditingController()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('إضافة بانر'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.pepsiBlue,
            ),
            child: const Text('حفظ البانرات'),
          ),
        ],
      ),
    );
  }
}
