import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/kayan_motion.dart';
import '../../../routing/app_routes.dart';
import '../services/design_engine_service.dart';

class SuperAdminShell extends StatefulWidget {
  final String title;
  final String currentRoute;
  final Widget body;
  final List<Widget>? actions;

  const SuperAdminShell({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
    this.actions,
  });

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
    final now = DateTime.now();
    final weekdays = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    final dateStr =
        '${weekdays[now.weekday % 7]}، ${now.day} ${months[now.month - 1]} ${now.year}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.bgScaffold,
        extendBodyBehindAppBar: true,
        drawer: _buildDrawer(context),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 12),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AppBar(
                backgroundColor: AppColors.royalNavy.withValues(alpha: 0.78),
                foregroundColor: Colors.white,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('مرحباً، Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    Text(dateStr, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                actions: [
                  ...?widget.actions,
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      KayanMotion.hapticLight();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('لا إشعارات جديدة')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppGradients.hero),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(child: widget.body),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgModal.withValues(alpha: 0.95),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.metallicGold),
                  SizedBox(width: 10),
                  Text(
                    'محرك التصميم الفاخر',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderSubtle),
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
              leading: const Icon(Icons.arrow_back, color: AppColors.textMuted),
              title: const Text('العودة للأدمن'),
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
  final String title;
  final IconData icon;
  final String route;
  const _NavSection(this.title, this.icon, this.route);
}

class _DrawerTile extends StatefulWidget {
  final _NavSection section;
  final bool active;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.section,
    required this.active,
    required this.onTap,
  });

  @override
  State<_DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<_DrawerTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          KayanMotion.hapticSelection();
          widget.onTap();
        },
        onHover: (v) => setState(() => _hover = v),
        splashColor: AppColors.skyBlue.withValues(alpha: 0.2),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: widget.active
                ? AppColors.royalBlue.withValues(alpha: 0.2)
                : (_hover ? AppColors.whiteOp(0.04) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: widget.active
                ? const Border(right: BorderSide(color: AppColors.skyBlue, width: 3))
                : null,
          ),
          child: Row(
            children: [
              AnimatedScale(
                scale: _hover ? 1.08 : 1,
                duration: KayanMotion.fast,
                child: Icon(
                  widget.section.icon,
                  color: widget.active ? AppColors.skyBlue : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.section.title,
                  style: TextStyle(
                    fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
                    color: widget.active ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Listens to design engine changes and rebuilds child.
class DesignEngineBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DesignSettings settings) builder;

  const DesignEngineBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: DesignEngineService.instance.revisionNotifier,
      builder: (context, _, __) =>
          builder(context, DesignEngineService.instance.settings),
    );
  }
}
