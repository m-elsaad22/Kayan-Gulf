// Global chat room — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../data/models/chat_models.dart';

class ChatLightScreen extends ConsumerStatefulWidget {
  const ChatLightScreen({
    super.key,
    required this.convId,
    this.adTitle,
    this.adImage,
  });

  final String convId;
  final String? adTitle;
  final String? adImage;

  @override
  ConsumerState<ChatLightScreen> createState() => _ChatLightScreenState();
}

class _ChatLightScreenState extends ConsumerState<ChatLightScreen> {
  final _msgCtrl = TextEditingController();
  late final Conversation _conv;
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _conv = mockConversations.firstWhere(
      (c) => c.id == widget.convId,
      orElse: () => mockConversations.first,
    );
    _messages = List.from(buildMockMessages()[widget.convId] ?? [
      ChatMessage(
        id: 'fallback',
        senderId: _conv.otherUserId,
        content: _conv.lastMessage?.content ?? 'مرحباً',
        createdAt: DateTime.now(),
        isMe: false,
      ),
    ]);
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        id: 'local-${DateTime.now().millisecondsSinceEpoch}',
        senderId: 'me',
        content: text,
        createdAt: DateTime.now(),
        isMe: true,
        status: MessageStatus.sent,
      ));
      _msgCtrl.clear();
    });
  }

  String _timeLabel(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'م' : 'ص';
    return '$h:$m $p';
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final title = widget.adTitle ?? (ar ? _conv.contextTitleAr : _conv.contextTitleEn) ?? _conv.otherUserName;
    final initial = _conv.otherUserName.isNotEmpty ? _conv.otherUserName[0] : '?';

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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(initial, style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_conv.otherUserName, style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                        if (_conv.otherIsOnline)
                          Text(ar ? 'متصل الآن' : 'Online', style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.kGreen)),
                      ],
                    ),
                  ),
                  KayanHeroIconButton(icon: Icons.more_vert_rounded, light: true, onTap: () {}),
                ],
              ),
              if (_conv.contextPrice != null || _conv.contextTitleAr != null) ...[
                const SizedBox(height: 10),
                KayanClassifiedAdCard(
                  title: title,
                  locationLine: ar ? 'محادثة كيان' : 'KAYAN chat',
                  priceLabel: _conv.contextPrice != null ? '${_conv.contextPrice!.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}' : '',
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () {},
                ),
              ],
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: _messages.map((m) {
                    if (m.isSystem) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(m.content, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                        ),
                      );
                    }
                    return _Bubble(text: m.content, time: _timeLabel(m.createdAt), mine: m.isMe);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: KayanDesignTokens.bg,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: KayanDesignTokens.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined, color: KayanDesignTokens.muted, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _msgCtrl,
                        style: KayanDesignTokens.cairo(fontSize: 13.5),
                        decoration: InputDecoration(
                          hintText: ar ? 'اكتب رسالتك...' : 'Type a message...',
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: KayanDesignTokens.cairo(fontSize: 13.5, color: KayanDesignTokens.muted),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    GestureDetector(
                      onTap: _send,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.time, required this.mine});

  final String text;
  final String time;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          gradient: mine ? KayanDesignTokens.gradBlue : null,
          color: mine ? null : KayanDesignTokens.bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(mine ? 5 : 18),
            bottomRight: Radius.circular(mine ? 18 : 5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: KayanDesignTokens.cairo(fontSize: 13, height: 1.6, color: mine ? Colors.white : KayanDesignTokens.text),
            ),
            const SizedBox(height: 5),
            Text(time, style: KayanDesignTokens.cairo(fontSize: 10, color: mine ? Colors.white70 : KayanDesignTokens.muted)),
          ],
        ),
      ),
    );
  }
}
