import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../providers/locale_provider.dart';
import 'design/kayan_design_widgets.dart';

/// Consistent light scaffold for KAYAN screens.
class KayanThemedScaffold extends ConsumerWidget {
  final String titleAr;
  final String titleEn;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBack;

  const KayanThemedScaffold({
    super.key,
    required this.titleAr,
    required this.titleEn,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: isArabic ? titleAr : titleEn,
                onBack: showBack ? () => context.pop() : () {},
                trailing: actions != null && actions!.isNotEmpty
                    ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                    : null,
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
