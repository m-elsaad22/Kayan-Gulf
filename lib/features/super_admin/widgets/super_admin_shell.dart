import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/kayan_design_tokens.dart';
import '../../../core/theme/kayan_motion.dart';
import '../../../routing/app_routes.dart';
import '../services/design_engine_service.dart';

class SuperAdminShell extends StatefulWidget {
  const SuperAdminShell({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
    this.actions,
  });

  final String title;
  final String currentRoute;
  final Widget body;
  final List<Widget>? actions;

  @override
  State<SuperAdminShell> createState() => _SuperAdminShellState();
}

class _SuperAdminShellState extends State<SuperAdminShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _sections = const [
    _NavSection('لوحة التحكم', Icons.dashboard_customize_rounded, AppRoutes.superAdminDashboard),
    _NavSection('الألوان الفاخرة', Icons.palette_rounded, AppRoutes.superAdminColors),
    _NavSection('نظام الخطوط', Icons.text_fields_rounded, AppRoutes.superAdminTypography),
    _NavSection('الزوايا والظلال', Icons.rounded_corner_rounded, AppRoutes.superAdminRadius),
    _NavSection('التأثيرات الحركية', Icons.animation_rounded, AppRoutes.superAdminAnimations),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: KayanDesignTokens.bg,
        drawer: _buildDrawer(context),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: KayanDesignTokens.kBlueDeep,
          elevation: 0,
          title: Text(widget.title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
          actions: [
            ...?widget.actions,
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                KayanMotion.hapticLight();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا إشعارات جديدة')));
              },
            ),
            IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
            const SizedBox(width: 4),
          ],
        ),
        body: widget.body,
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text('محرك التصميم', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 16)),
                ],
              ),
            ),
            const Divider(height: 1, color: KayanDesignTokens.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _sections.map((s) {
                  final active = widget.currentRoute == s.route;
                  return _DrawerTile(
                    section: s,
                    active: active,
                    onTap: () {
                      Navigator.pop(context);
                      if (!active) context.go(s.route);
                    },
                  );
                }).toList(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back, color: KayanDesignTokens.muted),
              title: Text('العودة للأدمن', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.adminDashboard);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavSection {
  const _NavSection(this.title, this.icon, this.route);

  final String title;
  final IconData icon;
  final String route;
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.section, required this.active, required this.onTap});

  final _NavSection section;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(section.icon, color: active ? KayanDesignTokens.kBlue : KayanDesignTokens.muted),
      title: Text(section.title, style: KayanDesignTokens.cairo(fontWeight: active ? FontWeight.w800 : FontWeight.w500, color: active ? KayanDesignTokens.kBlueDeep : KayanDesignTokens.text2)),
      selected: active,
      selectedTileColor: KayanDesignTokens.kBlue.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        KayanMotion.hapticSelection();
        onTap();
      },
    );
  }
}

/// Listens to design engine changes and rebuilds child.
class DesignEngineBuilder extends StatelessWidget {
  const DesignEngineBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, DesignSettings settings) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: DesignEngineService.instance.revisionNotifier,
      builder: (context, _, __) => builder(context, DesignEngineService.instance.settings),
    );
  }
}
