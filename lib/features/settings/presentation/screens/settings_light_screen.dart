// Settings — light design (14-settings.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../profile/presentation/widgets/kayan_profile_widgets.dart';

class SettingsLightScreen extends ConsumerStatefulWidget {
  const SettingsLightScreen({super.key});

  @override
  ConsumerState<SettingsLightScreen> createState() => _SettingsLightScreenState();
}

class _SettingsLightScreenState extends ConsumerState<SettingsLightScreen> {
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'الإعدادات' : 'Settings', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Text(ar ? 'عام' : 'General', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
                    const SizedBox(height: 8),
                    _tile(
                      icon: Icons.language_rounded,
                      title: ar ? 'اللغة' : 'Language',
                      subtitle: ar ? 'العربية' : 'Arabic',
                      onTap: () => context.push(AppRoutes.settingsLanguage),
                    ),
                    _tile(
                      icon: Icons.dark_mode_outlined,
                      title: ar ? 'المظهر' : 'Appearance',
                      subtitle: isDark ? (ar ? 'داكن' : 'Dark') : (ar ? 'فاتح' : 'Light'),
                      onTap: () => context.push(AppRoutes.settingsTheme),
                    ),
                    const SizedBox(height: 16),
                    Text(ar ? 'الإشعارات' : 'Notifications', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
                    const SizedBox(height: 8),
                    KayanProfileMenuTile(icon: Icons.notifications_outlined, title: ar ? 'إعدادات الإشعارات' : 'Notification settings', onTap: () => context.push(AppRoutes.settingsNotif)),
                    const SizedBox(height: 16),
                    Text(ar ? 'الأمان' : 'Security', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
                    const SizedBox(height: 8),
                    _switchTile(Icons.fingerprint_rounded, ar ? 'بصمة الوجه' : 'Biometric login', _biometric, (v) => setState(() => _biometric = v)),
                    KayanProfileMenuTile(icon: Icons.shield_outlined, title: ar ? 'إعدادات الأمان' : 'Security settings', onTap: () => context.push(AppRoutes.settingsSecurity)),
                    const SizedBox(height: 16),
                    Text(ar ? 'حول التطبيق' : 'About', style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
                    const SizedBox(height: 8),
                    KayanProfileMenuTile(icon: Icons.info_outline_rounded, title: ar ? 'عن كيان' : 'About KAYAN', onTap: () => context.push(AppRoutes.aboutApp)),
                    KayanProfileMenuTile(icon: Icons.description_outlined, title: ar ? 'الشروط والخصوصية' : 'Terms & privacy', onTap: () => context.push(AppRoutes.privacyPolicy)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile({required IconData icon, required String title, String? subtitle, VoidCallback? onTap}) {
    return KayanProfileMenuTile(icon: icon, title: title, subtitle: subtitle, onTap: onTap);
  }

  Widget _switchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: KayanDesignTokens.kBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: KayanDesignTokens.kBlue),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: KayanDesignTokens.cairo(fontSize: 14, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlueDeep))),
          Switch.adaptive(value: value, onChanged: onChanged, activeColor: KayanDesignTokens.kBlue),
        ],
      ),
    );
  }
}
