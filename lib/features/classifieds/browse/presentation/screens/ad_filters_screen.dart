// Advanced search filters — matches design/html/118-cl-search-filters.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../data/models/ad_models.dart';

class AdFiltersScreen extends ConsumerStatefulWidget {
  const AdFiltersScreen({super.key});

  @override
  ConsumerState<AdFiltersScreen> createState() => _AdFiltersScreenState();
}

class _AdFiltersScreenState extends ConsumerState<AdFiltersScreen> {
  final _keywordCtrl = TextEditingController(text: '');
  final _cityCtrl = TextEditingController(text: 'الرياض');

  int _categoryIndex = 0;
  RangeValues _priceRange = const RangeValues(5000, 90000);

  static const _categorySlugs = ['vehicles', 'realestate', 'electronics', 'jobs'];

  @override
  void dispose() {
    _keywordCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  List<String> _categoryLabels(bool ar) {
    final names = mockAdCategories
        .where((c) => _categorySlugs.contains(c.slug))
        .map((c) => ar ? c.nameAr : c.nameEn)
        .toList();
    return names.length == _categorySlugs.length
        ? names
        : (ar ? ['سيارات', 'عقارات', 'إلكترونيات', 'وظائف'] : ['Cars', 'Property', 'Electronics', 'Jobs']);
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'بحث متقدم' : 'Advanced search',
                onBack: () => context.pop(),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    KayanDesignTextField(
                      label: ar ? 'الكلمة المفتاحية' : 'Keyword',
                      hint: ar ? 'مثال: كامري 2023' : 'e.g. Camry 2023',
                      icon: Icons.search_rounded,
                      controller: _keywordCtrl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ar ? 'القسم' : 'Category',
                      style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2),
                    ),
                    const SizedBox(height: 10),
                    KayanFilterSlotRow(
                      labels: _categoryLabels(ar),
                      selectedIndex: _categoryIndex,
                      onSelected: (i) => setState(() => _categoryIndex = i),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      ar ? 'نطاق السعر' : 'Price range',
                      style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2),
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: KayanDesignTokens.kBlue,
                        inactiveTrackColor: KayanDesignTokens.border,
                        thumbColor: Colors.white,
                        overlayColor: KayanDesignTokens.kBlue.withValues(alpha: 0.12),
                        rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 9, elevation: 2),
                        rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                      ),
                      child: RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 200000,
                        divisions: 40,
                        onChanged: (v) => setState(() => _priceRange = v),
                      ),
                    ),
                    Text(
                      '${_priceRange.start.toInt()} — ${_priceRange.end.toInt()} ${ar ? 'ر.س' : 'SAR'}',
                      textAlign: TextAlign.center,
                      style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlueDeep),
                    ),
                    const SizedBox(height: 18),
                    KayanDesignTextField(
                      label: ar ? 'المدينة' : 'City',
                      hint: ar ? 'الرياض' : 'Riyadh',
                      icon: Icons.location_on_outlined,
                      controller: _cityCtrl,
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تطبيق البحث' : 'Apply search',
                variant: KayanCtaVariant.blue,
                onPressed: () => context.pop(true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
