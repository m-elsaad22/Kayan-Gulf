// Shop categories — light design
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/admin_data_service.dart';
import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final categories = AdminDataService.instance.getCategories();

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'الفئات' : 'Categories',
            variant: KayanSectionHeroVariant.orange,
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
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final c = categories[i];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push(AppRoutes.productListPath(c.id));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        border: Border.all(color: KayanDesignTokens.border),
                        boxShadow: KayanDesignTokens.shadowS,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              imageUrl: c.imageUrl,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: KayanDesignTokens.gradOrange,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.category_outlined, color: Colors.white, size: 26),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ar ? c.nameAr : c.nameEn,
                            style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
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
