import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';

class SuccessToast {
  SuccessToast._();

  static void show(BuildContext context, {required String message, Duration duration = const Duration(seconds: 3)}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: KayanDesignTokens.kGreen,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: KayanDesignTokens.cairo(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
