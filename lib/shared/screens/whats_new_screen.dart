import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/widgets/design/kayan_design_widgets.dart';

/// ما الجديد — light design
class WhatsNewScreen extends ConsumerWidget {
  const WhatsNewScreen({super.key});

  static const _items = [
    ('تصميم خفيف جديد', 'New light design', 'واجهة أنظف وأسرع', 'Cleaner, faster UI', Icons.auto_awesome_rounded, KayanDesignTokens.gradBlue),
    ('محفظة محسّنة', 'Better wallet', 'نقاط واسترداد أسهل', 'Easier points & refunds', Icons.account_balance_wallet_rounded, KayanDesignTokens.gradGold),
    ('تتبع مباشر', 'Live tracking', 'تابع الفني والطلب لحظياً', 'Track technician & orders', Icons.location_on_rounded, KayanDesignTokens.gradGreen),
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
              KayanLightTopBar(title: ar ? 'ما الجديد' : "What's new", onBack: () => context.pop()),
              const SizedBox(height: 8),
              Text(ar ? 'آخر التحديثات في كيان' : 'Latest KAYAN updates', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final item in _items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            border: Border.all(color: KayanDesignTokens.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(gradient: item.$6, borderRadius: BorderRadius.circular(12)),
                                child: Icon(item.$5, color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ar ? item.$1 : item.$2, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                                    Text(ar ? item.$3 : item.$4, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                                  ],
                                ),
                              ),
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
