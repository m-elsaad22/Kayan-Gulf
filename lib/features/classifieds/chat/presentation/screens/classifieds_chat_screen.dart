// Chat with seller — matches design/html/117-cl-chat-seller.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class ClassifiedsChatScreen extends ConsumerStatefulWidget {
  const ClassifiedsChatScreen({super.key, required this.chatId});

  final String chatId;

  @override
  ConsumerState<ClassifiedsChatScreen> createState() => _ClassifiedsChatScreenState();
}

class _ClassifiedsChatScreenState extends ConsumerState<ClassifiedsChatScreen> {
  final _msgCtrl = TextEditingController();
  final List<_ChatMsg> _messages = [
    const _ChatMsg(text: 'أهلاً، السيارة لسه متاحة؟', mine: false, time: '11:20'),
    const _ChatMsg(text: 'أهلاً خالد، أيوه متاحة، حابب تعاين؟', mine: true, time: '11:22'),
    const _ChatMsg(text: 'تمام، ممكن بكرة الساعة 5 العصر؟', mine: false, time: '11:23'),
    const _ChatMsg(text: 'تمام، أبعتلك الموقع 📍', mine: true, time: '11:24'),
  ];

  late final AdModel _ad;
  late final String _sellerName;
  late final String _initial;

  @override
  void initState() {
    super.initState();
    _ad = mockAds.firstWhere((a) => a.categorySlug == 'vehicles', orElse: () => mockAds.first);
    _sellerName = switch (widget.chatId) {
      'sara' => 'سارة المطيري',
      'abdullah' => 'عبدالله القحطاني',
      _ => 'خالد العتيبي',
    };
    _initial = _sellerName.isNotEmpty ? _sellerName[0] : '?';
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
      _messages.add(_ChatMsg(text: text, mine: true, time: 'الآن'));
      _msgCtrl.clear();
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
                  KayanHeroIconButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    light: true,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(_initial, style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _sellerName,
                      style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep),
                    ),
                  ),
                  KayanHeroIconButton(icon: Icons.more_vert_rounded, light: true, onTap: () {}),
                ],
              ),
              const SizedBox(height: 10),
              KayanClassifiedAdCard(
                title: _ad.title,
                locationLine: _ad.city,
                priceLabel: '${_ad.price?.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}',
                icon: Icons.directions_car_rounded,
                isFeatured: false,
                onTap: () {},
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: _messages
                      .map((m) => _Bubble(text: m.text, time: m.time, mine: m.mine))
                      .toList(),
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

class _ChatMsg {
  const _ChatMsg({required this.text, required this.mine, required this.time});

  final String text;
  final bool mine;
  final String time;
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
              style: KayanDesignTokens.cairo(
                fontSize: 13,
                height: 1.6,
                color: mine ? Colors.white : KayanDesignTokens.text,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: KayanDesignTokens.cairo(fontSize: 10, color: mine ? Colors.white70 : KayanDesignTokens.muted),
            ),
          ],
        ),
      ),
    );
  }
}
