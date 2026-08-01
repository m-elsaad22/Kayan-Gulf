import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
/// Professional CMS shell — glass app bar + royal gradient backdrop.
class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 8),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: AppBar(
                backgroundColor: AppColors.royalNavy.withValues(alpha: 0.82),
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: false,
                title: Text(title, style: AppTextStyles.arabicTitleMedium),
                actions: actions,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.metallicGold.withValues(alpha: 0.0),
                          AppColors.metallicGold.withValues(alpha: 0.55),
                          AppColors.metallicGold.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: floatingActionButton,
        body: Container(
          decoration: const BoxDecoration(gradient: AppGradients.hero),
          child: SafeArea(
            child: body,
          ),
        ),
      ),
    );
  }
}
