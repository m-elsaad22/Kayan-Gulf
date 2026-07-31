// Language & region — matches design/html/02-language-region.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class LanguageRegionScreen extends ConsumerStatefulWidget {
  const LanguageRegionScreen({super.key});

  @override
  ConsumerState<LanguageRegionScreen> createState() => _LanguageRegionScreenState();
}

class _LanguageRegionScreenState extends ConsumerState<LanguageRegionScreen> {
  bool _isArabic = true;
  String _countryCode = 'SA';

  static const _countries = [
    ('SA', 'السعودية', 'Saudi Arabia', '🇸🇦'),
    ('AE', 'الإمارات', 'United Arab Emirates', '🇦🇪'),
    ('QA', 'قطر', 'Qatar', '🇶🇦'),
    ('KW', 'الكويت', 'Kuwait', '🇰🇼'),
    ('BH', 'البحرين', 'Bahrain', '🇧🇭'),
    ('OM', 'عُمان', 'Oman', '🇴🇲'),
    ('EG', 'مصر', 'Egypt', '🇪🇬'),
  ];

  Future<void> _continue() async {
    if (_isArabic) {
      ref.read(localeProvider.notifier).setArabic();
    } else {
      ref.read(localeProvider.notifier).setEnglish();
    }
    await LocalStorageService.saveLanguageRegion(
      languageCode: _isArabic ? 'ar' : 'en',
      countryCode: _countryCode,
    );
    if (mounted) context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return KayanEntryScaffold(
      smallHero: true,
      heroHeight: 200,
      hero: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          children: [
            const KayanBrandLogo(size: 56),
            const SizedBox(height: 16),
            const KayanEntryTitle(before: 'اختر ', highlight: 'لغتك ودولتك'),
          ],
        ),
      ),
      sheet: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KayanLangToggle(
            isArabic: _isArabic,
            onChanged: (ar) => setState(() => _isArabic = ar),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _countries.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: KayanDesignTokens.border),
              itemBuilder: (context, index) {
                final item = _countries[index];
                return KayanCountryRadioTile(
                  flag: item.$4,
                  title: _isArabic ? item.$2 : item.$3,
                  selected: _countryCode == item.$1,
                  onTap: () => setState(() => _countryCode = item.$1),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          KayanCtaButton(
            label: _isArabic ? 'متابعة' : 'Continue',
            onPressed: _continue,
            trailingIcon: Icons.arrow_back_ios_new_rounded,
          ),
        ],
      ),
    );
  }
}
