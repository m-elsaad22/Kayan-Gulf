import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

/// إشعارات المتجر — light design
class ShopNotificationsScreen extends ConsumerWidget {
  const ShopNotificationsScreen({super.key});

  static const _items = [
    (Icons.local_offer_outlined, 'خصم 20% على الإلكترونيات', '20% off electronics', 'ينتهي خلال 3 أيام', 'Expires in 3 days', '2h', '2h ago', KayanDesignTokens.gradOrange, true),
    (Icons.inventory_2_outlined, 'منتجك عاد للمخزون', 'Item back in stock', 'سماعات لاسلكية', 'Wireless earbuds', '5h', '5h ago', KayanDesignTokens.gradBlue, false),
    (Icons.card_giftcard_rounded, 'كوبون ترحيبي', 'Welcome coupon', 'WELCOME30 — خصم 30%', 'WELCOME30 — 30% off', 'أمس', 'Yesterday', KayanDesignTokens.gradGold, false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'إشعارات المتجر' : 'Shop notifications',
            variant: KayanSectionHeroVariant.orange,
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
