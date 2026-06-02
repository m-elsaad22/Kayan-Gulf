// ============================================================
// KAYAN — Chat Screen
// lib/features/chat/presentation/screens/chat_screen.dart
//
// Features:
//   • Context header (product/service/ad card with price + action)
//   • Message bubbles: text, image, system info
//   • Sent/delivered/read tick marks (blue ticks)
//   • Typing indicator animation
//   • Date separators between messages
//   • Quick reply chips (predefined messages)
//   • Input bar: text field + camera + send (animated)
//   • Auto-scroll to bottom on new messages
//   • Long-press message actions (copy, delete)
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../chat/data/models/chat_models.dart';

// ──────────────────────────────────────────────────────────────
// PROVIDERS
// ──────────────────────────────────────────────────────────────

final _messagesProvider =
    StateProvider.autoDispose.family<List<ChatMessage>, String>((ref, convId) {
  return buildMockMessages()[convId] ?? [];
});

final _typingProvider = StateProvider.autoDispose<bool>((_) => false);

class ChatScreen extends ConsumerStatefulWidget {
  final String convId;
  final String? adTitle;
  final String? adImage;
  const ChatScreen({
    super.key,
    required this.convId,
    this.adTitle,
    this.adImage,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _inputCtrl   = TextEditingController();
  final _scrollCtrl  = ScrollController();
  final _inputFocus  = FocusNode();
  bool  _showQuicks  = true;
  Timer? _typingTimer;

  // The conversation metadata
  late final Conversation _conv;

  @override
  void initState() {
    super.initState();
    _conv = mockConversations.firstWhere(
      (c) => c.id == widget.convId,
      orElse: () => mockConversations.first,
    );
    // Scroll to bottom after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _inputFocus.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _scrollToBottom({bool animate = false}) {
    if (!_scrollCtrl.hasClients) return;
    if (animate) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve:    Curves.easeOut,
      );
    } else {
      _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
    }
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    _inputCtrl.clear();
    setState(() => _showQuicks = false);

    // Add message to state
    final newMsg = ChatMessage(
      id:        'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId:  'me',
      content:   content.trim(),
      type:      MessageType.text,
      status:    MessageStatus.sent,
      createdAt: DateTime.now(),
      isMe:      true,
    );

    ref.read(_messagesProvider(widget.convId).notifier).update((msgs) => [...msgs, newMsg]);

    // Simulate reply after delay
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(animate: true));
    _simulateReply();
  }

  void _simulateReply() {
    // Show typing...
    ref.read(_typingProvider.notifier).state = true;
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      ref.read(_typingProvider.notifier).state = false;

      final replies = [
        'حسناً، شكراً لتواصلك معي',
        'سأتحقق وأرد عليك قريباً',
        'يمكنني الاجتماع غداً إن شئت',
        'هذا عرض مناسب، دعني أفكر',
        'هل يمكنك إرسال صورة واضحة؟',
      ];
      final reply = replies[DateTime.now().millisecond % replies.length];

      final replyMsg = ChatMessage(
        id:        'reply_${DateTime.now().millisecondsSinceEpoch}',
        senderId:  _conv.otherUserId,
        content:   reply,
        createdAt: DateTime.now(),
        isMe:      false,
      );
      if (mounted) {
        ref.read(_messagesProvider(widget.convId).notifier)
            .update((msgs) => [...msgs, replyMsg]);
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(animate: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final messages = ref.watch(_messagesProvider(widget.convId));
    final isTyping = ref.watch(_typingProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        appBar: _ChatAppBar(conv: _conv, isArabic: isArabic),

        body: Column(children: [
          // ── Context Header ──────────────────────────────
          if (_conv.contextTitleAr != null)
            _ContextHeader(conv: _conv, isArabic: isArabic),

          // ── Messages list ───────────────────────────────
          Expanded(
            child: ListView.builder(
              controller:  _scrollCtrl,
              padding:     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount:   messages.length + (isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                // Typing indicator
                if (i == messages.length && isTyping) {
                  return _TypingIndicator(name: _conv.otherUserName);
                }

                final msg = messages[i];
                final prev = i > 0 ? messages[i - 1] : null;

                // Date separator
                final showDate = prev == null ||
                    !_sameDay(prev.createdAt, msg.createdAt);

                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  if (showDate) _DateSeparator(date: msg.createdAt, isArabic: isArabic),
                  _MessageBubble(msg: msg, isArabic: isArabic),
                ]);
              },
            ),
          ),

          // ── Quick replies ───────────────────────────────
          if (_showQuicks && _inputCtrl.text.isEmpty)
            _QuickReplies(isArabic: isArabic, onSelect: _sendMessage),

          // ── Input bar ───────────────────────────────────
          _InputBar(
            ctrl:      _inputCtrl,
            focusNode: _inputFocus,
            isArabic:  isArabic,
            onSend:    _sendMessage,
            onChanged: (v) {
              setState(() {
                _showQuicks = v.isEmpty && messages.length < 3;
              });
            },
          ),
        ]),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ──────────────────────────────────────────────────────────────
// CHAT APP BAR
// ──────────────────────────────────────────────────────────────
class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Conversation conv;
  final bool         isArabic;
  const _ChatAppBar({required this.conv, required this.isArabic});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.bgSurface,
    leading: IconButton(
      icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 18),
      onPressed: () => context.pop()),
    title: Row(children: [
      // Avatar
      Stack(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(gradient: AppGradients.primaryButton, shape: BoxShape.circle),
          child: Center(child: Text(conv.otherUserName[0], style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)))),
        if (conv.otherIsOnline) Positioned(bottom: 1, right: 1, child: Container(
          width: 10, height: 10, decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: AppColors.bgSurface, width: 1.5)))),
      ]),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(conv.otherUserName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          if (conv.otherIsVerified) ...[const SizedBox(width: 4), const Icon(Icons.verified_rounded, size: 13, color: AppColors.royalBlue)],
        ]),
        Text(
          conv.otherIsOnline ? (isArabic ? 'متصل الآن 🟢' : 'Online now 🟢') : (isArabic ? 'آخر ظهور منذ ساعتين' : 'Last seen 2h ago'),
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
      ]),
    ]),
    actions: [
      IconButton(icon: const Icon(Icons.phone_rounded, size: 20), onPressed: () => HapticFeedback.lightImpact()),
      IconButton(icon: const Icon(Icons.more_vert_rounded, size: 20), onPressed: () {}),
    ],
  );
}

