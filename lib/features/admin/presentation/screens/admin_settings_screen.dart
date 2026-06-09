import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../widgets/admin_scaffold.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  late AdminSettings _settings;
  late TextEditingController _appName;
  late TextEditingController _logoUrl;
  late TextEditingController _banners;
  late TextEditingController _featured;
  late TextEditingController _offerText;
  late TextEditingController _offerCode;
  late TextEditingController _phone;
  late TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _settings = AdminDataService.instance.getSettings();
    _appName = TextEditingController(text: _settings.appName);
    _logoUrl = TextEditingController(text: _settings.logoUrl);
    _banners = TextEditingController(text: _settings.bannerUrls.join('\n'));
    _featured = TextEditingController(text: _settings.featuredProductIds.join(', '));
    _offerText = TextEditingController(text: _settings.welcomeOfferText);
    _offerCode = TextEditingController(text: _settings.welcomeOfferCode);
    _phone = TextEditingController(text: _settings.contactPhone);
    _email = TextEditingController(text: _settings.contactEmail);
  }

  @override
  void dispose() {
    _appName.dispose();
    _logoUrl.dispose();
    _banners.dispose();
    _featured.dispose();
    _offerText.dispose();
    _offerCode.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = AdminSettings(
      appName: _appName.text,
      logoUrl: _logoUrl.text.trim(),
      bannerUrls: _banners.text.split('\n').where((s) => s.trim().isNotEmpty).toList(),
      featuredProductIds: _featured.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      welcomeOfferText: _offerText.text,
      welcomeOfferCode: _offerCode.text,
      contactPhone: _phone.text,
      contactEmail: _email.text,
    );
    await AdminDataService.instance.saveSettings(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الإعدادات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'الإعدادات العامة',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _appName, decoration: const InputDecoration(labelText: 'اسم التطبيق')),
          TextField(controller: _logoUrl, decoration: const InputDecoration(labelText: 'رابط الشعار أو assets/images/kayan_logo.png')),
          TextField(controller: _banners, maxLines: 3, decoration: const InputDecoration(labelText: 'روابط البانر (سطر لكل صورة)')),
          TextField(controller: _featured, decoration: const InputDecoration(labelText: 'معرفات المنتجات المميزة')),
          TextField(controller: _offerText, decoration: const InputDecoration(labelText: 'نص عرض الترحيب')),
          TextField(controller: _offerCode, decoration: const InputDecoration(labelText: 'كود العرض')),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'هاتف التواصل')),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: const Text('حفظ الإعدادات')),
        ],
      ),
    );
  }
}
