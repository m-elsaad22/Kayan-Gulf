import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../widgets/design/kayan_entry_widgets.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key, this.onRetry, this.isArabic = false});

  final VoidCallback? onRetry;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: KayanDesignTokens.muted.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text(isArabic ? 'لا يوجد اتصال' : 'No Internet', style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'تحقق من اتصالك وحاول مرة أخرى.' : 'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.muted),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              KayanCtaButton(label: isArabic ? 'إعادة المحاولة' : 'Retry', variant: KayanCtaVariant.blue, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
