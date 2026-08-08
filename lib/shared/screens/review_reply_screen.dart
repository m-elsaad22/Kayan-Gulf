import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/widgets/design/kayan_design_widgets.dart';
import '../../shared/widgets/design/kayan_entry_widgets.dart';

/// الرد على تقييم — light design
class ReviewReplyScreen extends ConsumerStatefulWidget {
  const ReviewReplyScreen({super.key});

  @override
  ConsumerState<ReviewReplyScreen> createState() => _ReviewReplyScreenState();
}

class _ReviewReplyScreenState extends ConsumerState<ReviewReplyScreen> {
  final _replyCtrl = TextEditingController();

  @override
  void dispose() {
    _replyCtrl.dispose();
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
              KayanLightTopBar(title: ar ? 'رد على التقييم' : 'Reply to review', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                  border: Border.all(color: KayanDesignTokens.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('سارة أحمد', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Text('⭐ 5', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ar ? 'خدمة ممتازة والفني محترف جداً' : 'Excellent service, very professional technician',
                      style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              KayanDesignTextField(
                label: ar ? 'ردك' : 'Your reply',
                controller: _replyCtrl,
                hint: ar ? 'اكتب ردك هنا...' : 'Write your reply...',
                icon: Icons.reply_rounded,
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'إرسال الرد' : 'Send reply',
                variant: KayanCtaVariant.blue,
                trailingIcon: Icons.send_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم إرسال الرد' : 'Reply sent')),
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
