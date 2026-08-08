import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// الإبلاغ عن مشكلة — light design
class ReportIssueScreen extends ConsumerStatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  ConsumerState<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends ConsumerState<ReportIssueScreen> {
  final _titleCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _detailsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'الإبلاغ عن مشكلة' : 'Report issue', onBack: () => context.pop()),
              const SizedBox(height: 12),
              KayanDesignTextField(
                label: ar ? 'عنوان المشكلة' : 'Issue title',
                controller: _titleCtrl,
                hint: ar ? 'تأخر الفني' : 'Technician delay',
                icon: Icons.report_outlined,
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                label: ar ? 'وصف تفصيلي' : 'Detailed description',
                controller: _detailsCtrl,
                hint: ar ? 'اشرح المشكلة...' : 'Describe the issue...',
                icon: Icons.notes_rounded,
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(ar ? 'رفع صورة' : 'Upload photo'),
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'إرسال الشكوى' : 'Submit report',
                variant: KayanCtaVariant.orange,
                trailingIcon: Icons.send_rounded,
                onPressed: () {
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
