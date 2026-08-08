// Profile notifications — light design (15-notifications.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

class ProfileNotificationsLightScreen extends ConsumerWidget {
  const ProfileNotificationsLightScreen({super.key});

  static const _items = [
    (Icons.local_shipping_outlined, 'طلبك في الطريق', 'Your order is on the way', 'سيتم التسليم خلال 20 دقيقة', 'Delivery in 20 minutes', '5m', '5m ago', KayanDesignTokens.gradOrange, true),
    (Icons.card_giftcard_rounded, 'عرض خاص 30%', 'Special 30% offer', 'على طلباتك القادمة', 'On your next orders', '1h', '1h ago', KayanDesignTokens.gradGold, false),
    (Icons.chat_bubble_outline_rounded, 'رسالة جديدة', 'New message', 'من البائع خالد', 'From seller Khalid', 'أمس', 'Yesterday', KayanDesignTokens.gradBlue, false),
    (Icons.home_repair_service_outlined, 'تأكيد حجز الخدمة', 'Service booking confirmed', 'غداً 9 صباحاً', 'Tomorrow 9 AM', '2d', '2 days ago', KayanDesignTokens.gradGreen, false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'الإشعارات' : 'Notifications',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: _items.map((n) {
                return KayanNotificationItem(
                  icon: n.$1,
                  title: ar ? n.$2 : n.$3,
                  body: ar ? n.$4 : n.$5,
                  time: ar ? n.$6 : n.$7,
                  iconGradient: n.$8,
                  unread: n.$9,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
