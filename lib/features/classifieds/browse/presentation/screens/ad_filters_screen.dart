// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../data/models/ad_models.dart';

final _minPriceProvider = StateProvider<double>((_) => 0);
final _maxPriceProvider = StateProvider<double>((_) => 50000);
final _conditionProvider = StateProvider<AdCondition?>((_) => null);

class AdFiltersScreen extends ConsumerWidget {
  const AdFiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final minPrice = ref.watch(_minPriceProvider);
    final maxPrice = ref.watch(_maxPriceProvider);
    final condition = ref.watch(_conditionProvider);

    return Phase5ClassifiedsScaffold(
      titleAr: 'تصفية الإعلانات',
      titleEn: 'Ad Filters',
      subtitleAr: 'حدّد السعر والحالة والفئة.',
      subtitleEn: 'Filter by price, condition, and category.',
      children: [
        Text(
          ar ? 'نطاق السعر (ر.س)' : 'Price range (SAR)',
          style: ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall,
        ),
        RangeSlider(
          values: RangeValues(minPrice, maxPrice),
          max: 100000,
          divisions: 20,
          onChanged: (v) {
            ref.read(_minPriceProvider.notifier).state = v.start;
            ref.read(_maxPriceProvider.notifier).state = v.end;
          },
        ),
        Text('${minPrice.toInt()} — ${maxPrice.toInt()}'),
        const SizedBox(height: 16),
        Text(
          ar ? 'الحالة' : 'Condition',
          style: ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall,
        ),
        Wrap(
          spacing: 8,
          children: AdCondition.values.map((c) {
            final selected = condition == c;
            return FilterChip(
              label: Text(ar ? c.labelAr() : c.labelEn()),
              selected: selected,
              onSelected: (_) => ref.read(_conditionProvider.notifier).state =
                  selected ? null : c,
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(ar ? 'تطبيق الفلاتر' : 'Apply Filters'),
        ),
      ],
    );
  }
}