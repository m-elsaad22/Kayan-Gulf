// Profile home — light design (13-profile.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../widgets/kayan_profile_widgets.dart';

class ProfileHomeScreen extends ConsumerWidget {
  const ProfileHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final name = ar ? 'محمود السعد' : 'Mahmoud Alsaad';
    final phone = '+966 50 123 4567';
    final initial = name.isNotEmpty ? name.trim()[0] : 'ك';

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'حسابي' : 'My account',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.go(AppRoutes.home)),
            trailing: KayanHeroIconButton(icon: Icons.settings_outlined, onTap: () => context.push(AppRoutes.settings)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 100),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: KayanDesignTokens.border),
                    boxShadow: KayanDesignTokens.shadowS,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(initial, style: KayanDesignTokens.cairo(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: KayanDesignTokens.cairo(fontSize: 17, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
                            Text(phone, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: KayanDesignTokens.gradGold,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(ar ? 'عضو ذهبي' : 'Gold member', style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF402C00))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    KayanStatBox(value: '24', label: ar ? 'طلب' : 'Orders'),
                    const SizedBox(width: 10),
                    KayanStatBox(value: '1.8K', label: ar ? 'نقطة' : 'Points'),
                    const SizedBox(width: 10),
                    KayanStatBox(value: '250', label: ar ? 'ر.س' : 'SAR'),
                  ],
                ),
                const SizedBox(height: 20),
                _MenuSection(
                  ar: ar,
                  title: ar ? 'الحساب' : 'Account',
                  children: [
                    KayanProfileMenuTile(icon: Icons.person_outline_rounded, title: ar ? 'تعديل الملف' : 'Edit profile', onTap: () => context.push(AppRoutes.editProfile)),
                    KayanProfileMenuTile(icon: Icons.location_on_outlined, title: ar ? 'عناويني' : 'My addresses', onTap: () => context.push(AppRoutes.addresses)),
                    KayanProfileMenuTile(icon: Icons.favorite_border_rounded, title: ar ? 'المفضلة' : 'Favorites', onTap: () => context.push(AppRoutes.favorites)),
                  ],
                ),
                _MenuSection(
                  ar: ar,
                  title: ar ? 'الطلبات والمحفظة' : 'Orders & wallet',
                  children: [
                    KayanProfileMenuTile(icon: Icons.receipt_long_outlined, title: ar ? 'طلباتي وحجوزاتي' : 'Orders & bookings', onTap: () => context.push(AppRoutes.unifiedOrders)),
                    KayanProfileMenuTile(icon: Icons.account_balance_wallet_outlined, title: ar ? 'المحفظة' : 'Wallet', onTap: () => context.push(AppRoutes.wallet)),
                    KayanProfileMenuTile(icon: Icons.card_giftcard_rounded, title: ar ? 'نقاط الولاء' : 'Loyalty points', onTap: () => context.push(AppRoutes.loyalty)),
                  ],
                ),
                _MenuSection(
                  ar: ar,
                  title: ar ? 'الدعم' : 'Support',
                  children: [
                    KayanProfileMenuTile(icon: Icons.notifications_none_rounded, title: ar ? 'الإشعارات' : 'Notifications', onTap: () => context.push(AppRoutes.notifications)),
                    KayanProfileMenuTile(icon: Icons.help_outline_rounded, title: ar ? 'المساعدة' : 'Help', onTap: () => context.push(AppRoutes.helpSupport)),
                    KayanProfileMenuTile(icon: Icons.info_outline_rounded, title: ar ? 'عن كيان' : 'About KAYAN', onTap: () => context.push(AppRoutes.aboutKayan)),
                  ],
                ),
                const SizedBox(height: 8),
                KayanCtaButton(
                  label: ar ? 'تسجيل الخروج' : 'Log out',
                  trailingIcon: Icons.logout_rounded,
                  variant: KayanCtaVariant.blue,
                  onPressed: () => _confirmLogout(context, ref, ar),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref, bool ar) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ar ? 'تسجيل الخروج؟' : 'Log out?', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
        content: Text(ar ? 'هل تريد تسجيل الخروج من حسابك؟' : 'Do you want to log out of your account?', style: KayanDesignTokens.cairo()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ar ? 'إلغاء' : 'Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authStateProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            child: Text(ar ? 'خروج' : 'Log out', style: const TextStyle(color: KayanDesignTokens.danger)),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.ar, required this.title, required this.children});

  final bool ar;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KayanSectionHeader(title: title),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: KayanDesignTokens.border),
            boxShadow: KayanDesignTokens.shadowS,
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
