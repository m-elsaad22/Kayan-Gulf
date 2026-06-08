import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
        appBar: AppBar(
          backgroundColor: AppColors.royalNavy,
          foregroundColor: Colors.white,
          title: Text(title, style: AppTextStyles.arabicTitleMedium),
          actions: actions,
        ),
        floatingActionButton: floatingActionButton,
        body: body,
      ),
    );
  }
}
