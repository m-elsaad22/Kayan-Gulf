import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../widgets/admin_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = AdminDataService.instance;
    final stats = [
      ('المنتجات', '${admin.getProducts().length}', Icons.inventory_2_outlined, KayanDesignTokens.gradBlue),
      ('الخدمات', '${admin.getServices().length}', Icons.handyman_outlined, KayanDesignTokens.gradGreen),
      ('الإعلانات', '${admin.getAds().length}', Icons.campaign_outlined, KayanDesignTokens.gradOrange),
      ('المستخدمون', '${admin.userCount}', Icons.people_outline, KayanDesignTokens.gradGold),
    ];

    final menu = [
      ('محرك التصميم', AppRoutes.superAdminDashboard, Icons.auto_awesome, KayanDesignTokens.gradGold),
      ('إدارة المنتجات', AppRoutes.adminProducts, Icons.shopping_bag_outlined, KayanDesignTokens.gradOrange),
      ('إدارة الفئات', AppRoutes.adminCategories, Icons.category_outlined, KayanDesignTokens.gradBlue),
      ('إدارة الخدمات', AppRoutes.adminServices, Icons.home_repair_service_outlined, KayanDesignTokens.gradGreen),
      ('إدارة الإعلانات', AppRoutes.adminAds, Icons.ads_click_outlined, KayanDesignTokens.gradOrange),
      ('إدارة البانرات', AppRoutes.adminBanners, Icons.view_carousel_outlined, KayanDesignTokens.gradBlue),
      ('إعدادات الألوان', AppRoutes.adminColors, Icons.palette_outlined, KayanDesignTokens.gradGold),
      ('إعدادات الخطوط', AppRoutes.adminFonts, Icons.text_fields_outlined, KayanDesignTokens.gradBlue),
      ('إدارة الشاشات', AppRoutes.adminScreens, Icons.dashboard_customize_outlined, KayanDesignTokens.gradGreen),
      ('الإعدادات العامة', AppRoutes.adminSettings, Icons.settings_outlined, KayanDesignTokens.gradOrange),
    ];

    return AdminScaffold(
      title: 'لوحة التحكم — كيان',
      showBack: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: KayanDesignTokens.kBlue),
          tooltip: 'تسجيل الخروج',
          onPressed: () async {
            await admin.logout();
            if (context.mounted) context.go(AppRoutes.adminLogin);
          },
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.4,
            children: stats.map((s) => _StatCard(label: s.$1, value: s.$2, icon: s.$3, gradient: s.$4)).toList(),
          ),
          const SizedBox(height: 20),
          Text('الإدارة', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
          const SizedBox(height: 8),
          ...menu.map((m) => _MenuTile(title: m.$1, route: m.$2, icon: m.$3, gradient: m.$4)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon, required this.gradient});

  final String label;
  final String value;
  final IconData icon;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        border: Border.all(color: KayanDesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const Spacer(),
          Text(value, style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
          Text(label, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.title, required this.route, required this.icon, required this.gradient});

  final String title;
  final String route;
  final IconData icon;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        child: InkWell(
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          onTap: () => context.push(route),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
              border: Border.all(color: KayanDesignTokens.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep))),
                Icon(Icons.chevron_left_rounded, color: KayanDesignTokens.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
