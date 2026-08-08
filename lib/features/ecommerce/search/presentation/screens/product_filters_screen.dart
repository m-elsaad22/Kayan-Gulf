import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// فلاتر المنتجات — light design
class ProductFiltersScreen extends ConsumerStatefulWidget {
  const ProductFiltersScreen({super.key});

  @override
  ConsumerState<ProductFiltersScreen> createState() => _ProductFiltersScreenState();
}

class _ProductFiltersScreenState extends ConsumerState<ProductFiltersScreen> {
  int _priceTab = 0;
  int _ratingTab = 0;
  int _brandTab = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final priceLabels = ar ? ['الكل', 'أقل من 200', '200–1000', '1000+'] : ['All', 'Under 200', '200–1000', '1000+'];
    final ratingLabels = ar ? ['الكل', '4+', '4.5+'] : ['All', '4+', '4.5+'];
    final brandLabels = ar ? ['الكل', 'Apple', 'Samsung', 'Sony'] : ['All', 'Apple', 'Samsung', 'Sony'];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'فلاتر المنتجات' : 'Product filters', onBack: () => context.pop()),
              const SizedBox(height: 16),
              Text(ar ? 'السعر' : 'Price', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              KayanFilterSlotRow(labels: priceLabels, selectedIndex: _priceTab, onSelected: (i) => setState(() => _priceTab = i)),
              const SizedBox(height: 16),
              Text(ar ? 'التقييم' : 'Rating', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              KayanFilterSlotRow(labels: ratingLabels, selectedIndex: _ratingTab, onSelected: (i) => setState(() => _ratingTab = i)),
              const SizedBox(height: 16),
              Text(ar ? 'العلامة التجارية' : 'Brand', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
              const SizedBox(height: 8),
              KayanFilterSlotRow(labels: brandLabels, selectedIndex: _brandTab, onSelected: (i) => setState(() => _brandTab = i)),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'تطبيق الفلاتر' : 'Apply filters',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم تطبيق الفلاتر' : 'Filters applied')),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
