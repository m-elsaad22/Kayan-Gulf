import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// البحث عن الخدمات — light design
class SearchServicesScreen extends ConsumerStatefulWidget {
  const SearchServicesScreen({super.key});

  @override
  ConsumerState<SearchServicesScreen> createState() => _SearchServicesScreenState();
}

class _SearchServicesScreenState extends ConsumerState<SearchServicesScreen> {
  final _queryCtrl = TextEditingController();

  static const _recent = ['تنظيف منزلي', 'سباكة', 'تكييف', 'كهرباء'];
  static const _results = [
    ('تنظيف شقة', '4.8', '120 ر.س'),
    ('سباك معتمد', '4.9', '150 ر.س'),
    ('صيانة مكيف', '4.7', '99 ر.س'),
  ];

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'بحث الخدمات' : 'Search services', onBack: () => context.pop()),
              const SizedBox(height: 12),
              KayanDesignTextField(
                label: ar ? 'ابحث عن خدمة' : 'Search for a service',
                controller: _queryCtrl,
                hint: ar ? 'تنظيف، سباكة، كهرباء...' : 'Cleaning, plumbing...',
                icon: Icons.search_rounded,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(ar ? 'عمليات البحث الأخيرة' : 'Recent searches', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(ar ? 'مسح' : 'Clear', style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue)),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recent.map((r) => GestureDetector(
                  onTap: () => setState(() => _queryCtrl.text = r),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: KayanDesignTokens.border)),
                    child: Text(r, style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final r in _results)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.servicePath('cleaning')),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM), border: Border.all(color: KayanDesignTokens.border)),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(gradient: KayanDesignTokens.gradGreen, borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.home_repair_service_outlined, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(r.$1, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                                      Text('${r.$2} ⭐ • ${r.$3}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'فلاتر متقدمة' : 'Advanced filters',
                variant: KayanCtaVariant.green,
                trailingIcon: Icons.tune_rounded,
                onPressed: () => context.push(AppRoutes.advancedServiceFilters),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
