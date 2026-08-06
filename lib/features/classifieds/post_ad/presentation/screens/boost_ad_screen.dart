// Promote ad — matches design/html/124-cl-promote-ad.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class BoostAdScreen extends ConsumerStatefulWidget {
  const BoostAdScreen({super.key, required this.adId});

  final String adId;

  @override
  ConsumerState<BoostAdScreen> createState() => _BoostAdScreenState();
}

class _BoostAdScreenState extends ConsumerState<BoostAdScreen> {
  int _plan = 1;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final plans = ar
        ? ['تمييز 3 أيام — 20 ر.س', 'تمييز 7 أيام — 40 ر.س', 'تمييز 30 يوم — 120 ر.س']
        : ['Boost 3 days — 20 SAR', 'Boost 7 days — 40 SAR', 'Boost 30 days — 120 SAR'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'تمييز إعلانك' : 'Promote your ad',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 8),
              Text(
                ar
                    ? 'وصّل إعلانك لعدد أكبر من المهتمين بظهوره في أعلى النتائج'
                    : 'Reach more buyers by appearing at the top of search results',
                style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.text2, height: 1.8),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: List.generate(plans.length, (index) {
                    return KayanPayOptionRow(
                      label: plans[index],
                      icon: Icons.star_rounded,
                      selected: _plan == index,
                      onTap: () => setState(() => _plan = index),
                    );
                  }),
                ),
              ),
              KayanCtaButton(
                label: ar ? 'ادفع وميّز الإعلان' : 'Pay and promote',
                variant: KayanCtaVariant.blue,
                loading: _loading,
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() => _loading = true);
                        await Future.delayed(const Duration(seconds: 1));
                        if (!context.mounted) return;
                        setState(() => _loading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ar ? 'تم تمييز الإعلان بنجاح ⭐' : 'Ad promoted successfully ⭐'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        context.pop();
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
