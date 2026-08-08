import 'package:flutter/material.dart';

import 'kayan_design_tokens.dart';

/// Light-first screen colors (use instead of hardcoded dark scaffold).
extension KayanScreenColors on BuildContext {
  bool get isKayanDark => Theme.of(this).brightness == Brightness.dark;

  Color get screenBackground =>
      isKayanDark ? KayanDesignTokens.kBlueDeep : KayanDesignTokens.bg;

  Color get screenCardBackground =>
      isKayanDark ? const Color(0xFF132038) : KayanDesignTokens.surface;

  Color get screenText =>
      isKayanDark ? Colors.white : KayanDesignTokens.text;

  Color get screenSubtext =>
      isKayanDark ? Colors.white70 : KayanDesignTokens.text2;
}
