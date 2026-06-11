import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/admin_data_service.dart';
import '../../../routing/app_routes.dart';
import '../services/design_engine_service.dart';
import '../widgets/super_admin_shell.dart';
import '../widgets/super_admin_widgets.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = AdminDataService.instance;

    final stats = [
      (
        'المنتجات',
        admin.getProducts().length,
        Icons.inventory_2_outlined,
        [3.0, 4.0, 3.5, 5.0, 4.2, 6.0, 5.5],
      ),
      (
        'الخدمات',
        admin.getServices().length,
        Icons.handyman_outlined,
        [2.0, 2.5, 3.0, 2.8, 4.0, 3.6, 4.5],
      ),
      (
        'الإعلانات',
        admin.getAds().length,
        Icons.campaign_outlined,
        [1.0, 1.5, 2.0, 2.2, 2.8, 3.0, 3.2],
      ),
      (
        'المستخدمون',
        admin.userCount,
        Icons.people_outline,
        [5.0, 5.2, 5.5, 6.0, 6.2, 6.8, 7.0],
      ),
    ];

    final quickLinks = [
      ('الألوان', AppRoutes.superAdminColors, Icons.palette_rounded),
      ('الخطوط', AppRoutes.superAdminTypography, Icons.text_fields_rounded),
      ('الزوايا', AppRoutes.superAdminRadius, Icons.rounded_corner_rounded),
      ('الحركة', AppRoutes.superAdminAnimations, Icons.animation_rounded),
    ];

    return SuperAdminShell(
      title: 'لوحة التحكم الرئيسية',
      currentRoute: AppRoutes.superAdminDashboard,
      body: DesignEngineBuilder(
        builder: (context, settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: stats
                    .map(
                      (s) => AnimatedStatCard(
                        label: s.$1,
                        value: s.$2,
                        icon: s.$3,
                        sparkline: s.$4,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickLinks
                    .map(
                      (q) => ActionChip(
                        avatar: Icon(q.$3, size: 18),
                        label: Text(q.$1),
                        onPressed: () => context.push(q.$2),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              RecentActivityList(activities: settings.recentActivities),
            ],
          );
        },
      ),
    );
  }
}
