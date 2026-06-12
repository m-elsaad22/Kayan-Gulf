import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light-first screen colors (use instead of hardcoded dark scaffold).
extension KayanScreenColors on BuildContext {
  bool get isKayanDark => Theme.of(this).brightness == Brightness.dark;

  Color get screenBackground =>
      isKayanDark ? AppColors.darkBg : AppColors.lightBg;

  Color get screenCardBackground =>
      isKayanDark ? AppColors.darkCardBg : AppColors.lightCardBg;

  Color get screenText =>
      isKayanDark ? AppColors.darkText : AppColors.lightText;

  Color get screenSubtext =>
      isKayanDark ? AppColors.darkSubtext : AppColors.lightSubtext;
}
