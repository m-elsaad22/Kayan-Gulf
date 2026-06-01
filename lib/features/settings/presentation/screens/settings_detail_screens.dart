// ============================================================
// KAYAN — Settings Detail Screens
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/widgets/premium/premium_widgets.dart';

enum LegalType { privacy, terms }

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    return PremiumScaffold(
      title: ar ? 'كيان بلس' : 'KAYAN Plus',
      subtitle: ar ? 'مزايا ذهبية لعملائنا الأكثر ولاء' : 'Gold-tier rewards for loyal members',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassPanel(
            gradient: AppGradients.goldPremium,
            borderColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.bgPrimary.withOpacity(0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.workspace_premium_rounded, color: AppColors.bgPrimary, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ar ? 'عضوية ذهبية' : 'Gold Membership',
                              style: AppTextStyles.titleLarge.copyWith(color: AppColors.bgPrimary, fontWeight: FontWeight.w900)),
                          Text(ar ? '2,450 نقطة متاحة' : '2,450 points available',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.bgPrimary.withOpacity(0.72))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: 0.72,
                    backgroundColor: AppColors.bgPrimary.withOpacity(0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.bgPrimary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(ar ? '550 نقطة للوصول إلى Platinum' : '550 points to Platinum',
                    style: AppTextStyles.caption.copyWith(color: AppColors.bgPrimary.withOpacity(0.72))),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(ar ? 'مزاياك الحالية' : 'Current benefits'),
          PremiumInfoTile(
            icon: Icons.local_shipping_rounded,
            title: ar ? 'شحن مجاني' : 'Free delivery',
            subtitle: ar ? 'على طلبات المتجر المؤهلة داخل مدن الخليج' : 'On eligible GCC marketplace orders',
            color: AppColors.royalBlue,
            trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success),
          ),
          PremiumInfoTile(
            icon: Icons.home_repair_service_rounded,
            title: ar ? 'أولوية في الخدمات' : 'Priority services',
            subtitle: ar ? 'حجز أسرع وفنيون موثوقون بتقييم عال' : 'Faster slots with top-rated verified providers',
            color: AppColors.metallicGold,
            trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success),
          ),
          PremiumInfoTile(
            icon: Icons.campaign_rounded,
            title: ar ? 'تمييز إعلان شهري' : 'Monthly ad boost',
            subtitle: ar ? 'تمييز إعلان واحد شهرياً مجاناً' : 'Boost one classified listing every month',
            color: AppColors.categoryPurple,
            trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success),
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
    return PremiumScaffold(
      title: ar ? 'اللغة' : 'Language',
      subtitle: ar ? 'اختر لغة تجربة كيان' : 'Choose your KAYAN experience language',
      child: Column(
        children: [
          _SelectableTile(
            icon: Icons.language_rounded,
            title: 'العربية',
            subtitle: 'واجهة عربية واتجاه RTL لدول الخليج',
            selected: locale.languageCode == 'ar',
            onTap: () => ref.read(localeProvider.notifier).setArabic(),
          ),
          _SelectableTile(
            icon: Icons.translate_rounded,
            title: 'English',
            subtitle: 'Premium English interface with LTR layout',
            selected: locale.languageCode == 'en',
            onTap: () => ref.read(localeProvider.notifier).setEnglish(),
          ),
        ],
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
    return PremiumScaffold(
      title: ar ? 'المظهر' : 'Appearance',
      subtitle: ar ? 'ثيم ملكي داكن أو وضع النظام' : 'Royal dark, light, or system mode',
      child: Column(
        children: [
          _SelectableTile(
            icon: Icons.dark_mode_rounded,
            title: ar ? 'داكن ملكي' : 'Royal dark',
            subtitle: ar ? 'الأفضل لتجربة كيان الفاخرة' : 'The signature KAYAN luxury look',
            selected: mode == ThemeMode.dark,
            onTap: () => ref.read(themeModeProvider.notifier).setDark(),
          ),
          _SelectableTile(
            icon: Icons.light_mode_rounded,
            title: ar ? 'فاتح' : 'Light',
            subtitle: ar ? 'وضوح أعلى في الإضاءة القوية' : 'High contrast for bright environments',
            selected: mode == ThemeMode.light,
            onTap: () => ref.read(themeModeProvider.notifier).setLight(),
          ),
          _SelectableTile(
            icon: Icons.settings_suggest_rounded,
            title: ar ? 'حسب النظام' : 'System',
            subtitle: ar ? 'مطابقة إعدادات الجهاز' : 'Follow device settings',
            selected: mode == ThemeMode.system,
            onTap: () => ref.read(themeModeProvider.notifier).setSystem(),
          ),
        ],
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
    return PremiumScaffold(
      title: ar ? 'إعدادات الإشعارات' : 'Notification Settings',
      subtitle: ar ? 'تحكم ذكي في التنبيهات المهمة' : 'Smart control over important alerts',
      child: Column(
        children: [
          _SwitchTile(title: ar ? 'طلبات المتجر' : 'Marketplace orders', subtitle: ar ? 'حالة الطلب والشحن والتسليم' : 'Order, shipping, and delivery status', icon: Icons.shopping_bag_rounded, value: _orders, onChanged: (v) => setState(() => _orders = v)),
          _SwitchTile(title: ar ? 'حجوزات الخدمات' : 'Service bookings', subtitle: ar ? 'تأكيد الحجز ووصول الفني' : 'Booking confirmations and technician arrival', icon: Icons.home_repair_service_rounded, value: _services, onChanged: (v) => setState(() => _services = v)),
          _SwitchTile(title: ar ? 'العروض الحصرية' : 'Exclusive offers', subtitle: ar ? 'خصومات ذهبية وتنبيهات الفلاش' : 'Gold offers and flash-deal alerts', icon: Icons.local_offer_rounded, value: _offers, onChanged: (v) => setState(() => _offers = v)),
          _SwitchTile(title: ar ? 'المحادثات' : 'Conversations', subtitle: ar ? 'رسائل المشترين ومقدمي الخدمات' : 'Buyer and provider messages', icon: Icons.chat_bubble_rounded, value: _chat, onChanged: (v) => setState(() => _chat = v)),
        ],
      ),
    );
  }
}

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ar = Directionality.of(context) == TextDirection.rtl;
    return PremiumScaffold(
      title: ar ? 'الأمان' : 'Security',
      subtitle: ar ? 'حماية الحساب والمدفوعات' : 'Protect account and payments',
      child: Column(
        children: [
          PremiumInfoTile(icon: Icons.verified_user_rounded, title: ar ? 'التحقق الثنائي' : 'Two-factor verification', subtitle: ar ? 'رمز OTP لكل عملية دخول حساسة' : 'OTP verification for sensitive sign-ins', color: AppColors.success, trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success)),
          PremiumInfoTile(icon: Icons.fingerprint_rounded, title: ar ? 'الدخول الحيوي' : 'Biometric access', subtitle: ar ? 'استخدم بصمة الإصبع أو الوجه عند توفرها' : 'Use fingerprint or face unlock when available', color: AppColors.royalBlue),
          PremiumInfoTile(icon: Icons.payment_rounded, title: ar ? 'حماية المدفوعات' : 'Payment protection', subtitle: ar ? 'تشفير بيانات الدفع وعدم تخزين CVV' : 'Encrypted payments with no CVV storage', color: AppColors.metallicGold, trailing: const Icon(Icons.lock_rounded, color: AppColors.metallicGold)),
        ],
      ),
    );
  }
}

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ar = Directionality.of(context) == TextDirection.rtl;
    return PremiumScaffold(
      title: ar ? 'عن كيان' : 'About KAYAN',
      subtitle: ar ? 'منصة الخليج الشاملة' : 'The GCC premium super app',
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.data == null
              ? '1.0.0'
              : '${snapshot.data!.version}+${snapshot.data!.buildNumber}';
          return Column(
            children: [
              GlassPanel(
                child: Column(
                  children: [
                    Container(width: 82, height: 82, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppGradients.goldPremium), child: const Icon(Icons.diamond_rounded, color: AppColors.bgPrimary, size: 42)),
                    const SizedBox(height: 16),
                    Text(ar ? 'كيان' : 'KAYAN', style: AppTextStyles.displaySmall.copyWith(fontWeight: FontWeight.w900)),
                    Text(ar ? 'تجارة، خدمات، وإعلانات في تجربة واحدة موثوقة' : 'Commerce, services, and classifieds in one trusted experience', textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Text(version, style: AppTextStyles.caption.copyWith(color: AppColors.metallicGold)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              PremiumInfoTile(icon: Icons.business_center_rounded, title: ar ? 'ثقة مؤسسية' : 'Corporate trust', subtitle: ar ? 'تصميم وتجربة مناسبة لسوق الخليج' : 'Designed for GCC market expectations', color: AppColors.royalBlue, trailing: const SizedBox.shrink()),
              PremiumInfoTile(icon: Icons.support_agent_rounded, title: ar ? 'دعم موثوق' : 'Reliable support', subtitle: ar ? 'قنوات مساعدة للمشتريات والحجوزات والإعلانات' : 'Support across shopping, bookings, and listings', color: AppColors.success, trailing: const SizedBox.shrink()),
            ],
          );
        },
      ),
    );
  }
}

