// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/services/local_storage_service.dart';

class LanguageRegionScreen extends ConsumerStatefulWidget {
  const LanguageRegionScreen({super.key});

  @override
  ConsumerState<LanguageRegionScreen> createState() => _LanguageRegionScreenState();
}

class _LanguageRegionScreenState extends ConsumerState<LanguageRegionScreen> {
  String _languageCode = 'ar';
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
    if (_languageCode == 'ar') {
      ref.read(localeProvider.notifier).setArabic();
    } else {
      ref.read(localeProvider.notifier).setEnglish();
    }
    await LocalStorageService.saveLanguageRegion(
      languageCode: _languageCode,
      countryCode: _countryCode,
    );
    if (mounted) context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        body: Container(
          decoration: const BoxDecoration(gradient: AppGradients.hero),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    isArabic ? 'مرحباً بك في كيان' : 'Welcome to KAYAN',
                    style: isArabic
                        ? AppTextStyles.arabicHeadlineLarge
                        : AppTextStyles.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? 'اختر اللغة والدولة لتجربة مخصصة في الخليج'
                        : 'Choose language and region for a tailored GCC experience',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _SectionTitle(isArabic ? 'اللغة' : 'Language'),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceCard(
                          selected: _languageCode == 'ar',
                          title: 'العربية',
                          subtitle: 'RTL',
                          onTap: () => setState(() => _languageCode = 'ar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ChoiceCard(
                          selected: _languageCode == 'en',
                          title: 'English',
                          subtitle: 'LTR',
                          onTap: () => setState(() => _languageCode = 'en'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(isArabic ? 'الدولة' : 'Country'),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _countries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _countries[index];
                        return _CountryTile(
                          selected: _countryCode == item.$1,
                          flag: item.$4,
                          title: isArabic ? item.$2 : item.$3,
                          onTap: () => setState(() => _countryCode = item.$1),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _continue,
                    child: Text(isArabic ? 'متابعة' : 'Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
      child: Text(
        text,
        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.royalBlue.withOpacity(0.16) : AppColors.bgCard,
          borderRadius: AppBorderRadius.card,
          border: Border.all(
            color: selected ? AppColors.borderActiveBold : AppColors.borderSubtle,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(title, style: AppTextStyles.titleMedium),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryTile extends StatelessWidget {
  final bool selected;
  final String flag;
  final String title;
  final VoidCallback onTap;

  const _CountryTile({
    required this.selected,
    required this.flag,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: selected ? AppColors.royalBlue.withOpacity(0.12) : AppColors.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.card,
        side: BorderSide(
          color: selected ? AppColors.borderActiveBold : AppColors.borderSubtle,
        ),
      ),
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.metallicGold)
          : const Icon(Icons.circle_outlined, color: AppColors.textMuted),
    );
  }
}
