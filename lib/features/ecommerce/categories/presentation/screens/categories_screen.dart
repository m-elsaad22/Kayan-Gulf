// KAYAN — Categories Screen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/services/admin_data_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final categories = AdminDataService.instance.getCategories();

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle: true,
        title: Text(
          ar ? 'الفئات' : 'Categories',
          style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(
            ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
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
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: AppBorderRadius.card,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: c.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.bgCard2,
                        child: const Icon(Icons.category_outlined, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      ar ? c.nameAr : c.nameEn,
                      style: (ar ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall)
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
