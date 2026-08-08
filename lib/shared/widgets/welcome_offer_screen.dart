// Welcome offer — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../providers/locale_provider.dart';
import '../widgets/design/kayan_design_widgets.dart';
import '../widgets/design/kayan_entry_widgets.dart';

class WelcomeOfferScreen extends ConsumerWidget {
  const WelcomeOfferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded)),
              ),
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(gradient: KayanDesignTokens.gradOrange, shape: BoxShape.circle),
                child: const Icon(Icons.card_giftcard_rounded, size: 44, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                ar ? 'هدية ترحيب 🎁' : 'Welcome gift 🎁',
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(fontSize: 24, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep),
              ),
              const SizedBox(height: 12),
              Text(
                ar ? 'احصل على خصم 15% على أول طلب لك في كيان.' : 'Get 15% off your first KAYAN order.',
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.muted, height: 1.6),
              ),
              const Spacer(),
              KayanOfferBanner(
                title: ar ? 'كود: WELCOME15' : 'Code: WELCOME15',
                subtitle: ar ? 'صالح لمدة 7 أيام' : 'Valid for 7 days',
                gradient: KayanDesignTokens.gradOrange,
              ),
              const SizedBox(height: 16),
              KayanCtaButton(label: ar ? 'استخدم العرض' : 'Claim offer', variant: KayanCtaVariant.orange, onPressed: () => context.pop()),
              TextButton(onPressed: () => context.pop(), child: Text(ar ? 'تخطي' : 'Skip', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.muted))),
            ],
          ),
        ),
      ),
    );
  }
}
