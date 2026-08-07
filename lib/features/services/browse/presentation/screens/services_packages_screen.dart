// Service packages — light design (40b-hs-packages.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class ServicesPackagesScreen extends ConsumerWidget {
  const ServicesPackagesScreen({super.key});

  static const _packages = [
    ('باقة تنظيف شهرية', 'Monthly cleaning', '199', Icons.cleaning_services_rounded),
    ('باقة صيانة تكييف', 'AC maintenance', '299', Icons.ac_unit_rounded),
    ('باقة سباكة شاملة', 'Plumbing bundle', '249', Icons.plumbing_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'باقات الخدمات' : 'Service packages',
            variant: KayanSectionHeroVariant.green,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: _packages.map((p) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: KayanDesignTokens.border),
                    boxShadow: KayanDesignTokens.shadowS,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(gradient: KayanDesignTokens.gradGreen, borderRadius: BorderRadius.circular(14)),
                        child: Icon(p.$4, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ar ? p.$1 : p.$2, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                            Text('${p.$3} ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontSize: 14, fontWeight: FontWeight.w900, color: KayanDesignTokens.kGreen)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push(AppRoutes.serviceBookPath('svc-1')),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: KayanDesignTokens.kGreen),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