class LegalScreen extends StatelessWidget {
  final LegalType type;
  const LegalScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final ar = Directionality.of(context) == TextDirection.rtl;
    final privacy = type == LegalType.privacy;
    final title = privacy ? (ar ? 'سياسة الخصوصية' : 'Privacy Policy') : (ar ? 'الشروط والأحكام' : 'Terms of Service');
    final items = privacy
        ? [
            (ar ? 'البيانات التي نجمعها' : 'Data we collect', ar ? 'نستخدم بيانات الحساب، الموقع عند السماح، وسجل الطلبات لتحسين التجربة.' : 'We use account data, permitted location, and order history to improve the experience.'),
            (ar ? 'حماية البيانات' : 'Data protection', ar ? 'تعتمد كيان على تخزين آمن وتشفير للبيانات الحساسة.' : 'KAYAN relies on secure storage and encryption for sensitive information.'),
            (ar ? 'التحكم والشفافية' : 'Control and transparency', ar ? 'يمكنك تعديل بياناتك وإعدادات الإشعارات من الحساب.' : 'You can update profile data and notification preferences from your account.'),
          ]
        : [
            (ar ? 'استخدام المنصة' : 'Platform usage', ar ? 'استخدم كيان للشراء والحجز والإعلانات وفق القوانين المحلية.' : 'Use KAYAN for shopping, bookings, and listings under local regulations.'),
            (ar ? 'المدفوعات والحجوزات' : 'Payments and bookings', ar ? 'قد تختلف سياسات الإلغاء والاسترداد حسب الخدمة أو البائع.' : 'Cancellation and refund policies may vary by service or vendor.'),
            (ar ? 'جودة المحتوى' : 'Content quality', ar ? 'يلتزم المستخدمون بنشر معلومات دقيقة وغير مضللة.' : 'Users must publish accurate, non-misleading information.'),
          ];
    return PremiumScaffold(
      title: title,
      subtitle: ar ? 'آخر تحديث: يونيو 2026' : 'Last updated: June 2026',
      child: Column(
        children: [
          for (final item in items)
            PremiumInfoTile(
              icon: privacy ? Icons.privacy_tip_rounded : Icons.gavel_rounded,
              title: item.$1,
              subtitle: item.$2,
              color: privacy ? AppColors.royalBlue : AppColors.metallicGold,
              trailing: const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableTile({required this.icon, required this.title, required this.subtitle, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PremiumInfoTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: selected ? AppColors.metallicGold : AppColors.royalBlue,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.metallicGold)
          : const Icon(Icons.circle_outlined, color: AppColors.textMuted),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({required this.title, required this.subtitle, required this.icon, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PremiumInfoTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: value ? AppColors.royalBlue : AppColors.textMuted,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800)),
    );
  }
}
