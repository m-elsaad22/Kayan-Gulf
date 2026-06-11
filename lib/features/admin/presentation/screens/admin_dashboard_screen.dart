import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/widgets/luxury/luxury_widgets.dart';
import '../widgets/admin_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = AdminDataService.instance;
    final stats = [
      ('عدد المنتجات', '${admin.getProducts().length}', Icons.inventory_2_outlined),
      ('عدد الخدمات', '${admin.getServices().length}', Icons.handyman_outlined),
      ('عدد الإعلانات', '${admin.getAds().length}', Icons.campaign_outlined),
      ('عدد المستخدمين', '${admin.userCount}', Icons.people_outline),
    ];

    final menu = [
      ('إدارة المنتجات', AppRoutes.adminProducts, Icons.shopping_bag_outlined),
      ('إدارة الفئات', AppRoutes.adminCategories, Icons.category_outlined),
      ('إدارة الخدمات المنزلية', AppRoutes.adminServices, Icons.home_repair_service_outlined),
      ('إدارة الإعلانات', AppRoutes.adminAds, Icons.ads_click_outlined),
      ('إدارة البانرات', AppRoutes.adminBanners, Icons.view_carousel_outlined),
      ('إعدادات الألوان', AppRoutes.adminColors, Icons.palette_outlined),
      ('إعدادات الخطوط', AppRoutes.adminFonts, Icons.text_fields_outlined),
      ('إدارة الشاشات', AppRoutes.adminScreens, Icons.dashboard_customize_outlined),
      ('الإعدادات العامة', AppRoutes.adminSettings, Icons.settings_outlined),
    ];

    return AdminScaffold(
      title: 'لوحة التحكم — كيان',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'تسجيل الخروج',
          onPressed: () async {
            await admin.logout();
            if (context.mounted) context.go(AppRoutes.adminLogin);
          },
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: stats
                .map(
                  (s) => LuxuryStatTile(
                    label: s.$1,
                    value: s.$2,
                    icon: s.$3,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          ...menu.map(
            (m) => LuxuryAdminMenuTile(
              title: m.$1,
              icon: m.$3,
              onTap: () => context.push(m.$2),
            ),
          ),
        ],
      ),
    );
  }
}
