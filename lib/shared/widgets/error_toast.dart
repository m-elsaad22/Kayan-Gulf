import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../widgets/design/kayan_entry_widgets.dart';

class ErrorToast {
  ErrorToast._();

  static void show(BuildContext context, {required String message, Duration duration = const Duration(seconds: 4)}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: KayanDesignTokens.danger,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: KayanDesignTokens.cairo(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
