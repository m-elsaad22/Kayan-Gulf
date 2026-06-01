// ============================================================
// KAYAN — Services List Screen
// lib/features/services/browse/presentation/screens/services_list_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../../data/models/services_models.dart';
import '../../presentation/providers/services_providers.dart';

class ServicesListScreen extends ConsumerWidget {
  final String? categoryId;
  const ServicesListScreen({super.key, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);
    final services = ref.watch(servicesListProvider(categoryId));

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Text(
          isArabic ? 'الخدمات' : 'Services',
          style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(isArabic
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: services.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const ShimmerBox(
            width: double.infinity, height: 120,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? Center(
                child: Text(
                  isArabic ? 'لا توجد خدمات في هذه الفئة' : 'No services in this category',
                  style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _ServiceListTile(
                  service: list[i], isArabic: isArabic,
                  onTap: () => context.push(AppRoutes.servicePath(list[i].slug)),
                ),
              ),
      ),
    );
  }
}

class _ServiceListTile extends StatelessWidget {
  final ServiceModel service;
  final bool         isArabic;
  final VoidCallback onTap;
  const _ServiceListTile({
    required this.service, required this.isArabic, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color:        AppColors.bgCard,
        borderRadius: AppBorderRadius.card,
        border:       Border.all(color: service.isEmergency
            ? AppColors.error.withOpacity(0.3) : AppColors.borderSubtle),
      ),
      child: Row(children: [
        if (service.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(AppBorderRadius.card.topLeft.x)),
            child: Image.network(service.imageUrl!,
                width: 100, height: 100, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100, height: 100, color: AppColors.bgCard2,
                  child: const Icon(Icons.build_outlined,
                      color: AppColors.textMuted))),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (service.isEmergency)
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error, borderRadius: BorderRadius.circular(5)),
                  child: const Text('🚨 طوارئ',
                      style: TextStyle(fontSize: 8, color: Colors.white,
                          fontWeight: FontWeight.w700))),
              Text(isArabic ? service.nameAr : service.nameEn,
                  style: isArabic ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall,
                  maxLines: 2),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star_rounded, size: 12, color: AppColors.starFilled),
                const SizedBox(width: 3),
                Text(service.rating.toStringAsFixed(1), style: AppTextStyles.caption),
                const SizedBox(width: 8),
                const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 3),
                Text(service.durationLabel, style: AppTextStyles.caption),
              ]),
              const SizedBox(height: 6),
              Text('${service.basePrice.toInt()} ر.س',
                  style: AppTextStyles.priceMedium),
            ]),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child:   Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.textMuted),
        ),
      ]),
    ),
  );
}
