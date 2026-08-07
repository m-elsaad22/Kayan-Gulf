// Coupons — matches design/html/104-or-coupons.html
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../data/mock/delivery_mock_data.dart';

class DeliveryCouponsScreen extends ConsumerWidget {
  const DeliveryCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'كوبونات الخصم' : 'Coupons',
            variant: KayanSectionHeroVariant.redOrange,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: mockDeliveryCoupons.map((c) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: KayanDesignTokens.border),
                    boxShadow: KayanDesignTokens.shadowS,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: KayanDesignTokens.gradOrange,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          ar ? c.discountAr : c.discountEn,
                          style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ar ? c.titleAr : c.titleEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                            const SizedBox(height: 4),
                            Text(c.code, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: c.code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(ar ? 'تم نسخ الكود' : 'Code copied'), behavior: SnackBarBehavior.floating),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, color: KayanDesignTokens.kBlue),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
