// ============================================================
// KAYAN Super App — Onboarding Screen
// lib/features/onboarding/presentation/screens/onboarding_screen.dart
//
// 3 pages: E-commerce → Services → Classifieds
// Smooth PageView with gold dot indicator, skip button
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/services/local_storage_service.dart';

class _OnboardPage {
  final String emoji;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final List<Color> gradientColors;

  const _OnboardPage({
    required this.emoji,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.gradientColors,
  });
}

const _pages = [
  _OnboardPage(
    emoji: '🛒',
    titleAr: 'تسوق من أفضل المتاجر',
    titleEn: 'Shop from Top Vendors',
    bodyAr: 'آلاف المنتجات من متاجر موثوقة في السعودية والإمارات وقطر. شحن سريع وأسعار تنافسية.',
    bodyEn: 'Thousands of products from trusted vendors across Saudi Arabia, UAE & Qatar. Fast delivery, competitive prices.',
    gradientColors: [Color(0xFF0A1F3B), Color(0xFF1E3A8A)],
  ),
  _OnboardPage(
    emoji: '🔧',
    titleAr: 'خدمات منزلية بضغطة زر',
    titleEn: 'Home Services On-Demand',
    bodyAr: 'سباكة، كهرباء، تكييف، تنظيف وأكثر. فنيون معتمدون يصلون إليك في أسرع وقت.',
    bodyEn: 'Plumbing, electrical, AC, cleaning & more. Certified technicians reach you fast, even 24/7 emergency.',
    gradientColors: [Color(0xFF0A1F3B), Color(0xFF004B93)],
  ),
  _OnboardPage(
    emoji: '📢',
    titleAr: 'بيع واشترِ بسهولة',
    titleEn: 'Buy & Sell Easily',
    bodyAr: 'أعلن عن منتجاتك أو ابحث عن صفقات رائعة في إعلانات كيان المبوبة.',
    bodyEn: 'Post your items for sale or find great deals on KAYAN\'s classifieds marketplace.',
    gradientColors: [Color(0xFF0A1F3B), Color(0xFF2A1A5A)],
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _current = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < _pages.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve:    Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await LocalStorageService.markOnboardingSeen();
    if (mounted) context.go(AppRoutes.phoneInput);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final isLast   = _current == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Stack(
        children: [
          // ── Page content ────────────────────────────────
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _OnboardPageView(
              page:     _pages[i],
              isArabic: isArabic,
            ),
          ),

          // ── Skip ────────────────────────────────────────
          SafeArea(
            child: Align(
              alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    isArabic ? 'تخطي' : 'Skip',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom controls ──────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding, 0,
                  AppSpacing.pagePadding, 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dot indicator
                    SmoothPageIndicator(
                      controller: _ctrl,
                      count:      _pages.length,
                      effect: WormEffect(
                        dotWidth:    8,
                        dotHeight:   8,
                        activeDotColor: AppColors.metallicGold,
                        dotColor:    AppColors.borderDefault,
                        spacing:     8,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // CTA Button
                    GestureDetector(
                      onTap: _next,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: isLast
                              ? AppGradients.goldButton
                              : AppGradients.primaryButton,
                          borderRadius: AppBorderRadius.button,
                          boxShadow: [
                            BoxShadow(
                              color: (isLast
                                      ? AppColors.metallicGold
                                      : AppColors.royalBlue)
                                  .withOpacity(0.35),
                              blurRadius: 20,
                              offset:     const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isLast
                                ? (isArabic ? 'ابدأ الآن' : 'Get Started')
                                : (isArabic ? 'التالي' : 'Next'),
                            style: (isArabic
                                    ? AppTextStyles.arabicButton
                                    : AppTextStyles.buttonMedium)
                                .copyWith(
                              color: isLast
                                  ? AppColors.bgPrimary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPageView extends StatelessWidget {
  final _OnboardPage page;
  final bool         isArabic;
  const _OnboardPageView({required this.page, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:  Alignment.topCenter,
          end:    Alignment.bottomCenter,
          colors: page.gradientColors,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji icon in gold circle
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape:   BoxShape.circle,
                  color:   AppColors.royalBlue.withOpacity(0.15),
                  border:  Border.all(color: AppColors.borderGold, width: 1),
                ),
                child: Center(
                  child: Text(
                    page.emoji,
                    style: const TextStyle(fontSize: 56),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                isArabic ? page.titleAr : page.titleEn,
                style: isArabic
                    ? AppTextStyles.arabicHeadlineMedium
                    : AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                isArabic ? page.bodyAr : page.bodyEn,
                style: (isArabic
                        ? AppTextStyles.arabicBodyMedium
                        : AppTextStyles.bodyMedium)
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines:  4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
