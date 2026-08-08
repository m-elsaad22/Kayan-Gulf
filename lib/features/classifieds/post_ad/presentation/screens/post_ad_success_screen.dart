import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// نجاح نشر الإعلان — light design
class PostAdSuccessScreen extends ConsumerWidget {
  const PostAdSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(gradient: KayanDesignTokens.gradGreen, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 52, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(ar ? 'تم نشر الإعلان!' : 'Ad published!', style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
              const SizedBox(height: 8),
              Text(
                ar ? 'سيظهر إعلانك للمستخدمين خلال دقائق' : 'Your ad will appear to users within minutes',
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 32),
              KayanCtaButton(
                label: ar ? 'إعلاناتي' : 'My ads',
                variant: KayanCtaVariant.blue,
                trailingIcon: Icons.campaign_outlined,
                onPressed: () => context.go(AppRoutes.myAds),
              ),
              const SizedBox(height: 10),
              KayanCtaButton(
                label: ar ? 'تمييز الإعلان' : 'Boost ad',
                variant: KayanCtaVariant.gold,
                trailingIcon: Icons.rocket_launch_rounded,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