// ──────────────────────────────────────────────────────────────
// CONTEXT HEADER
// ──────────────────────────────────────────────────────────────
class _ContextHeader extends StatelessWidget {
  final Conversation conv;
  final bool         isArabic;
  const _ContextHeader({required this.conv, required this.isArabic});

  Color get _color => switch (conv.context) {
    ConvContext.product      => AppColors.royalBlue,
    ConvContext.service      => AppColors.categoryTeal,
    ConvContext.classifiedAd => AppColors.metallicGold,
    ConvContext.general      => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color:  _color.withOpacity(0.07),
      border: Border(bottom: BorderSide(color: _color.withOpacity(0.15))),
    ),
    child: Row(children: [
      // Context image
      if (conv.contextImageUrl != null)
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(conv.contextImageUrl!, width: 40, height: 40, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 40, height: 40, color: AppColors.bgCard2, child: const Icon(Icons.image_outlined, color: AppColors.textMuted, size: 18))),
        ),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(isArabic ? (conv.contextTitleAr ?? '') : (conv.contextTitleEn ?? conv.contextTitleAr ?? ''),
            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        if (conv.contextPrice != null)
          Text('${conv.contextPrice!.toInt()} ${isArabic ? "ر.س" : "SAR"}',
              style: AppTextStyles.priceSmall.copyWith(color: AppColors.metallicGold)),
      ])),
      // View button
      GestureDetector(
        onTap: () {},
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: _color.withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: _color.withOpacity(0.25))),
          child: Text(isArabic ? 'عرض' : 'View', style: AppTextStyles.labelSmall.copyWith(color: _color))),
      ),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// DATE SEPARATOR
// ──────────────────────────────────────────────────────────────
class _DateSeparator extends StatelessWidget {
  final DateTime date;
  final bool     isArabic;
  const _DateSeparator({required this.date, required this.isArabic});

