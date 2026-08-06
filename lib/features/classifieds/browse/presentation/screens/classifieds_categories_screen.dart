// All classifieds categories — matches design/html/114-cl-categories.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

const _categories = [
  (Icons.directions_car_rounded, 'سيارات', 'Cars', 'vehicles'),
  (Icons.two_wheeler_rounded, 'دراجات نارية', 'Motorcycles', 'vehicles'),
  (Icons.apartment_rounded, 'عقارات للبيع', 'Property for sale', 'realestate'),
  (Icons.key_rounded, 'عقارات للإيجار', 'Property for rent', 'realestate'),
  (Icons.work_rounded, 'وظائف شاغرة', 'Jobs', 'jobs'),
  (Icons.chair_rounded, 'أثاث ومنزل', 'Furniture', 'furniture'),
  (Icons.smartphone_rounded, 'موبايل وتابلت', 'Mobile & tablet', 'electronics'),
  (Icons.laptop_mac_rounded, 'لابتوب وكمبيوتر', 'Laptops', 'electronics'),
  (Icons.storefront_rounded, 'متاجر', 'Shops', 'other'),
];

class ClassifiedsCategoriesScreen extends ConsumerWidget {
  const ClassifiedsCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'جميع الأقسام' : 'All categories',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.pop(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final c = _categories[index];
                  return KayanCategoryGridTile(
                    label: ar ? c.$2 : c.$3,
                    icon: c.$1,
                    onTap: () => context.push(AppRoutes.adsList),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
