// Classifieds chat list — matches design/html/125-cl-chat-list.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

class ClassifiedsChatThread {
  const ClassifiedsChatThread({
    required this.id,
    required this.name,
    required this.preview,
    required this.time,
    required this.initial,
    this.unread = false,
  });

  final String id;
  final String name;
  final String preview;
  final String time;
  final String initial;
  final bool unread;
}

const _mockThreads = [
  ClassifiedsChatThread(
    id: 'khalid',
    name: 'خالد العتيبي',
    preview: 'تمام، أبعتلك الموقع 📍',
    time: '10:24 ص',
    initial: 'خ',
    unread: true,
  ),
  ClassifiedsChatThread(
    id: 'sara',
    name: 'سارة المطيري',
    preview: 'هل السعر قابل للتفاوض؟',
    time: 'أمس',
    initial: 'س',
  ),
  ClassifiedsChatThread(
    id: 'abdullah',
    name: 'عبدالله القحطاني',
    preview: 'شكراً، وصلني الطلب',
    time: 'الإثنين',
    initial: 'ع',
  ),
];

class ClassifiedsChatListScreen extends ConsumerWidget {
  const ClassifiedsChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'المحادثات' : 'Chats',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: _mockThreads
                      .map(
                        (t) => KayanChatListTile(
                          name: t.name,
                          preview: t.preview,
                          time: t.time,
                          initial: t.initial,
                          unread: t.unread,
                          onTap: () => context.push(AppRoutes.classifiedsChatPath(t.id)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