  String _label() {
    final now  = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return isArabic ? 'اليوم' : 'Today';
    if (diff.inDays == 1) return isArabic ? 'أمس'   : 'Yesterday';
    final months = isArabic
        ? ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر']
        : ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(children: [
      Expanded(child: Container(height: 1, color: AppColors.borderSubtle)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.bgCard2, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSubtle)),
          child: Text(_label(), style: AppTextStyles.caption),
        ),
      ),
      Expanded(child: Container(height: 1, color: AppColors.borderSubtle)),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// MESSAGE BUBBLE
// ──────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool        isArabic;
  const _MessageBubble({required this.msg, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    // System message
    if (msg.isSystem) return _SystemBubble(msg: msg, isArabic: isArabic);

    return Align(
      alignment: msg.isMe
          ? (isArabic ? Alignment.centerLeft : Alignment.centerRight)
          : (isArabic ? Alignment.centerRight : Alignment.centerLeft),
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _showActions(context, isArabic);
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.72),
          margin:      const EdgeInsets.only(bottom: 4),
          padding:     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient:     msg.isMe ? AppGradients.primaryButton : null,
            color:        msg.isMe ? null : AppColors.bgCard,
            borderRadius: _bubbleRadius(msg.isMe, isArabic),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
            Text(msg.content,
                style: (isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium).copyWith(
                  color:  msg.isMe ? Colors.white : AppColors.textPrimary,
                  height: 1.4,
                )),
            const SizedBox(height: 3),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(_timeLabel(msg.createdAt, isArabic),
                  style: AppTextStyles.caption.copyWith(
                    color:    msg.isMe ? Colors.white70 : AppColors.textMuted,
                    fontSize: 9,
                  )),
              if (msg.isMe) ...[
                const SizedBox(width: 4),
                Icon(
                  msg.status == MessageStatus.read ? Icons.done_all_rounded :
                  msg.status == MessageStatus.delivered ? Icons.done_all_rounded : Icons.done_rounded,
                  size:  12,
                  color: msg.status == MessageStatus.read ? const Color(0xFF60BFFF) : Colors.white70,
                ),
              ],
            ]),
          ]),
        ),
      ),
    );
  }

  BorderRadius _bubbleRadius(bool isMe, bool ar) {
    const r = Radius.circular(16);
    const s = Radius.circular(4);
    if (isMe) {
      return ar
          ? const BorderRadius.only(topLeft: r, topRight: r, bottomLeft: s, bottomRight: r)
          : const BorderRadius.only(topLeft: r, topRight: r, bottomLeft: r, bottomRight: s);
    } else {
      return ar
          ? const BorderRadius.only(topLeft: r, topRight: r, bottomLeft: r, bottomRight: s)
          : const BorderRadius.only(topLeft: r, topRight: r, bottomLeft: s, bottomRight: r);
    }
  }

  String _timeLabel(DateTime dt, bool ar) {
    final h = dt.hour; final m = dt.minute.toString().padLeft(2, '0');
    if (ar) { final p = h < 12 ? 'ص' : 'م'; final dh = h > 12 ? h - 12 : (h == 0 ? 12 : h); return '$dh:$m $p'; }
    final p = h < 12 ? 'AM' : 'PM'; final dh = h > 12 ? h - 12 : (h == 0 ? 12 : h); return '$dh:$m $p';
  }

  void _showActions(BuildContext ctx, bool ar) {
    showModalBottomSheet(
      context: ctx, backgroundColor: AppColors.bgBottomSheet,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderDefault, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 8),
        // Preview of message
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(msg.content, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis)),
        const Divider(height: 1, color: AppColors.borderSubtle),
        ListTile(leading: const Icon(Icons.copy_rounded, color: AppColors.royalBlue, size: 20),
          title: Text(ar ? 'نسخ النص' : 'Copy text'), onTap: () { Clipboard.setData(ClipboardData(text: msg.content)); Navigator.pop(ctx); }),
        if (msg.isMe) ListTile(leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
          title: Text(ar ? 'حذف الرسالة' : 'Delete message', style: const TextStyle(color: AppColors.error)), onTap: () => Navigator.pop(ctx)),
        const SizedBox(height: 8),
      ])),
    );
  }
}

class _SystemBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool        isArabic;
  const _SystemBubble({required this.msg, required this.isArabic});

  @override
  Widget build(BuildContext context) => Center(child: Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(color: AppColors.bgCard2, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderSubtle)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.info_outline_rounded, size: 12, color: AppColors.textMuted),
      const SizedBox(width: 6),
      Text(msg.content, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
    ]),
  ));
}

