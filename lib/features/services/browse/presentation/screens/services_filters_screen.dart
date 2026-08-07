// Service filters — light design (32-hs-filters.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class ServicesFiltersScreen extends ConsumerStatefulWidget {
  const ServicesFiltersScreen({super.key});

  @override
  ConsumerState<ServicesFiltersScreen> createState() => _ServicesFiltersScreenState();
}

class _ServicesFiltersScreenState extends ConsumerState<ServicesFiltersScreen> {
  int _priceTab = 0;
  int _ratingTab = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final priceLabels = ar ? ['الكل', 'أقل من 100', '100–300', '300+'] : ['All', 'Under 100', '100–300', '300+'];
    final ratingLabels = ar ? ['الكل', '4+', '4.5+'] : ['All', '4+', '4.5+'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'فلاتر الخدمات' : 'Service filters', onBack: () => context.pop()),
              const SizedBox(height: 16),
              Text(ar ? 'السعر' : 'Price', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              KayanFilterSlotRow(labels: priceLabels, selectedIndex: _priceTab, onSelected: (i) => setState(() => _priceTab = i)),
              const SizedBox(height: 16),
              Text(ar ? 'التقييم' : 'Rating', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              KayanFilterSlotRow(labels: ratingLabels, selectedIndex: _ratingTab, onSelected: (i) => setState(() => _ratingTab = i)),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'تطبيق الفلاتر' : 'Apply filters',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.green,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
