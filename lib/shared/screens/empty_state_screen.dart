import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../routing/app_routes.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/widgets/design/kayan_entry_widgets.dart';

/// حالة فارغة — light design
class EmptyStateScreen extends ConsumerWidget {
  const EmptyStateScreen({super.key, this.title, this.message});

  final String? title;
  final String? message;

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
                decoration: BoxDecoration(
                  color: KayanDesignTokens.kBlue.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.inbox_outlined, size: 48, color: KayanDesignTokens.kBlue),
              ),
              const SizedBox(height: 20),
              Text(
                title ?? (ar ? 'لا يوجد محتوى' : 'Nothing here yet'),
                style: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep),
              ),
              const SizedBox(height: 8),
              Text(
                message ?? (ar ? 'لم نجد أي عناصر لعرضها حالياً' : 'We could not find any items to show'),
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 28),
              KayanCtaButton(
                label: ar ? 'العودة للرئيسية' : 'Go to home',
                variant: KayanCtaVariant.blue,
                trailingIcon: Icons.home_rounded,
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
