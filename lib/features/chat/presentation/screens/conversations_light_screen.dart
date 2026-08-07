// Global conversations list — light design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../data/models/chat_models.dart';

class ConversationsLightScreen extends ConsumerStatefulWidget {
  const ConversationsLightScreen({super.key});

  @override
  ConsumerState<ConversationsLightScreen> createState() => _ConversationsLightScreenState();
}

class _ConversationsLightScreenState extends ConsumerState<ConversationsLightScreen> {
  final _search = TextEditingController();
  late List<Conversation> _convs;

  @override
  void initState() {
    super.initState();
    _convs = List.from(mockConversations);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Conversation> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _convs;
    return _convs.where((c) {
      return c.otherUserName.toLowerCase().contains(q) ||
          (c.contextTitleAr?.toLowerCase().contains(q) ?? false) ||
          (c.contextTitleEn?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final list = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'المحادثات' : 'Messages', onBack: () => context.pop()),
              const SizedBox(height: 12),
              KayanDesignTextField(
                controller: _search,
                label: ar ? 'بحث' : 'Search',
                hint: ar ? 'ابحث في المحادثات...' : 'Search conversations...',
                icon: Icons.search_rounded,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: list.isEmpty
                    ? Center(child: Text(ar ? 'لا توجد محادثات' : 'No conversations', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)))
                    : ListView(
                        children: list.map((c) {
                          final preview = c.lastMessage?.content ?? '';
                          final initial = c.otherUserName.isNotEmpty ? c.otherUserName[0] : '?';
                          return KayanChatListTile(
                            name: c.otherUserName,
                            preview: preview,
                            time: c.timeLabel(ar),
                            initial: initial,
                            unread: c.unreadCount > 0,
                            onTap: () => context.push(AppRoutes.chatPath(c.id)),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
