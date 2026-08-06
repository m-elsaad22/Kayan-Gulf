// Report ad — matches design/html/121-cl-report-ad.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class ReportAdScreen extends ConsumerStatefulWidget {
  const ReportAdScreen({super.key, required this.adSlug});

  final String adSlug;

  @override
  ConsumerState<ReportAdScreen> createState() => _ReportAdScreenState();
}

class _ReportAdScreenState extends ConsumerState<ReportAdScreen> {
  int _reasonIndex = 0;
  final _detailsCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final reasons = ar
        ? [
            ('محتوى مخالف أو احتيالي', Icons.block_rounded),
            ('إعلان مكرر', Icons.copy_rounded),
            ('سعر غير صحيح', Icons.sell_outlined),
            ('سبب آخر', Icons.more_horiz_rounded),
          ]
        : [
            ('Fraudulent content', Icons.block_rounded),
            ('Duplicate ad', Icons.copy_rounded),
            ('Incorrect price', Icons.sell_outlined),
            ('Other reason', Icons.more_horiz_rounded),
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'الإبلاغ عن إعلان' : 'Report ad',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 8),
              Text(
                ar
                    ? 'ساعدنا في الحفاظ على جودة الإعلانات بالإبلاغ عن أي محتوى مخالف'
                    : 'Help us maintain ad quality by reporting violations',
                style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.text2, height: 1.8),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: [
                    ...List.generate(reasons.length, (index) {
                      final r = reasons[index];
                      return KayanReportReasonRow(
                        title: r.$1,
                        icon: r.$2,
                        selected: _reasonIndex == index,
                        onTap: () => setState(() => _reasonIndex = index),
                      );
                    }),
                    const SizedBox(height: 10),
                    KayanDesignTextField(
                      label: ar ? 'تفاصيل إضافية' : 'Additional details',
                      hint: ar ? 'اكتب التفاصيل...' : 'Write details...',
                      icon: Icons.sticky_note_2_outlined,
                      controller: _detailsCtrl,
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'إرسال البلاغ' : 'Submit report',
                variant: KayanCtaVariant.blue,
                loading: _submitting,
                onPressed: _submitting
                    ? null
                    : () async {
                        setState(() => _submitting = true);
                        await Future.delayed(const Duration(milliseconds: 800));
                        if (!context.mounted) return;
                        setState(() => _submitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(ar ? 'تم إرسال البلاغ' : 'Report submitted')),
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
