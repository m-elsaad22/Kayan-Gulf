// ============================================================
// KAYAN — Conversations Screen
// lib/features/chat/presentation/screens/conversations_screen.dart
//
// Features:
//   • Search conversations
//   • Conversation cards with: avatar, online dot, unread badge,
//     context card (product/service/ad thumbnail + price),
//     last message preview, timestamp
//   • Swipe to delete / mark as read
//   • Empty state
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../chat/data/models/chat_models.dart';

final _convSearchProvider = StateProvider<String>((_) => '');

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() =>
      _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  final _searchCtrl = TextEditingController();
  // Local mutable list for demo
  late List<Conversation> _convs;

  @override
  void initState() {
    super.initState();
    _convs = List.from(mockConversations);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Conversation> get _filtered {
    final q = ref.read(_convSearchProvider).toLowerCase();
    if (q.isEmpty) return _convs;
    return _convs.where((c) =>
        c.otherUserName.toLowerCase().contains(q) ||
        (c.contextTitleAr?.toLowerCase().contains(q) ?? false)).toList();
  }

  void _deleteConv(String id) {
    setState(() => _convs = _convs.where((c) => c.id != id).toList());
  }

  void _markRead(String id) {
    setState(() {
      _convs = _convs.map((c) => c.id != id ? c : Conversation(
        id: c.id, otherUserId: c.otherUserId, otherUserName: c.otherUserName,
        otherUserAvatar: c.otherUserAvatar, otherIsVerified: c.otherIsVerified,
        otherIsOnline: c.otherIsOnline, lastMessage: c.lastMessage,
        unreadCount: 0, updatedAt: c.updatedAt, context: c.context,
        contextTitleAr: c.contextTitleAr, contextTitleEn: c.contextTitleEn,
        contextImageUrl: c.contextImageUrl, contextPrice: c.contextPrice,
      )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final total    = _convs.fold(0, (s, c) => s + c.unreadCount);
    final filtered = _filtered;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        appBar: AppBar(
          backgroundColor: AppColors.bgSurface,
          centerTitle:     true,
          title: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(isArabic ? 'المحادثات' : 'Messages',
                style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
            if (total > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: AppColors.royalBlue, borderRadius: BorderRadius.circular(10)),
                child: Text('$total', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ]),
          leading: IconButton(
            icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => context.pop()),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Container(
              color: AppColors.bgSurface,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall,
                onChanged: (v) => ref.read(_convSearchProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: isArabic ? 'ابحث في المحادثات...' : 'Search messages...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16),
                          onPressed: () {
                            _searchCtrl.clear();
                            ref.read(_convSearchProvider.notifier).state = '';
                          })
                      : null,
                ),
              ),
            ),
          ),
        ),

        body: filtered.isEmpty
            ? _EmptyConversations(isArabic: isArabic)
            : ListView.separated(
                padding:     const EdgeInsets.symmetric(vertical: 8),
                itemCount:   filtered.length,
                separatorBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(left: 88),
                  child:   Divider(height: 1, color: AppColors.borderSubtle),
                ),
                itemBuilder: (_, i) {
                  final conv = filtered[i];
                  return Dismissible(
                    key:       ValueKey(conv.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding:   const EdgeInsets.only(right: 20),
                      color:     AppColors.error,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.delete_rounded, color: Colors.white, size: 22),
                        Text(isArabic ? 'حذف' : 'Delete',
                            style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ]),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerLeft,
                      padding:   const EdgeInsets.only(left: 20),
                      color:     AppColors.success,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.mark_email_read_outlined, color: Colors.white, size: 22),
                        Text(isArabic ? 'قراءة' : 'Read',
                            style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ]),
                    ),
                    onDismissed: (dir) {
                      HapticFeedback.mediumImpact();
                      if (dir == DismissDirection.endToStart) {
                        _deleteConv(conv.id);
                      } else {
                        _markRead(conv.id);
                      }
                    },
                    child: _ConvTile(
                      conv:     conv,
                      isArabic: isArabic,
                      onTap:    () {
                        _markRead(conv.id);
                        context.push(AppRoutes.chatPath(conv.id));
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CONVERSATION TILE
// ──────────────────────────────────────────────────────────────
class _ConvTile extends StatelessWidget {
  final Conversation conv;
  final bool         isArabic;
  final VoidCallback onTap;
  const _ConvTile({required this.conv, required this.isArabic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = conv.unreadCount > 0;
    final lastMsg   = conv.lastMessage;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.royalBlue.withOpacity(0.05),
      child: Container(
        color: hasUnread ? AppColors.royalBlue.withOpacity(0.04) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Avatar with online dot
          Stack(children: [
            Container(
              width:  52, height: 52,
              decoration: BoxDecoration(
                gradient:  AppGradients.primaryButton,
                shape:     BoxShape.circle,
                border:    Border.all(
                  color: conv.otherIsOnline ? AppColors.success : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(child: Text(
                conv.otherUserName.isNotEmpty ? conv.otherUserName[0] : '?',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              )),
            ),
            if (conv.otherIsOnline)
              Positioned(bottom: 2, right: 2, child: Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color:  AppColors.success,
                  shape:  BoxShape.circle,
                  border: Border.all(color: AppColors.bgScaffold, width: 2),
                ),
              )),
          ]),

          const SizedBox(width: 12),

          // Content
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Name row + time
            Row(children: [
              Expanded(child: Row(children: [
                Text(conv.otherUserName,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontSize: 14,
                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                    )),
                if (conv.otherIsVerified) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.verified_rounded, size: 13, color: AppColors.royalBlue),
                ],
              ])),
              Text(conv.timeLabel(isArabic),
                  style: AppTextStyles.caption.copyWith(
                    color:      hasUnread ? AppColors.royalBlue : AppColors.textMuted,
                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                  )),
            ]),

            const SizedBox(height: 3),

            // Context card (product/service/ad)
            if (conv.contextTitleAr != null)
              Container(
                margin:  const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:        _contextColor(conv.context).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border:       Border.all(color: _contextColor(conv.context).withOpacity(0.2)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_contextIcon(conv.context), size: 11, color: _contextColor(conv.context)),
                  const SizedBox(width: 4),
                  Flexible(child: Text(
                    isArabic ? (conv.contextTitleAr ?? '') : (conv.contextTitleEn ?? conv.contextTitleAr ?? ''),
                    style: AppTextStyles.caption.copyWith(
                      color:    _contextColor(conv.context),
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  )),
                  if (conv.contextPrice != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      '${conv.contextPrice!.toInt()} ${isArabic ? "ر.س" : "SAR"}',
                      style: AppTextStyles.caption.copyWith(
                        color:      AppColors.metallicGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ]),
              ),

            // Last message
            Row(children: [
              Expanded(child: Row(children: [
                // Sent/read ticks
                if (lastMsg != null && lastMsg.isMe) ...[
                  Icon(
                    lastMsg.status == MessageStatus.read ? Icons.done_all_rounded : Icons.done_rounded,
                    size:  13,
                    color: lastMsg.status == MessageStatus.read ? AppColors.royalBlue : AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                ],
                Flexible(child: Text(
                  lastMsg?.isSystem == true
                      ? '📋 ${isArabic ? "تحديث حالة" : "Status update"}'
                      : (lastMsg?.content ?? ''),
                  style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(
                    color:      hasUnread ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                  ),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                )),
              ])),
              // Unread badge
              if (conv.unreadCount > 0)
                Container(
                  margin:  const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    gradient:     AppGradients.primaryButton,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${conv.unreadCount}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
            ]),
          ])),
        ]),
      ),
    );
  }

  Color _contextColor(ConvContext c) => switch (c) {
    ConvContext.product      => AppColors.royalBlue,
    ConvContext.service      => AppColors.categoryTeal,
    ConvContext.classifiedAd => AppColors.metallicGold,
    ConvContext.general      => AppColors.textSecondary,
  };

  IconData _contextIcon(ConvContext c) => switch (c) {
    ConvContext.product      => Icons.shopping_bag_outlined,
    ConvContext.service      => Icons.build_outlined,
    ConvContext.classifiedAd => Icons.campaign_outlined,
    ConvContext.general      => Icons.chat_bubble_outline_rounded,
  };
}

// ──────────────────────────────────────────────────────────────
// EMPTY STATE
// ──────────────────────────────────────────────────────────────
class _EmptyConversations extends StatelessWidget {
  final bool isArabic;
  const _EmptyConversations({required this.isArabic});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width:  100, height: 100,
          decoration: BoxDecoration(
            color:  AppColors.bgCard,
            shape:  BoxShape.circle,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        Text(
          isArabic ? 'لا توجد محادثات' : 'No Messages Yet',
          style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          isArabic
              ? 'ستظهر هنا محادثاتك مع البائعين والفنيين'
              : 'Your conversations with sellers and technicians will appear here',
          style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ]),
    ),
  );
}
