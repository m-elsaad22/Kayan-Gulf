// Settings detail screens — light design
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../profile/presentation/widgets/kayan_profile_widgets.dart';

enum LegalType { privacy, terms }

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'كيان بلس' : 'KAYAN Plus',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: KayanDesignTokens.gradGold, borderRadius: BorderRadius.circular(KayanDesignTokens.radiusL), boxShadow: KayanDesignTokens.shadowM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ar ? 'عضوية ذهبية' : 'Gold membership', style: KayanDesignTokens.cairo(color: const Color(0xFF402C00))),
                      Text('2,450 ${ar ? 'نقطة' : 'pts'}', style: KayanDesignTokens.cairo(fontSize: 26, fontWeight: FontWeight.w900, color: const Color(0xFF402C00))),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(minHeight: 8, value: 0.72, backgroundColor: const Color(0xFF402C00).withValues(alpha: 0.2), valueColor: const AlwaysStoppedAnimation(Color(0xFF402C00))),
                      ),
                      const SizedBox(height: 6),
                      Text(ar ? '550 نقطة للوصول إلى Platinum' : '550 pts to Platinum', style: KayanDesignTokens.cairo(fontSize: 12, color: const Color(0xFF402C00).withValues(alpha: 0.85))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                KayanSectionHeader(title: ar ? 'مزاياك' : 'Your benefits'),
                const SizedBox(height: 10),
                _BenefitTile(icon: Icons.local_shipping_outlined, title: ar ? 'شحن مجاني' : 'Free delivery', body: ar ? 'على طلبات المتجر المؤهلة' : 'On eligible shop orders'),
                _BenefitTile(icon: Icons.home_repair_service_outlined, title: ar ? 'أولوية الخدمات' : 'Priority services', body: ar ? 'حجز أسرع وفنيون موثوقون' : 'Faster booking with top providers'),
                _BenefitTile(icon: Icons.campaign_outlined, title: ar ? 'تمييز إعلان شهري' : 'Monthly ad boost', body: ar ? 'إعلان مميز مجاني كل شهر' : 'One free featured listing monthly'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final ar = locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'اللغة' : 'Language', onBack: () => context.pop()),
              const SizedBox(height: 16),
              _SelectableTile(icon: Icons.language_rounded, title: 'العربية', subtitle: 'واجهة عربية RTL', selected: locale.languageCode == 'ar', onTap: () => ref.read(localeProvider.notifier).setArabic()),
              _SelectableTile(icon: Icons.translate_rounded, title: 'English', subtitle: 'English LTR interface', selected: locale.languageCode == 'en', onTap: () => ref.read(localeProvider.notifier).setEnglish()),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'المظهر' : 'Appearance', onBack: () => context.pop()),
              const SizedBox(height: 16),
              _SelectableTile(icon: Icons.light_mode_rounded, title: ar ? 'فاتح' : 'Light', subtitle: ar ? 'تصميم كيان الفاتح' : 'KAYAN light design', selected: mode == ThemeMode.light, onTap: () => ref.read(themeModeProvider.notifier).setLight()),
              _SelectableTile(icon: Icons.dark_mode_rounded, title: ar ? 'داكن' : 'Dark', subtitle: ar ? 'راحة للعين ليلاً' : 'Easier on eyes at night', selected: mode == ThemeMode.dark, onTap: () => ref.read(themeModeProvider.notifier).setDark()),
              _SelectableTile(icon: Icons.settings_suggest_rounded, title: ar ? 'حسب النظام' : 'System', subtitle: ar ? 'مطابقة إعدادات الجهاز' : 'Follow device settings', selected: mode == ThemeMode.system, onTap: () => ref.read(themeModeProvider.notifier).setSystem()),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _orders = true;
  bool _services = true;
  bool _offers = true;
  bool _chat = true;

  @override
  Widget build(BuildContext context) {
    final ar = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'إعدادات الإشعارات' : 'Notification settings', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    _SwitchRow(icon: Icons.shopping_bag_outlined, title: ar ? 'طلبات المتجر' : 'Shop orders', value: _orders, onChanged: (v) => setState(() => _orders = v)),
                    _SwitchRow(icon: Icons.home_repair_service_outlined, title: ar ? 'حجوزات الخدمات' : 'Service bookings', value: _services, onChanged: (v) => setState(() => _services = v)),
                    _SwitchRow(icon: Icons.local_offer_outlined, title: ar ? 'العروض' : 'Offers', value: _offers, onChanged: (v) => setState(() => _offers = v)),
                    _SwitchRow(icon: Icons.chat_bubble_outline_rounded, title: ar ? 'المحادثات' : 'Chats', value: _chat, onChanged: (v) => setState(() => _chat = v)),
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

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

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
              KayanLightTopBar(title: ar ? 'أمان الحساب' : 'Account security', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    KayanProfileMenuTile(icon: Icons.verified_user_outlined, title: ar ? 'التحقق الثنائي' : 'Two-factor auth', onTap: () => context.push(AppRoutes.twoFASetup)),
                    KayanProfileMenuTile(icon: Icons.fingerprint_rounded, title: ar ? 'الدخول الحيوي' : 'Biometric login', onTap: () {}),
                    KayanProfileMenuTile(icon: Icons.lock_outline_rounded, title: ar ? 'تغيير كلمة المرور' : 'Change password', onTap: () => context.push(AppRoutes.changePassword)),
                    KayanProfileMenuTile(icon: Icons.devices_rounded, title: ar ? 'الأجهزة المتصلة' : 'Connected devices', onTap: () => context.push(AppRoutes.connectedDevices)),
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

class AboutAppScreen extends ConsumerWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'عن كيان' : 'About KAYAN', onBack: () => context.pop()),
              Expanded(
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data == null ? '1.0.0' : '${snapshot.data!.version}+${snapshot.data!.buildNumber}';
                    return ListView(
                      children: [
                        const SizedBox(height: 24),
                        Center(
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                            child: const Icon(Icons.diamond_rounded, color: Colors.white, size: 42),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('KAYAN', textAlign: TextAlign.center, style: KayanDesignTokens.cairo(fontSize: 24, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
                        Text(ar ? 'تجارة، خدمات، وإعلانات في تجربة واحدة' : 'Commerce, services & classifieds in one app', textAlign: TextAlign.center, style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
                        const SizedBox(height: 8),
                        Text(version, textAlign: TextAlign.center, style: KayanDesignTokens.cairo(color: KayanDesignTokens.kBlue)),
                        const SizedBox(height: 24),
                        _BenefitTile(icon: Icons.business_center_outlined, title: ar ? 'ثقة مؤسسية' : 'Corporate trust', body: ar ? 'مصمم لسوق الخليج' : 'Built for the GCC market'),
                        _BenefitTile(icon: Icons.support_agent_outlined, title: ar ? 'دعم موثوق' : 'Reliable support', body: ar ? 'مساعدة في كل الخدمات' : 'Help across all services'),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LegalScreen extends ConsumerWidget {
  const LegalScreen({super.key, required this.type});

  final LegalType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final privacy = type == LegalType.privacy;
    final title = privacy ? (ar ? 'سياسة الخصوصية' : 'Privacy policy') : (ar ? 'الشروط والأحكام' : 'Terms of service');
    final items = privacy
        ? [
            (ar ? 'البيانات التي نجمعها' : 'Data we collect', ar ? 'بيانات الحساب والطلبات لتحسين التجربة' : 'Account and order data to improve experience'),
            (ar ? 'حماية البيانات' : 'Data protection', ar ? 'تخزين آمن وتشفير للبيانات الحساسة' : 'Secure storage and encryption'),
            (ar ? 'التحكم' : 'Your control', ar ? 'تعديل البيانات من إعدادات الحساب' : 'Update data from account settings'),
          ]
        : [
            (ar ? 'استخدام المنصة' : 'Platform usage', ar ? 'استخدم كيان وفق القوانين المحلية' : 'Use KAYAN under local laws'),
            (ar ? 'المدفوعات' : 'Payments', ar ? 'سياسات الإلغاء تختلف حسب الخدمة' : 'Cancellation policies vary by service'),
            (ar ? 'جودة المحتوى' : 'Content quality', ar ? 'معلومات دقيقة وغير مضللة' : 'Accurate, non-misleading information'),
          ];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: title, onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    Text(ar ? 'آخر تحديث: يونيو 2026' : 'Last updated: June 2026', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
                    const SizedBox(height: 16),
                    for (final item in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _BenefitTile(icon: privacy ? Icons.privacy_tip_outlined : Icons.gavel_outlined, title: item.$1, body: item.$2),
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

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: KayanDesignTokens.surface, borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM), border: Border.all(color: KayanDesignTokens.border)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: KayanDesignTokens.kBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                  Text(body, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.text2, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  const _SelectableTile({required this.icon, required this.title, required this.subtitle, required this.selected, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? KayanDesignTokens.kBlue.withValues(alpha: 0.06) : KayanDesignTokens.surface,
        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
              border: Border.all(color: selected ? KayanDesignTokens.kBlue : KayanDesignTokens.border, width: selected ? 1.5 : 1),
            ),
            child: Row(
              children: [
                Icon(icon, color: KayanDesignTokens.kBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                      Text(subtitle, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                    ],
                  ),
                ),
                if (selected) const Icon(Icons.check_circle_rounded, color: KayanDesignTokens.kBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.icon, required this.title, required this.value, required this.onChanged});

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: KayanDesignTokens.kBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: KayanDesignTokens.kBlue),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700))),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: KayanDesignTokens.kBlue.withValues(alpha: 0.35),
            activeColor: KayanDesignTokens.kBlue,
          ),
        ],
      ),
    );
  }
}
