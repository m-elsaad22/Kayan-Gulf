import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../providers/locale_provider.dart';

/// Consistent themed scaffold for KAYAN screens (light/dark aware).
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        foregroundColor: isDark ? AppColors.darkText : AppColors.lightText,
        elevation: isDark ? 0 : 1,
        shadowColor: AppColors.royalBlue.withValues(alpha: 0.08),
        leading: showBack
            ? IconButton(
                icon: Icon(
                  isArabic
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text(
          isArabic ? titleAr : titleEn,
          style: isArabic
              ? AppTextStyles.arabicTitleMedium
              : AppTextStyles.titleMedium,
        ),
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: body,
        ),
      ),
    );
  }
}
