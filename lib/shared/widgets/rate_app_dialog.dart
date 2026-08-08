import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';

class RateAppDialog extends StatefulWidget {
  const RateAppDialog({super.key, this.isArabic = false});

  final bool isArabic;

  static Future<int?> show(BuildContext context, {bool isArabic = false}) {
    return showDialog<int>(context: context, builder: (_) => RateAppDialog(isArabic: isArabic));
  }

  @override
  State<RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<RateAppDialog> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final ar = widget.isArabic;
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM)),
      title: Text(ar ? 'قيّم كيان' : 'Rate KAYAN', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(ar ? 'كيف كانت تجربتك؟' : 'How was your experience?', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = star),
                icon: Icon(star <= _rating ? Icons.star_rounded : Icons.star_border_rounded, color: KayanDesignTokens.oOrange, size: 32),
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(null), child: Text(ar ? 'لاحقاً' : 'Later')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: KayanDesignTokens.kBlue),
          onPressed: _rating == 0 ? null : () => Navigator.of(context).pop(_rating),
          child: Text(ar ? 'إرسال' : 'Submit'),
        ),
      ],
    );
  }
}