// ──────────────────────────────────────────────────────────────
// TYPING INDICATOR
// ──────────────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  final String name;
  const _TypingIndicator({required this.name});
  @override State<_TypingIndicator> createState() => _TIState();
}

class _TIState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true); _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16), bottomRight: Radius.circular(16), bottomLeft: Radius.circular(4))),
      child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final delay = i * 0.33;
          final opacity = (0.3 + 0.7 * (((_anim.value - delay).abs() < 0.33) ? _anim.value : 0.3)).clamp(0.3, 1.0);
          return Container(width: 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(color: AppColors.textMuted.withOpacity(opacity), shape: BoxShape.circle));
        },
      ))),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// QUICK REPLIES
// ──────────────────────────────────────────────────────────────
class _QuickReplies extends StatelessWidget {
  final bool        isArabic;
  final ValueChanged<String> onSelect;
  const _QuickReplies({required this.isArabic, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final replies = isArabic
        ? ['السعر قابل للتفاوض', 'هل يمكن الاستلام اليوم؟', 'ما حالة المنتج؟', 'شكراً لتواصلك']
        : ['Price is negotiable', 'Can I pick it up today?', "What's the condition?", 'Thank you'];

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderSubtle))),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: replies.map((r) => GestureDetector(
          onTap: () => onSelect(r),
          child: Container(
            margin:  const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: AppColors.royalBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderActive)),
            child: Center(child: Text(r, style: AppTextStyles.labelSmall.copyWith(color: AppColors.royalBlue))),
          ),
        )).toList(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// INPUT BAR
// ──────────────────────────────────────────────────────────────
class _InputBar extends StatefulWidget {
  final TextEditingController ctrl;
  final FocusNode             focusNode;
  final bool                  isArabic;
  final ValueChanged<String>  onSend;
  final ValueChanged<String>  onChanged;
  const _InputBar({required this.ctrl, required this.focusNode, required this.isArabic, required this.onSend, required this.onChanged});
  @override State<_InputBar> createState() => _IBState();
}

class _IBState extends State<_InputBar> with SingleTickerProviderStateMixin {
  late final AnimationController _sendCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  late final Animation<double>   _sendScale = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)).animate(_sendCtrl);
  bool _hasText = false;

  @override void dispose() { _sendCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(8, 8, 8, MediaQuery.paddingOf(context).bottom + 8),
    decoration: const BoxDecoration(color: AppColors.bgSurface, border: Border(top: BorderSide(color: AppColors.borderSubtle))),
    child: Row(children: [
      // Camera
      GestureDetector(
        onTap: () => HapticFeedback.lightImpact(),
        child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderDefault)),
            child: const Icon(Icons.camera_alt_outlined, size: 20, color: AppColors.textSecondary)),
      ),
      const SizedBox(width: 8),

      // Text field
      Expanded(child: TextField(
        controller:   widget.ctrl,
        focusNode:    widget.focusNode,
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        maxLines:     4, minLines: 1,
        style: widget.isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
        textInputAction: TextInputAction.send,
        onSubmitted:  widget.onSend,
        onChanged: (v) {
          widget.onChanged(v);
          final hasText = v.trim().isNotEmpty;
          if (hasText != _hasText) {
            setState(() => _hasText = hasText);
            if (hasText) _sendCtrl.forward();
            else _sendCtrl.reverse();
          }
        },
        decoration: InputDecoration(
          hintText:     widget.isArabic ? 'اكتب رسالة...' : 'Type a message...',
          hintStyle:    (widget.isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          suffixIcon: GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: const Icon(Icons.emoji_emotions_outlined, size: 20, color: AppColors.textMuted)),
        ),
      )),
      const SizedBox(width: 8),

      // Send / Mic button
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: _hasText
            ? GestureDetector(
                key:   const ValueKey('send'),
                onTap: () {
                  widget.onSend(widget.ctrl.text);
                  setState(() => _hasText = false);
                  _sendCtrl.reverse();
                },
                child: Container(width: 42, height: 42, decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: BorderRadius.circular(13),
                    boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 3))]),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20)),
              )
            : GestureDetector(
                key:   const ValueKey('mic'),
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(13), border: Border.all(color: AppColors.borderDefault)),
                    child: const Icon(Icons.mic_none_rounded, size: 20, color: AppColors.textSecondary)),
              ),
      ),
    ]),
  );
}
