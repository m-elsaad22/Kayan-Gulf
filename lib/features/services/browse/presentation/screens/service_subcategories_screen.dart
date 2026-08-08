// Service subcategories — light design (40-hs-subcategories.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

class ServiceSubcategoriesScreen extends ConsumerWidget {
  const ServiceSubcategoriesScreen({super.key});

  static const _items = [
    (Icons.ac_unit_rounded, 'تكييف سبليت', 'Split AC'),
    (Icons.plumbing_rounded, 'إصلاحات سباكة', 'Plumbing'),
    (Icons.cleaning_services_rounded, 'تنظيف عميق', 'Deep cleaning'),
    (Icons.electrical_services_rounded, 'كهرباء منزلية', 'Electrical'),
    (Icons.format_paint_rounded, 'دهانات', 'Painting'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'الفئات الفرعية' : 'Subcategories', onBack: () => context.pop()),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: _items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: KayanCategoryGridTile(
                        icon: item.$1,
                        label: ar ? item.$2 : item.$3,
                        iconGradient: KayanDesignTokens.gradGreen,
                        onTap: () => context.push('${AppRoutes.services}/browse'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
