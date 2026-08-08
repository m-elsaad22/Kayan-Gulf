import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../routing/app_routes.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/widgets/design/kayan_design_widgets.dart';
import '../../shared/widgets/design/kayan_entry_widgets.dart';

/// نتائج البحث المتقدم — light design
class AdvancedSearchResultsScreen extends ConsumerStatefulWidget {
  const AdvancedSearchResultsScreen({super.key});

  @override
  ConsumerState<AdvancedSearchResultsScreen> createState() => _AdvancedSearchResultsScreenState();
}

class _AdvancedSearchResultsScreenState extends ConsumerState<AdvancedSearchResultsScreen> {
  final _queryCtrl = TextEditingController();
  int _sectionTab = 0;

  static const _results = [
    ('تنظيف منزلي', 'خدمات', '120 ر.س'),
    ('آيفون 15 برو', 'متجر', '4,299 ر.س'),
    ('كامري 2022', 'إعلانات', '85,000 ر.س'),
  ];

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final tabs = ar ? ['الكل', 'خدمات', 'متجر', 'إعلانات'] : ['All', 'Services', 'Shop', 'Ads'];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'بحث متقدم' : 'Advanced search', onBack: () => context.pop()),
              const SizedBox(height: 12),
              KayanDesignTextField(
                label: ar ? 'كلمة البحث' : 'Search query',
                controller: _queryCtrl,
                hint: ar ? 'ابحث في كل الأقسام...' : 'Search all sections...',
                icon: Icons.search_rounded,
              ),
              const SizedBox(height: 12),
              KayanFilterSlotRow(labels: tabs, selectedIndex: _sectionTab, onSelected: (i) => setState(() => _sectionTab = i)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final r in _results)
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
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: KayanDesignTokens.gradBlue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.$1, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                                    Text('${r.$2} • ${r.$3}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
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
              KayanCtaButton(
                label: ar ? 'فلاتر متقدمة' : 'Advanced filters',
                variant: KayanCtaVariant.blue,
                trailingIcon: Icons.tune_rounded,
                onPressed: () => context.push(AppRoutes.shopFilters),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
