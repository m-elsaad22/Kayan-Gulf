import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/admin_scaffold.dart';

class AdminAdsScreen extends StatefulWidget {
  const AdminAdsScreen({super.key});

  @override
  State<AdminAdsScreen> createState() => _AdminAdsScreenState();
}

class _AdminAdsScreenState extends State<AdminAdsScreen> {
  late List<AdminAdItem> _ads;

  @override
  void initState() {
    super.initState();
    _ads = AdminDataService.instance.getAds();
  }

  Future<void> _save() async {
    await AdminDataService.instance.saveAds(_ads);
    setState(() => _ads = AdminDataService.instance.getAds());
  }

  void _setStatus(int i, String status) {
    final a = _ads[i];
    _ads[i] = AdminAdItem(
      id: a.id,
      title: a.title,
      slug: a.slug,
      price: a.price,
      city: a.city,
      imageUrl: a.imageUrl,
      status: status,
      descriptionAr: a.descriptionAr,
    );
    _save();
  }

  Color _statusColor(String s) => switch (s) {
        'approved' => AppColors.success,
        'rejected' => AppColors.error,
        _ => AppColors.warning,
      };

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إدارة الإعلانات',
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _ads.length,
        itemBuilder: (_, i) {
          final a = _ads[i];
          return Card(
            child: ExpansionTile(
              title: Text(a.title, style: AppTextStyles.arabicTitleSmall),
              subtitle: Text('${a.city} • ${a.status}'),
              leading: CircleAvatar(
                backgroundColor: _statusColor(a.status).withValues(alpha: 0.2),
                child: Icon(Icons.campaign, color: _statusColor(a.status)),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(a.descriptionAr.isEmpty ? 'لا يوجد وصف' : a.descriptionAr),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => _setStatus(i, 'approved'),
                      child: const Text('موافقة'),
                    ),
                    TextButton(
                      onPressed: () => _setStatus(i, 'rejected'),
                      child: const Text('رفض'),
                    ),
                    TextButton(
                      onPressed: () async {
                        _ads.removeAt(i);
                        await _save();
                      },
                      child: const Text('حذف', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
