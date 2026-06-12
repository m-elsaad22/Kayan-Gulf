// ============================================================
// KAYAN — Branded AppBar with optional logo
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class KayanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final String? title;
  final List<Widget>? actions;
  final bool showBack;
  final PreferredSizeWidget? bottom;

  const KayanAppBar({
    super.key,
    this.showLogo = true,
    this.title,
    this.actions,
    this.showBack = true,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.darkText : AppColors.lightText;
    final bg = isDark ? AppColors.darkCardBg : AppColors.lightBg;

    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: isDark ? 0 : 1,
      shadowColor: AppColors.royalBlue.withValues(alpha: 0.08),
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: showBack,
      leading: showBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: fg,
                size: 20,
              ),
              onPressed: () => context.pop(),
            )
          : null,
      title: showLogo && title == null
          ? Image.asset(
              'assets/images/kayan_logo.png',
              height: 42,
              fit: BoxFit.contain,
            )
          : title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: fg,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
      iconTheme: IconThemeData(color: fg),
      actions: actions,
      bottom: bottom,
    );
  }
}
