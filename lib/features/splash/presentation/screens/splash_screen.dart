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

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/services/local_storage_service.dart';

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
    final hasOnboarding = LocalStorageService.hasSeenOnboarding;

    if (!hasOnboarding) {
      context.go(AppRoutes.onboarding);
    } else if (!authState.isAuthenticated) {
      context.go(AppRoutes.phoneInput);
    } else if (!authState.isProfileComplete) {
      context.go(AppRoutes.profileSetup);
    } else {
      context.go(AppRoutes.home);
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
    final size = MediaQuery.sizeOf(context);

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

          // ── Decorative particles ─────────────────────────
          ...List.generate(12, (i) => _ParticleDot(index: i, size: size)),

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
                    child: Column(
                      children: [
                        // ── K Lettermark ──────────────────
                        _KayanLogoMark(shimmer: _shimmerAnim),
                        const SizedBox(height: 24),
                        // ── KAYAN Wordmark ─────────────────
                        _KayanWordmark(shimmer: _shimmerAnim),
                      ],
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

// ──────────────────────────────────────────────────────────────
// K LETTERMARK
// ──────────────────────────────────────────────────────────────
class _KayanLogoMark extends StatelessWidget {
  final Animation<double> shimmer;
  const _KayanLogoMark({required this.shimmer});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmer,
      builder: (_, __) {
        return Container(
          width:  90,
          height: 90,
          decoration: BoxDecoration(
            gradient:     AppGradients.primaryButton,
            borderRadius: BorderRadius.circular(24),
            border:       Border.all(
              color: AppColors.borderGold,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:      AppColors.royalBlue.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 0,
                offset:     const Offset(0, 8),
              ),
              BoxShadow(
                color:      AppColors.metallicGold.withOpacity(
                    0.15 * shimmer.value,
                ),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Gold shimmer overlay during animation
              if (shimmer.value > 0)
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Opacity(
                    opacity: shimmer.value * 0.3,
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment(-1.5 + shimmer.value * 3, 0),
                          end:   Alignment(shimmer.value * 3, 0),
                          colors: const [
                            Colors.transparent,
                            Colors.white,
                            Colors.transparent,
                          ],
                        ).createShader(bounds);
                      },
                      child: Container(color: Colors.white),
                    ),
                  ),
                ),
              // K Letter
              const Text(
                'K',
                style: TextStyle(
                  fontFamily:  'Inter',
                  fontSize:    48,
                  fontWeight:  FontWeight.w800,
                  color:       Colors.white,
                  height:      1.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// KAYAN WORDMARK — Gold shimmer text
// ──────────────────────────────────────────────────────────────
class _KayanWordmark extends StatelessWidget {
  final Animation<double> shimmer;
  const _KayanWordmark({required this.shimmer});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmer,
      builder: (_, __) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final sweep = shimmer.value;
            return LinearGradient(
              begin: Alignment(-2 + sweep * 4, 0),
              end:   Alignment(-1 + sweep * 4, 0),
              colors: const [
                AppColors.metallicGold,
                AppColors.goldLight,
                AppColors.luxuryGold,
                AppColors.metallicGold,
              ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            'KAYAN',
            style: AppTextStyles.logoText.copyWith(
              fontSize:    36,
              letterSpacing: 10,
              foreground: Paint()
                ..color = AppColors.metallicGold,
            ),
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// DECORATIVE PARTICLE DOT
// ──────────────────────────────────────────────────────────────
class _ParticleDot extends StatefulWidget {
  final int   index;
  final Size  size;
  const _ParticleDot({required this.index, required this.size});

  @override
  State<_ParticleDot> createState() => _ParticleDotState();
}

class _ParticleDotState extends State<_ParticleDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final double _x, _y, _dotSize;
  late final Duration _delay;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(widget.index * 37);
    _x       = rng.nextDouble() * widget.size.width;
    _y       = rng.nextDouble() * widget.size.height;
    _dotSize = 1.5 + rng.nextDouble() * 2.5;
    _delay   = Duration(milliseconds: rng.nextInt(1500));

    _ctrl = AnimationController(
      vsync:    this,
      duration: Duration(milliseconds: 1500 + rng.nextInt(1000)),
    )..repeat(reverse: true);

    Future.delayed(_delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x,
      top:  _y,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Opacity(
          opacity: 0.1 + _ctrl.value * 0.25,
          child: Container(
            width:  _dotSize,
            height: _dotSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.metallicGold,
            ),
          ),
        ),
      ),
    );
  }
}
