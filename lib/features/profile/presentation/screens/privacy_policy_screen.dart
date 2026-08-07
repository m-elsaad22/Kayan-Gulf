import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// سياسة الخصوصية — light design
class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  static const _sections = [
    ('البيانات الشخصية', 'Personal Data', 'نستخدم بياناتك لتحسين التجربة وتقديم الخدمات فقط.', 'We use your data only to improve experience and deliver services.'),
    ('الحماية والأمان', 'Security', 'نخزن البيانات الحساسة بتشفير ومعايير أمان عالية.', 'Sensitive data is stored with encryption and strong security.'),
    ('مشاركة البيانات', 'Data Sharing', 'لا نبيع بياناتك لأطراف ثالثة دون موافقتك.', 'We do not sell your data to third parties without consent.'),
    ('حقوقك', 'Your Rights', 'يمكنك طلب تصدير أو حذف بياناتك من إعدادات الحساب.', 'You can request export or deletion from account settings.'),
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
              KayanLightTopBar(title: ar ? 'سياسة الخصوصية' : 'Privacy policy', onBack: () => context.pop()),
              const SizedBox(height: 8),
              Text(
                ar ? 'خصوصيتك أساس الثقة في كيان' : 'Your privacy is core to KAYAN trust',
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
