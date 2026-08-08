// Rate app — light design (20-rate-app.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class RateAppScreen extends ConsumerStatefulWidget {
  const RateAppScreen({super.key});

  @override
  ConsumerState<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends ConsumerState<RateAppScreen> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'قيّم التطبيق' : 'Rate app', onBack: () => context.pop()),
              const SizedBox(height: 30),
              Text(ar ? 'كيف تقيّم تجربة كيان؟' : 'How do you rate KAYAN?', textAlign: TextAlign.center, style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return IconButton(
                    onPressed: () => setState(() => _rating = star),
                    icon: Icon(star <= _rating ? Icons.star_rounded : Icons.star_border_rounded, color: KayanDesignTokens.gold, size: 36),
                  );
                }),
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'إرسال التقييم' : 'Submit rating',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.gold,
                onPressed: _rating == 0
                    ? null
                    : () {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ar ? 'شكراً لتقييمك!' : 'Thanks!'), behavior: SnackBarBehavior.floating));
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
