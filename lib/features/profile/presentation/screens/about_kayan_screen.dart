// About KAYAN — official Rukn El Tatawer application identity
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/rukn_brand.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

class AboutKayanScreen extends ConsumerWidget {
  const AboutKayanScreen({super.key});

  Future<void> _open(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'عن كيان' : 'About KAYAN',
            variant: KayanSectionHeroVariant.blue,
            leading: KayanHeroIconButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.pop(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      gradient: KayanDesignTokens.gradBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.hub_rounded, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  ar
                      ? 'كيان — التطبيق الرسمي لـ ${RuknBrand.companyNameAr}'
                      : 'KAYAN — official ${RuknBrand.companyNameEn} app',
                  textAlign: TextAlign.center,
                  style: KayanDesignTokens.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: KayanDesignTokens.kBlueDeep,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ar
                      ? 'تجمع كيان بين الطلبات والتسوق والخدمات المنزلية والإعلانات في تجربة واحدة موثوقة من ركن التطور.'
                      : 'KAYAN combines delivery, shopping, home services, and classifieds — published by Rukn El Tatawer.',
                  textAlign: TextAlign.center,
                  style: KayanDesignTokens.cairo(
                    fontSize: 14,
                    color: KayanDesignTokens.text2,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 20),
                KayanOfferBanner(
                  title: ar ? 'الإصدار 1.0.0' : 'Version 1.0.0',
                  subtitle: ar ? 'صُمم للسوق الخليجي' : 'Built for the GCC market',
                  gradient: KayanDesignTokens.gradGold,
                ),
                const SizedBox(height: 16),
                _LinkTile(
                  icon: Icons.language_rounded,
                  title: ar ? RuknBrand.companyNameAr : RuknBrand.companyNameEn,
                  subtitle: RuknBrand.websiteUrl,
                  onTap: () => _open(RuknBrand.websiteUri()),
                ),
                _LinkTile(
                  icon: Icons.support_agent_rounded,
                  title: ar ? 'الدعم' : 'Support',
                  subtitle: RuknBrand.supportUrl,
                  onTap: () => _open(RuknBrand.supportUri()),
                ),
                _LinkTile(
                  icon: Icons.privacy_tip_outlined,
                  title: ar ? 'سياسة الخصوصية' : 'Privacy policy',
                  subtitle: RuknBrand.privacyUrl,
                  onTap: () => _open(RuknBrand.privacyUri()),
                ),
                _LinkTile(
                  icon: Icons.gavel_outlined,
                  title: ar ? 'الشروط والأحكام' : 'Terms of service',
                  subtitle: RuknBrand.termsUrl,
                  onTap: () => _open(RuknBrand.termsUri()),
                ),
                _LinkTile(
                  icon: Icons.download_rounded,
                  title: ar ? 'تحميل التطبيق' : 'App download',
                  subtitle: RuknBrand.appDownloadUrl,
                  onTap: () => _open(RuknBrand.appDownloadUri()),
                ),
                _LinkTile(
                  icon: Icons.mail_outline_rounded,
                  title: ar ? 'تواصل' : 'Contact',
                  subtitle: RuknBrand.supportEmail,
                  onTap: () => context.push(AppRoutes.contactSupport),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: KayanDesignTokens.border),
        ),
        leading: Icon(icon, color: KayanDesignTokens.kBlue),
        title: Text(
          title,
          style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          subtitle,
          style: KayanDesignTokens.cairo(
            fontSize: 12,
            color: KayanDesignTokens.muted,
          ),
        ),
        trailing: const Icon(Icons.open_in_new_rounded, size: 18),
        onTap: onTap,
      ),
    );
  }
}
