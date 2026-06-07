import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RateAppDialog extends StatefulWidget {
  final bool isArabic;

  const RateAppDialog({super.key, this.isArabic = false});

  static Future<int?> show(BuildContext context, {bool isArabic = false}) {
    return showDialog<int>(
      context: context,
      builder: (_) => RateAppDialog(isArabic: isArabic),
    );
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
      title: Text(
        ar ? 'قيّم كيان' : 'Rate KAYAN',
        style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ar ? 'كيف كانت تجربتك؟' : 'How was your experience?',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = star),
                icon: Icon(
                  star <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: AppColors.metallicGold,
                  size: 32,
                ),
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(ar ? 'لاحقاً' : 'Later'),
        ),
        FilledButton(
          onPressed: _rating == 0 ? null : () => Navigator.of(context).pop(_rating),
          child: Text(ar ? 'إرسال' : 'Submit'),
        ),
      ],
    );
  }
}
