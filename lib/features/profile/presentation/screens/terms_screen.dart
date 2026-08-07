import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// الشروط والأحكام — light design
class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  static const _sections = [
    ('الاستخدام العادل', 'Fair Usage', 'التزم بالأنظمة المحلية وسياسات المنصة عند استخدام كيان.', 'Follow local regulations and platform policies when using KAYAN.'),
    ('المدفوعات والاسترداد', 'Payments & Refunds', 'تختلف سياسات الاسترداد حسب الخدمة أو البائع.', 'Refund policies vary by service or vendor.'),
    ('المحتوى والإعلانات', 'Content & Listings', 'أنت مسؤول عن دقة إعلاناتك ومحتواك المنشور.', 'You are responsible for the accuracy of your listings and content.'),
    ('إنهاء الحساب', 'Account Termination', 'يحق لكيان تعليق الحسابات المخالفة للشروط.', 'KAYAN may suspend accounts that violate these terms.'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'الشروط والأحكام' : 'Terms of service', onBack: () => context.pop()),
              const SizedBox(height: 8),
              Text(
                ar ? 'استخدامك لكيان يخضع لهذه الشروط' : 'Your KAYAN usage follows these terms',
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final s in _sections)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: KayanDesignTokens.surface,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            border: Border.all(color: KayanDesignTokens.border),
                            boxShadow: KayanDesignTokens.shadowS,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ar ? s.$1 : s.$2, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 15)),
                              const SizedBox(height: 6),
                              Text(ar ? s.$3 : s.$4, style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2, height: 1.6)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
