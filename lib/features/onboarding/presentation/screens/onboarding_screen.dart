// Onboarding — matches design/html/03–05-onboarding-*.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_routes.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class _OnboardPage {
  final String titleAr;
  final String titleEn;
  final String highlightAr;
  final String highlightEn;
  final String bodyAr;
  final String bodyEn;
  final String ctaAr;
  final String ctaEn;

  const _OnboardPage({
    required this.titleAr,
    required this.titleEn,
    required this.highlightAr,
    required this.highlightEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.ctaAr,
    required this.ctaEn,
  });
}

const _pages = [
  _OnboardPage(
    titleAr: 'مرحباً بك في ',
    titleEn: 'Welcome to ',
    highlightAr: 'كيان',
    highlightEn: 'KAYAN',
    bodyAr: 'السوبر أب الخليجي الأول — كل احتياجاتك اليومية في تطبيق واحد أنيق وموثوق.',
    bodyEn: 'The Gulf\'s first super app — all your daily needs in one elegant, trusted place.',
    ctaAr: 'التالي',
    ctaEn: 'Next',
  ),
  _OnboardPage(
    titleAr: 'كل ما تحتاجه في ',
    titleEn: 'Everything you need in ',
    highlightAr: 'تطبيق واحد',
    highlightEn: 'one app',
    bodyAr: 'خدمات منزلية، متجر متكامل، إعلانات مبوبة، وتوصيل طعام — بضغطة واحدة.',
    bodyEn: 'Home services, shopping, classifieds, and food delivery — one tap away.',
    ctaAr: 'التالي',
    ctaEn: 'Next',
  ),
  _OnboardPage(
    titleAr: 'استعد ',
    titleEn: 'Get ready for a ',
    highlightAr: 'لتجربة فريدة',
    highlightEn: 'unique experience',
    bodyAr: 'خصومات حصرية، فنيون معتمدون، وتوصيل سريع أينما كنت في الخليج.',
    bodyEn: 'Exclusive deals, certified pros, and fast delivery across the GCC.',
    ctaAr: 'ابدأ الآن',
    ctaEn: 'Get started',
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

  Future<void> _finish() async {
    await LocalStorageService.markOnboardingSeen();
    if (mounted) context.go(AppRoutes.login);
  }

  void _next() {
    if (_current < _pages.length - 1) {
      _ctrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.kBlueDeep,
      body: PageView.builder(
        controller: _ctrl,
        onPageChanged: (i) => setState(() => _current = i),
        itemCount: _pages.length,
        itemBuilder: (_, i) {
          final p = _pages[i];
          return KayanHeroBackdrop(
            minHeight: MediaQuery.sizeOf(context).height,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
                    child: Row(
                      children: [
                        KayanOnboardingDots(count: _pages.length, index: _current),
                        const Spacer(),
                        GestureDetector(
                          onTap: _finish,
                          child: Text(
                            ar ? 'تخطي' : 'Skip',
                            style: KayanDesignTokens.cairo(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                            ),
                            child: Center(child: KayanBrandLogo(size: i == 0 ? 140 : 120)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        KayanEntryTitle(
                          before: ar ? p.titleAr : p.titleEn,
                          highlight: ar ? p.highlightAr : p.highlightEn,
                        ),
                        const SizedBox(height: 10),
                        KayanEntrySubtitle(ar ? p.bodyAr : p.bodyEn),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 36),
                    child: KayanCtaButton(
                      label: ar ? p.ctaAr : p.ctaEn,
                      onPressed: _next,
                      trailingIcon: _current < _pages.length - 1 ? Icons.arrow_back_ios_new_rounded : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
