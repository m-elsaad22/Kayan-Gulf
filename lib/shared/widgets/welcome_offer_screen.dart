// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../providers/locale_provider.dart';

class WelcomeOfferScreen extends ConsumerWidget {
  const WelcomeOfferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.heroDiagonal),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              const Spacer(),
              const Icon(Icons.card_giftcard_rounded,
                  size: 80, color: AppColors.metallicGold),
              const SizedBox(height: 24),
              Text(
                ar ? 'هدية ترحيب 🎁' : 'Welcome Gift 🎁',
                textAlign: TextAlign.center,
                style: ar
                    ? AppTextStyles.arabicHeadlineMedium
                    : AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                ar
                    ? 'احصل على خصم 15% على أول طلب لك في كيان.'
                    : 'Get 15% off your first KAYAN order.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.pop(),
                child: Text(ar ? 'استخدم العرض' : 'Claim Offer'),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(ar ? 'تخطي' : 'Skip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
