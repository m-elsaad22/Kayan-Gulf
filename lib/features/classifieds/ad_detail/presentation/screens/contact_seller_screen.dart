// Contact seller — pre-chat screen before 117-cl-chat-seller
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class ContactSellerScreen extends ConsumerStatefulWidget {
  const ContactSellerScreen({super.key, this.adSlug, this.sellerId});

  final String? adSlug;
  final String? sellerId;

  @override
  ConsumerState<ContactSellerScreen> createState() => _ContactSellerScreenState();
}

class _ContactSellerScreenState extends ConsumerState<ContactSellerScreen> {
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  void _applyQuickReply(String text) {
    setState(() => _messageCtrl.text = text);
  }

  void _openChat(String sellerId) {
    context.push(AppRoutes.classifiedsChatPath(sellerId));
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final ad = mockAds.firstWhere(
      (a) => a.slug == widget.adSlug,
      orElse: () => mockAds.firstWhere((a) => a.categorySlug == 'vehicles', orElse: () => mockAds.first),
    );
    final seller = ad.seller ??
        const AdSeller(id: 's1', name: 'خالد العتيبي', isVerified: true, totalAds: 12, rating: 4.8, memberDays: 400);
    final sellerId = widget.sellerId ?? seller.id;

    final quickReplies = ar
        ? ['هل المنتج متاح؟', 'ما آخر سعر؟', 'ممكن معاينة اليوم؟']
        : ['Is it still available?', 'Best price?', 'Can I view today?'];

    final priceLabel = ad.isFree
        ? (ar ? 'مجاني' : 'Free')
        : '${ad.price?.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'تواصل مع البائع' : 'Contact seller',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: KayanDesignTokens.border),
                  boxShadow: KayanDesignTokens.shadowS,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(
                        seller.name.isNotEmpty ? seller.name[0] : '?',
                        style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            seller.name,
                            style: KayanDesignTokens.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep),
                          ),
                          Text(
                            ar
                                ? '${seller.isVerified ? 'بائع موثّق' : 'بائع فردي'} · ${seller.rating.toStringAsFixed(1)} ⭐'
                                : '${seller.isVerified ? 'Verified' : 'Individual'} · ${seller.rating.toStringAsFixed(1)} ⭐',
                            style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              KayanClassifiedAdCard(
                title: ad.title,
                locationLine: ad.city,
                priceLabel: priceLabel,
                icon: Icons.sell_rounded,
                onTap: () => context.push(AppRoutes.adPath(ad.slug)),
              ),
              const SizedBox(height: 16),
              Text(
                ar ? 'رسالة سريعة' : 'Quick message',
                style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickReplies.map((q) {
                  return GestureDetector(
                    onTap: () => _applyQuickReply(q),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: KayanDesignTokens.bg,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: KayanDesignTokens.border),
                      ),
                      child: Text(q, style: KayanDesignTokens.cairo(fontSize: 12.5, color: KayanDesignTokens.kBlue)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                label: ar ? 'رسالتك' : 'Your message',
                hint: ar ? 'اكتب رسالتك للبائع...' : 'Write your message...',
                icon: Icons.chat_bubble_outline_rounded,
                controller: _messageCtrl,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ar ? 'سيتم الاتصال قريباً (تجريبي)' : 'Call coming soon (demo)'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone_rounded, size: 18),
                      label: Text(ar ? 'اتصال' : 'Call', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: KayanDesignTokens.kBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: KayanDesignTokens.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: KayanCtaButton(
                      label: ar ? 'بدء المحادثة' : 'Start chat',
                      trailingIcon: Icons.chat_rounded,
                      variant: KayanCtaVariant.blue,
                      onPressed: () => _openChat(sellerId),
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
