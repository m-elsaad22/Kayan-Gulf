// About KAYAN — light design (21-about-kayan.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

class AboutKayanScreen extends ConsumerWidget {
  const AboutKayanScreen({super.key});

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
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                    child: const Icon(Icons.hub_rounded, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  ar ? 'كيان — منصة خليجية شاملة' : 'KAYAN — GCC super app',
                  textAlign: TextAlign.center,
                  style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep),
                ),
                const SizedBox(height: 10),
                Text(
                  ar
                      ? 'تجمع كيان بين الطلبات والتسوق والخدمات المنزلية والإعلانات في تجربة واحدة موثوقة.'
                      : 'KAYAN combines delivery, shopping, home services, and classifieds in one trusted experience.',
                  textAlign: TextAlign.center,
                  style: KayanDesignTokens.cairo(fontSize: 14, color: KayanDesignTokens.text2, height: 1.8),
                ),
                const SizedBox(height: 20),
                KayanOfferBanner(
                  title: ar ? 'الإصدار 1.0.0' : 'Version 1.0.0',
                  subtitle: ar ? 'صُمم للسوق الخليجي' : 'Built for the GCC market',
                  gradient: KayanDesignTokens.gradGold,
                ),
                const SizedBox(height: 16),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: KayanDesignTokens.border),
                  ),
                  leading: const Icon(Icons.language_rounded, color: KayanDesignTokens.kBlue),
                  title: Text(
                    ar ? 'ركن التطور' : 'Rukn Eltatawer',
                    style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    AppConfig.publisherUrl,
                    style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted),
                  ),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                  onTap: () async {
                    final uri = Uri.parse(AppConfig.publisherUrl);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
