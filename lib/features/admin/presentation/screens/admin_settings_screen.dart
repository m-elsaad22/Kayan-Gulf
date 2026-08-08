import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../widgets/admin_scaffold.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
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
    final s = AdminDataService.instance.getSettings();
    _appName = TextEditingController(text: s.appName);
    _logoUrl = TextEditingController(text: s.logoUrl);
    _banners = TextEditingController(text: s.bannerUrls.join('\n'));
    _featured = TextEditingController(text: s.featuredProductIds.join(', '));
    _offerText = TextEditingController(text: s.welcomeOfferText);
    _offerCode = TextEditingController(text: s.welcomeOfferCode);
    _phone = TextEditingController(text: s.contactPhone);
    _email = TextEditingController(text: s.contactEmail);
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
    await AdminDataService.instance.saveSettings(
      AdminSettings(
        appName: _appName.text,
        logoUrl: _logoUrl.text.trim(),
        bannerUrls: _banners.text.split('\n').where((s) => s.trim().isNotEmpty).toList(),
        featuredProductIds: _featured.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        welcomeOfferText: _offerText.text,
        welcomeOfferCode: _offerCode.text,
        contactPhone: _phone.text,
        contactEmail: _email.text,
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'الإعدادات العامة',
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          KayanDesignTextField(label: 'اسم التطبيق', controller: _appName, icon: Icons.apps_rounded),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'رابط الشعار', controller: _logoUrl, icon: Icons.image_outlined),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'روابط البانر', controller: _banners, icon: Icons.view_carousel_outlined),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'معرفات المنتجات المميزة', controller: _featured, icon: Icons.star_outline_rounded),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'نص عرض الترحيب', controller: _offerText, icon: Icons.local_offer_outlined),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'كود العرض', controller: _offerCode, icon: Icons.confirmation_number_outlined),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'هاتف التواصل', controller: _phone, icon: Icons.phone_outlined),
          const SizedBox(height: 12),
          KayanDesignTextField(label: 'البريد الإلكتروني', controller: _email, icon: Icons.email_outlined),
          const SizedBox(height: 20),
          KayanCtaButton(label: 'حفظ الإعدادات', variant: KayanCtaVariant.blue, trailingIcon: Icons.save_rounded, onPressed: _save),
        ],
      ),
    );
  }
}
