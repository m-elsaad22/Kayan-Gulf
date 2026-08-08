// Live chat — light design (19-live-chat.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

class _Msg {
  const _Msg(this.text, this.mine);
  final String text;
  final bool mine;
}

class LiveChatScreen extends ConsumerStatefulWidget {
  const LiveChatScreen({super.key});

  @override
  ConsumerState<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends ConsumerState<LiveChatScreen> {
  final _ctrl = TextEditingController();
  final _messages = <_Msg>[
    const _Msg('مرحباً! كيف يمكننا مساعدتك؟', false),
    const _Msg('عندي سؤال عن طلبي', true),
    const _Msg('بكل سرور، أرسل رقم الطلب.', false),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _messages.add(_Msg(t, true));
      _ctrl.clear();
    });
  }

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
              Row(
                children: [
                  KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, light: true, onTap: () => context.pop()),
                  const SizedBox(width: 8),
                  Text(ar ? 'دعم كيان' : 'KAYAN Support', style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: _messages.map((m) {
                    return Align(
                      alignment: m.mine ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          gradient: m.mine ? KayanDesignTokens.gradBlue : null,
                          color: m.mine ? null : KayanDesignTokens.bg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(m.text, style: KayanDesignTokens.cairo(fontSize: 13, color: m.mine ? Colors.white : KayanDesignTokens.text)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: KayanDesignTokens.bg, borderRadius: BorderRadius.circular(99), border: Border.all(color: KayanDesignTokens.border)),
                      child: TextField(
                        controller: _ctrl,
                        decoration: InputDecoration(hintText: ar ? 'اكتب رسالة...' : 'Type a message...', border: InputBorder.none),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
