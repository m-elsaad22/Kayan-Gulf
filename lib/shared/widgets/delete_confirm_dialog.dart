import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';

class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Delete',
    this.cancelLabel = 'Cancel',
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM)),
      title: Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
      content: Text(message, style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(cancelLabel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: KayanDesignTokens.danger),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
