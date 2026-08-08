import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
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
        'approved' => KayanDesignTokens.kGreen,
        'rejected' => KayanDesignTokens.danger,
        _ => KayanDesignTokens.oOrange,
      };

  String _statusLabel(String s) => switch (s) {
        'approved' => 'موافق',
        'rejected' => 'مرفوض',
        _ => 'قيد المراجعة',
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
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
              border: Border.all(color: KayanDesignTokens.border),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 14),
              title: Text(a.title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
              subtitle: Text('${a.city} • ${_statusLabel(a.status)}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
              leading: CircleAvatar(
                backgroundColor: _statusColor(a.status).withValues(alpha: 0.15),
                child: Icon(Icons.campaign_outlined, color: _statusColor(a.status), size: 20),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                  child: Text(a.descriptionAr.isEmpty ? 'لا يوجد وصف' : a.descriptionAr, style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _setStatus(i, 'approved'),
                          child: Text('موافقة', style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: KayanDesignTokens.kGreen)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _setStatus(i, 'rejected'),
                          child: Text('رفض', style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: KayanDesignTokens.danger)),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _ads.removeAt(i);
                          await _save();
                        },
                        icon: const Icon(Icons.delete_outline, color: KayanDesignTokens.danger),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
