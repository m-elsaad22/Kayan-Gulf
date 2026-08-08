import 'package:flutter/material.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// لوحة إدارة كيان — shell خفيف
class AdminScaffold extends StatelessWidget {
  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBack = true,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: KayanDesignTokens.bg,
        floatingActionButton: floatingActionButton,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    if (showBack && Navigator.canPop(context))
                      KayanHeroIconButton(
                        icon: Icons.arrow_forward_ios_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                        light: true,
                      )
                    else
                      const SizedBox(width: 40),
                    Expanded(
                      child: Text(
                        title,
                        style: KayanDesignTokens.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: KayanDesignTokens.kBlueDeep,
                        ),
                      ),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
