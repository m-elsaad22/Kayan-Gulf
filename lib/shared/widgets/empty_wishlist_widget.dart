import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../widgets/design/kayan_entry_widgets.dart';

class EmptyWishlistWidget extends StatelessWidget {
  const EmptyWishlistWidget({super.key, this.onBrowse, this.isArabic = false});

  final VoidCallback? onBrowse;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border_rounded, size: 72, color: KayanDesignTokens.muted.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(isArabic ? 'لا توجد مفضلات' : 'No favorites yet', style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'احفظ المنتجات التي تعجبك للوصول إليها لاحقاً.' : 'Save products you love for later.',
              textAlign: TextAlign.center,
              style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.muted),
            ),
            if (onBrowse != null) ...[
              const SizedBox(height: 20),
              KayanCtaButton(label: isArabic ? 'تصفح المنتجات' : 'Browse products', variant: KayanCtaVariant.blue, onPressed: onBrowse),
            ],
          ],
        ),
      ),
    );
  }
}
