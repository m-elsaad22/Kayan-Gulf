import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';
import '../widgets/admin_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = AdminDataService.instance;
    final stats = [
      ('عدد المنتجات', admin.getProducts().length, Icons.inventory_2_outlined),
      ('عدد الخدمات', admin.getServices().length, Icons.handyman_outlined),
      ('عدد الإعلانات', admin.getAds().length, Icons.campaign_outlined),
      ('عدد المستخدمين', admin.userCount, Icons.people_outline),
    ];

    final menu = [
      ('إدارة المنتجات', AppRoutes.adminProducts, Icons.shopping_bag_outlined),
      ('إدارة الفئات', AppRoutes.adminCategories, Icons.category_outlined),
      ('إدارة الخدمات المنزلية', AppRoutes.adminServices, Icons.home_repair_service_outlined),
      ('إدارة الإعلانات', AppRoutes.adminAds, Icons.ads_click_outlined),
      ('الإعدادات العامة', AppRoutes.adminSettings, Icons.settings_outlined),
    ];

    return AdminScaffold(
      title: 'لوحة التحكم',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await admin.logout();
            if (context.mounted) context.go(AppRoutes.adminLogin);
          },
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: stats
                .map(
                  (s) => Card(
                    color: AppColors.bgCard,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(s.$3, color: AppColors.metallicGold),
                          const Spacer(),
                          Text('${s.$2}',
                              style: AppTextStyles.arabicHeadlineSmall),
                          Text(s.$1, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          ...menu.map(
            (m) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(m.$3, color: AppColors.royalBlue),
                title: Text(m.$1, style: AppTextStyles.arabicTitleSmall),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => context.push(m.$2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
