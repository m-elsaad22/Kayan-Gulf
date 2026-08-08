// KAYAN — Branded AppBar with optional logo (light design)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';

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
    return AppBar(
      backgroundColor: KayanDesignTokens.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: KayanDesignTokens.kBlueDeep.withValues(alpha: 0.08),
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: showBack,
      leading: showBack
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
              ),
              onPressed: () => context.pop(),
            )
          : null,
      title: showLogo && title == null
          ? Image.asset(
              'assets/images/kayan_logo.png',
              height: 52,
              fit: BoxFit.contain,
            )
          : title != null
              ? Text(
                  title!,
                  style: KayanDesignTokens.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: KayanDesignTokens.text,
                  ),
                )
              : null,
      iconTheme: const IconThemeData(color: KayanDesignTokens.text),
      actions: actions,
      bottom: bottom,
    );
  }
}
