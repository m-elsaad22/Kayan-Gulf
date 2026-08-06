// My ads — matches design/html/119-cl-my-ads.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class MyAdsScreen extends ConsumerStatefulWidget {
  const MyAdsScreen({super.key});

  @override
  ConsumerState<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends ConsumerState<MyAdsScreen> {
  late List<MyAdModel> _ads;
  int _tabIndex = 0;

  final _tabFilters = <String?>[null, 'ACTIVE', 'EXPIRED', 'PAUSED'];

  @override
  void initState() {
    super.initState();
    _ads = List.from(mockMyAds);
    if (!_ads.any((a) => a.status == 'EXPIRED')) {
      _ads.add(MyAdModel(ad: mockAds[1], status: 'EXPIRED', daysLeft: 0, canBoost: false));
    }
  }

  IconData _icon(String slug) => switch (slug) {
        'vehicles' => Icons.directions_car_rounded,
        'realestate' => Icons.apartment_rounded,
        _ => Icons.sell_rounded,
      };

  Color _statusColor(String status) => switch (status) {
        'ACTIVE' => KayanDesignTokens.kGreen,
        'EXPIRED' => KayanDesignTokens.danger,
        'PAUSED' => KayanDesignTokens.muted,
        'SOLD' => KayanDesignTokens.kBlue,
        _ => KayanDesignTokens.muted,
      };

  String _statusLabel(String status, bool ar) {
    if (ar) {
      return switch (status) {
        'ACTIVE' => 'نشط',
        'EXPIRED' => 'منتهي',
        'PAUSED' => 'مسودة',
        'SOLD' => 'مُباع',
        _ => status,
      };
    }
    return switch (status) {
      'ACTIVE' => 'Active',
      'EXPIRED' => 'Expired',
      'PAUSED' => 'Draft',
      'SOLD' => 'Sold',
      _ => status,
    };
  }

  List<MyAdModel> get _filtered {
    final filter = _tabFilters[_tabIndex];
    if (filter == null) return _ads;
    return _ads.where((a) => a.status == filter).toList();
  }

  void _deleteAd(String id) {
    setState(() => _ads = _ads.where((m) => m.ad.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final tabs = ar ? ['الكل', 'نشطة', 'منتهية', 'مسودة'] : ['All', 'Active', 'Expired', 'Draft'];
    final items = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'إعلاناتي' : 'My ads', onBack: () => context.pop()),
              const SizedBox(height: 10),
              KayanFilterSlotRow(
                labels: tabs,
                selectedIndex: _tabIndex,
                onSelected: (i) => setState(() => _tabIndex = i),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          ar ? 'لا توجد إعلانات' : 'No ads',
                          style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                        ),
                      )
                    : ListView(
                        children: items.map((item) {
                          final ad = item.ad;
                          return KayanMyAdCard(
                            title: ad.title,
                            statusLabel: _statusLabel(item.status, ar),
                            statusColor: _statusColor(item.status),
                            viewsLabel: ar ? '${ad.viewCount} مشاهدة' : '${ad.viewCount} views',
                            icon: _icon(ad.categorySlug),
                            editLabel: ar ? 'تعديل' : 'Edit',
                            deleteLabel: ar ? 'حذف' : 'Delete',
                            renewLabel: ar ? 'تجديد' : 'Renew',
                            onEdit: () => context.push(AppRoutes.editAdPath(ad.id)),
                            onDelete: () => _deleteAd(ad.id),
                            onRenew: () => context.push(AppRoutes.boostAdPath(ad.id)),
                          );
                        }).toList(),
                      ),
              ),
              KayanCtaButton(
                label: ar ? 'أضف إعلان جديد' : 'Post new ad',
                trailingIcon: Icons.add_rounded,
                variant: KayanCtaVariant.gold,
                onPressed: () => context.push(AppRoutes.postAd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
