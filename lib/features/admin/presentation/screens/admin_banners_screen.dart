import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
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
    _controllers = urls.map((u) => TextEditingController(text: u)).toList();
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
    final urls = _controllers.map((c) => c.text.trim()).where((u) => u.isNotEmpty).toList();
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
        padding: const EdgeInsets.all(12),
        children: [
          Text('روابط البانرات', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
          const SizedBox(height: 10),
          ..._controllers.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: KayanDesignTextField(
                label: 'البانر ${e.key + 1}',
                controller: e.value,
                hint: 'https://...',
                icon: Icons.image_outlined,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => setState(() => _controllers.add(TextEditingController())),
            icon: const Icon(Icons.add_rounded),
            label: const Text('إضافة بانر'),
          ),
          const SizedBox(height: 16),
          KayanCtaButton(
            label: 'حفظ البانرات',
            variant: KayanCtaVariant.blue,
            trailingIcon: Icons.save_rounded,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
