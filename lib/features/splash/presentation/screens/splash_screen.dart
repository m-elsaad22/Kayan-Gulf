// ============================================================
// KAYAN Super App — Splash Screen
// lib/features/splash/presentation/screens/splash_screen.dart
//
// Sequence:
//   1. Show logo + shimmer gold animation (1.5 s)
//   2. Check auth token in background
//   3. Check onboarding status
//   4. Navigate: Onboarding | Phone Login | Home
//
// Design: Royal Navy background, gold KAYAN wordmark,
//         metallic shimmer sweep, subtle particle dots
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../core/services/admin_data_service.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../../../shared/widgets/luxury/luxury_glass.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {

  // ── Animation controllers ──────────────────────────────────
  late final AnimationController _fadeCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _scaleCtrl;
  late final AnimationController _taglineCtrl;

  // ── Animations ────────────────────────────────────────────
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _shimmerAnim;
  late final Animation<double> _taglineFade;
  late final Animation<Offset>  _taglineSlide;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  void _initAnimations() {
    // Logo fade-in
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoFade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    // Logo scale (subtle pop)
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_scaleCtrl);

    // Gold shimmer sweep (loops 2x)
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _shimmerAnim = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut);

    // Tagline fade + slide
    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineFade  = CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut);
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end:   Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(_taglineCtrl);
  }

  Future<void> _startSequence() async {
    // Start logo animations
    await Future.wait([_fadeCtrl.forward(), _scaleCtrl.forward()]);

    // Short pause, then shimmer
    await Future.delayed(const Duration(milliseconds: 200));
    await _shimmerCtrl.forward();

    // Tagline appears
    await Future.delayed(const Duration(milliseconds: 100));
    _taglineCtrl.forward();

    // Hold for brand recognition
    await Future.delayed(const Duration(milliseconds: 800));

    // Navigate
    if (mounted) _navigate();
  }

  void _navigate() {
    final authState = ref.read(authStateProvider);
    final hasLanguageRegion = LocalStorageService.hasSelectedLanguageRegion;
    final hasOnboarding = LocalStorageService.hasSeenOnboarding;
    final isGuest = LocalStorageService.isGuestMode;

    if (!hasLanguageRegion) {
      context.go(AppRoutes.languageRegion);
    } else if (!hasOnboarding) {
      context.go(AppRoutes.onboarding);
    } else if (authState.isAuthenticated || isGuest) {
      context.go(AppRoutes.dashboard);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _shimmerCtrl.dispose();
    _scaleCtrl.dispose();
    _taglineCtrl.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.splash,
            ),
          ),

          // ── Blue glow behind logo ────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _logoFade,
              builder: (_, __) => Opacity(
                opacity: _logoFade.value * 0.4,
                child: Container(
                  width:  220,
                  height: 220,
                  decoration: const BoxDecoration(
                    shape:      BoxShape.circle,
                    gradient:   AppGradients.blueGlow,
                  ),
                ),
              ),
            ),
          ),

          // ── Main content ─────────────────────────────────
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo mark (K lettermark + wordmark)
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: LuxuryGlassPanel(
                      padding: const EdgeInsets.all(28),
                      blurSigma: 24,
                      borderColor: AppColors.metallicGold.withValues(alpha: 0.35),
                      child: Image.asset(
                        AdminDataService.instance.getLogoPath().startsWith('http')
                            ? 'assets/images/kayan_logo.png'
                            : AdminDataService.instance.getLogoPath(),
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/kayan_logo.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Tagline ──────────────────────────────
                SlideTransition(
                  position: _taglineSlide,
                  child: FadeTransition(
                    opacity: _taglineFade,
                    child: Column(
                      children: [
                        Text(
                          'التسوق · الخدمات · الإعلانات',
                          style: AppTextStyles.arabicCaption.copyWith(
                            color:         AppColors.textSecondary,
                            letterSpacing: 1.5,
                            fontSize:      13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Shop · Services · Classifieds',
                          style: AppTextStyles.caption.copyWith(
                            color:         AppColors.textMuted,
                            letterSpacing: 2.0,
                            fontSize:      10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Loading indicator (bottom) ───────────────────
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _taglineFade,
              child: Center(
                child: SizedBox(
                  width:  120,
                  height: 2,
                  child: AnimatedBuilder(
                    animation: _shimmerCtrl,
                    builder: (_, __) {
                      return LinearProgressIndicator(
                        value:           null,
                        backgroundColor: AppColors.borderSubtle,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.metallicGold,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // ── Version (bottom right) ───────────────────────
          Positioned(
            bottom: 24,
            right: 24,
            child: FadeTransition(
              opacity: _taglineFade,
              child: Text(
                'v1.0.0',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textDisabled,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
