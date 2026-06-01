// ============================================================
// KAYAN — Settings Screen
// lib/features/settings/presentation/screens/settings_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/providers/theme_provider.dart';

// Local settings state
class _SettingsState {
  final bool pushNotifs, orderNotifs, promoNotifs, chatNotifs;
  final bool faceId, twoFA;
  const _SettingsState({
    this.pushNotifs  = true,
    this.orderNotifs = true,
    this.promoNotifs = true,
    this.chatNotifs  = true,
    this.faceId      = false,
    this.twoFA       = false,
  });
  _SettingsState copyWith({bool? pushNotifs, bool? orderNotifs, bool? promoNotifs, bool? chatNotifs, bool? faceId, bool? twoFA}) =>
      _SettingsState(pushNotifs:pushNotifs??this.pushNotifs, orderNotifs:orderNotifs??this.orderNotifs,
          promoNotifs:promoNotifs??this.promoNotifs, chatNotifs:chatNotifs??this.chatNotifs,
          faceId:faceId??this.faceId, twoFA:twoFA??this.twoFA);
}

final _settingsProvider = StateProvider<_SettingsState>((_) => const _SettingsState());

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);
    final settings = ref.watch(_settingsProvider);
    final notifier = ref.read(_settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Text(isArabic ? 'الإعدادات' : 'Settings',
            style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(
          icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop()),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // ── Language ──────────────────────────────────
          _SettingsGroup(
            titleAr: 'اللغة والمنطقة',
            titleEn: 'Language & Region',
            isArabic: isArabic,
            children: [
              _SettingsTile(
                icon: Icons.language_rounded, color: AppColors.royalBlue,
                labelAr: 'لغة التطبيق', labelEn: 'App Language',
                valueAr: isArabic ? 'العربية' : 'Arabic',
                valueEn: isArabic ? 'العربية' : 'Arabic',
                isArabic: isArabic,
                onTap: () => ref.read(isArabicProvider.notifier).state = !isArabic,
              ),
              _SettingsTile(
                icon: Icons.currency_exchange_rounded, color: AppColors.categoryGreen,
                labelAr: 'العملة', labelEn: 'Currency',
                valueAr: 'ريال سعودي (ر.س)', valueEn: 'SAR (Saudi Riyal)',
                isArabic: isArabic, onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.location_on_rounded, color: AppColors.categoryOrange,
                labelAr: 'المنطقة', labelEn: 'Region',
                valueAr: 'المملكة العربية السعودية', valueEn: 'Saudi Arabia',
                isArabic: isArabic, onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Appearance ────────────────────────────────
          _SettingsGroup(
            titleAr: 'المظهر', titleEn: 'Appearance', isArabic: isArabic,
            children: [
              _SwitchTile(
                icon: Icons.dark_mode_rounded, color: AppColors.categoryPurple,
                labelAr: 'الوضع الداكن', labelEn: 'Dark Mode',
                value: true, // always dark in KAYAN
                isArabic: isArabic, onChanged: (_) {},
              ),
              _SwitchTile(
                icon: Icons.text_fields_rounded, color: AppColors.royalBlue,
                labelAr: 'خط أكبر', labelEn: 'Larger Text',
                value: false, isArabic: isArabic, onChanged: (_) {},
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Notifications ─────────────────────────────
          _SettingsGroup(
            titleAr: 'الإشعارات', titleEn: 'Notifications', isArabic: isArabic,
            children: [
              _SwitchTile(
                icon: Icons.notifications_rounded, color: AppColors.royalBlue,
                labelAr: 'إشعارات الدفع', labelEn: 'Push Notifications',
                sublabelAr: 'تفعيل جميع الإشعارات', sublabelEn: 'Enable all notifications',
                value: settings.pushNotifs, isArabic: isArabic,
                onChanged: (v) => notifier.update((s) => s.copyWith(pushNotifs: v)),
              ),
              _SwitchTile(
                icon: Icons.shopping_bag_outlined, color: AppColors.categoryOrange,
                labelAr: 'إشعارات الطلبات', labelEn: 'Order Updates',
                value: settings.orderNotifs, isArabic: isArabic,
                onChanged: (v) => notifier.update((s) => s.copyWith(orderNotifs: v)),
              ),
              _SwitchTile(
                icon: Icons.campaign_outlined, color: AppColors.metallicGold,
                labelAr: 'العروض والتخفيضات', labelEn: 'Promotions & Deals',
                value: settings.promoNotifs, isArabic: isArabic,
                onChanged: (v) => notifier.update((s) => s.copyWith(promoNotifs: v)),
              ),
              _SwitchTile(
                icon: Icons.chat_bubble_outline_rounded, color: AppColors.categoryGreen,
                labelAr: 'إشعارات المحادثات', labelEn: 'Chat Messages',
                value: settings.chatNotifs, isArabic: isArabic,
                onChanged: (v) => notifier.update((s) => s.copyWith(chatNotifs: v)),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Security ──────────────────────────────────
          _SettingsGroup(
            titleAr: 'الأمان والخصوصية', titleEn: 'Security & Privacy', isArabic: isArabic,
            children: [
              _SwitchTile(
                icon: Icons.fingerprint_rounded, color: AppColors.success,
                labelAr: 'بصمة الوجه / الإصبع', labelEn: 'Face ID / Touch ID',
                value: settings.faceId, isArabic: isArabic,
                onChanged: (v) { HapticFeedback.lightImpact(); notifier.update((s) => s.copyWith(faceId: v)); },
              ),
              _SwitchTile(
                icon: Icons.lock_outlined, color: AppColors.royalBlue,
                labelAr: 'التحقق بخطوتين', labelEn: 'Two-Factor Auth',
                value: settings.twoFA, isArabic: isArabic,
                onChanged: (v) => notifier.update((s) => s.copyWith(twoFA: v)),
              ),
              _SettingsTile(
                icon: Icons.policy_outlined, color: AppColors.categoryTeal,
                labelAr: 'سياسة الخصوصية', labelEn: 'Privacy Policy',
                isArabic: isArabic, onTap: () => context.push(AppRoutes.privacyPolicy),
              ),
              _SettingsTile(
                icon: Icons.description_outlined, color: AppColors.textSecondary,
                labelAr: 'الشروط والأحكام', labelEn: 'Terms of Service',
                isArabic: isArabic, onTap: () => context.push(AppRoutes.termsOfService),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Support ───────────────────────────────────
          _SettingsGroup(
            titleAr: 'الدعم والمساعدة', titleEn: 'Support & Help', isArabic: isArabic,
            children: [
              _SettingsTile(
                icon: Icons.help_outline_rounded, color: AppColors.royalBlue,
                labelAr: 'الأسئلة الشائعة', labelEn: 'FAQ',
                isArabic: isArabic, onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.support_agent_rounded, color: AppColors.categoryGreen,
                labelAr: 'تواصل مع الدعم', labelEn: 'Contact Support',
                sublabelAr: 'متاح ٢٤/٧', sublabelEn: 'Available 24/7',
                isArabic: isArabic, onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.star_outline_rounded, color: AppColors.starFilled,
                labelAr: 'قيّم التطبيق', labelEn: 'Rate the App',
                isArabic: isArabic, onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.share_outlined, color: AppColors.categoryPurple,
                labelAr: 'شارك التطبيق', labelEn: 'Share App',
                isArabic: isArabic, onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── About ─────────────────────────────────────
          _SettingsGroup(
            titleAr: 'عن كيان', titleEn: 'About KAYAN', isArabic: isArabic,
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded, color: AppColors.royalBlue,
                labelAr: 'إصدار التطبيق', labelEn: 'App Version',
                valueAr: '1.0.0 (Build 42)', valueEn: '1.0.0 (Build 42)',
                isArabic: isArabic, onTap: () {},
                showArrow: false,
              ),
              _SettingsTile(
                icon: Icons.update_rounded, color: AppColors.categoryGreen,
                labelAr: 'التحقق من التحديثات', labelEn: 'Check for Updates',
                isArabic: isArabic, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(isArabic ? 'أنت تستخدم أحدث إصدار ✓' : 'You\'re on the latest version ✓'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
                  ));
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── App branding footer ───────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Column(children: [
              ShaderMask(
                shaderCallback: (b) => AppGradients.goldShimmer.createShader(b),
                child: const Text('KAYAN', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 6, color: Colors.white)),
              ),
              const SizedBox(height: 4),
              Text(isArabic ? 'التسوق الملكي في الخليج' : 'Royal Shopping in the Gulf',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textDisabled)),
              const SizedBox(height: 4),
              Text('© 2025 KAYAN Technologies', style: AppTextStyles.caption.copyWith(color: AppColors.textDisabled, fontSize: 9)),
            ]),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// SETTINGS GROUP
// ──────────────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final String   titleAr, titleEn;
  final bool     isArabic;
  final List<Widget> children;
  const _SettingsGroup({required this.titleAr, required this.titleEn, required this.isArabic, required this.children});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
        child: Text(isArabic ? titleAr : titleEn,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, letterSpacing: 0.5))),
      Container(decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
        child: Column(children: List.generate(children.length, (i) => Column(children: [
          children[i],
          if (i < children.length - 1) const Padding(padding: EdgeInsets.only(left: 56), child: Divider(height: 1, color: AppColors.borderSubtle)),
        ])))),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// SETTINGS TILE
// ──────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData  icon;
  final Color     color;
  final String    labelAr, labelEn;
  final String?   valueAr, valueEn, sublabelAr, sublabelEn;
  final bool      isArabic;
  final VoidCallback onTap;
  final bool      showArrow;

  const _SettingsTile({
    required this.icon, required this.color,
    required this.labelAr, required this.labelEn,
    this.valueAr, this.valueEn, this.sublabelAr, this.sublabelEn,
    required this.isArabic, required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    borderRadius: AppBorderRadius.card,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(isArabic ? labelAr : labelEn, style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium),
          if (sublabelAr != null)
            Text(isArabic ? sublabelAr! : sublabelEn!, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
        ])),
        if (valueAr != null)
          Text(isArabic ? valueAr! : valueEn!, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
        if (showArrow) ...[
          const SizedBox(width: 6),
          Icon(isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textMuted),
        ],
      ]),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// SWITCH TILE
// ──────────────────────────────────────────────────────────────
class _SwitchTile extends StatelessWidget {
  final IconData  icon;
  final Color     color;
  final String    labelAr, labelEn;
  final String?   sublabelAr, sublabelEn;
  final bool      value, isArabic;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon, required this.color,
    required this.labelAr, required this.labelEn,
    this.sublabelAr, this.sublabelEn,
    required this.value, required this.isArabic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    child: Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: color)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(isArabic ? labelAr : labelEn, style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium),
        if (sublabelAr != null)
          Text(isArabic ? sublabelAr! : sublabelEn!, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
      ])),
      Switch(value: value, onChanged: onChanged),
    ]),
  );
}
