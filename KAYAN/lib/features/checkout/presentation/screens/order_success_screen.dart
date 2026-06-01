// ============================================================
// KAYAN — Order Success Screen
// lib/features/checkout/presentation/screens/order_success_screen.dart
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';

class OrderSuccessScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderSuccessScreen> createState() =>
      _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends ConsumerState<OrderSuccessScreen>
    with TickerProviderStateMixin {

  late final AnimationController _checkCtrl;
  late final AnimationController _confettiCtrl;
  late final AnimationController _contentCtrl;
  late final Animation<double>   _checkScale;
  late final Animation<double>   _checkOpacity;
  late final Animation<double>   _contentSlide;
  late final Animation<double>   _contentFade;

  @override
  void initState() {
    super.initState();

    _checkCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 700),
    );
    _checkScale = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_checkCtrl);
    _checkOpacity = CurvedAnimation(
      parent: _checkCtrl, curve: const Interval(0.0, 0.3),
    );

    _confettiCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 3000),
    );

    _contentCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 500),
    );
    _contentSlide = Tween<double>(begin: 40, end: 0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_contentCtrl);
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);

    HapticFeedback.heavyImpact();
    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _checkCtrl.forward();
    _confettiCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _contentCtrl.forward();
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _confettiCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final orderNum = widget.orderId;

    return WillPopScope(
      onWillPop: () async {
        context.go(AppRoutes.home);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(gradient: AppGradients.hero),
            ),

            // Confetti particles
            ...List.generate(20, (i) => _ConfettiParticle(
              index:  i,
              ctrl:   _confettiCtrl,
              size:   MediaQuery.sizeOf(context),
            )),

            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Check circle ───────────────────────
                    ScaleTransition(
                      scale: _checkScale,
                      child: FadeTransition(
                        opacity: _checkOpacity,
                        child: Container(
                          width:  120, height: 120,
                          decoration: BoxDecoration(
                            shape:    BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.success, AppColors.successDark],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:      AppColors.success.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size:  60,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Animated content ───────────────────
                    AnimatedBuilder(
                      animation: _contentCtrl,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(0, _contentSlide.value),
                        child: FadeTransition(
                          opacity: _contentFade,
                          child:   child,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Headline
                          Text(
                            isArabic ? '🎉 تم الطلب بنجاح!' : '🎉 Order Placed!',
                            style: isArabic
                                ? AppTextStyles.arabicHeadlineLarge
                                : AppTextStyles.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isArabic
                                ? 'شكراً لك! سنعالج طلبك في أقرب وقت.'
                                : 'Thank you! We\'ll process your order shortly.',
                            style: (isArabic
                                    ? AppTextStyles.arabicBodyMedium
                                    : AppTextStyles.bodyMedium)
                                .copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // Order ID card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:        AppColors.bgCard,
                              borderRadius: AppBorderRadius.card,
                              border:       Border.all(
                                  color: AppColors.borderGold),
                              boxShadow: [
                                BoxShadow(
                                  color:      AppColors.metallicGold
                                      .withOpacity(0.1),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  isArabic ? 'رقم الطلب' : 'Order Number',
                                  style: (isArabic
                                          ? AppTextStyles.arabicCaption
                                          : AppTextStyles.caption)
                                      .copyWith(color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  orderNum,
                                  style: AppTextStyles.orderNumber.copyWith(
                                    fontSize: 18, letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 1,
                                  color:  AppColors.borderSubtle,
                                ),
                                const SizedBox(height: 12),
                                // Delivery estimate
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _InfoChip(
                                      icon:  Icons.schedule_rounded,
                                      label: isArabic
                                          ? '2-3 أيام'
                                          : '2-3 days',
                                      sub: isArabic ? 'وقت التوصيل' : 'Delivery',
                                    ),
                                    Container(
                                        width: 1, height: 36,
                                        color: AppColors.borderSubtle),
                                    _InfoChip(
                                      icon:  Icons.notifications_rounded,
                                      label: isArabic
                                          ? 'SMS + App'
                                          : 'SMS + App',
                                      sub: isArabic ? 'سيصلك تنبيه' : 'Updates via',
                                    ),
                                    Container(
                                        width: 1, height: 36,
                                        color: AppColors.borderSubtle),
                                    _InfoChip(
                                      icon:  Icons.support_agent_rounded,
                                      label: isArabic ? '24/7' : '24/7',
                                      sub: isArabic ? 'دعم العملاء' : 'Support',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Buttons
                          GestureDetector(
                            onTap: () => context.push(
                              AppRoutes.orderPath(orderNum),
                            ),
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                gradient:     AppGradients.primaryButton,
                                borderRadius: AppBorderRadius.button,
                                boxShadow: [
                                  BoxShadow(
                                    color:      AppColors.royalBlue
                                        .withOpacity(0.35),
                                    blurRadius: 16,
                                    offset:     const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  isArabic
                                      ? 'تتبع طلبك'
                                      : 'Track Your Order',
                                  style: isArabic
                                      ? AppTextStyles.arabicButton
                                      : AppTextStyles.buttonMedium,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextButton(
                            onPressed: () => context.go(AppRoutes.home),
                            child: Text(
                              isArabic
                                  ? 'العودة للرئيسية'
                                  : 'Back to Home',
                              style: (isArabic
                                      ? AppTextStyles.arabicBodyMedium
                                      : AppTextStyles.bodyMedium)
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   sub;
  const _InfoChip({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, size: 18, color: AppColors.royalBlue),
      const SizedBox(height: 4),
      Text(label, style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      Text(sub, style: AppTextStyles.caption),
    ],
  );
}

// Confetti particle
class _ConfettiParticle extends StatelessWidget {
  final int             index;
  final AnimationController ctrl;
  final Size            size;
  const _ConfettiParticle({
    required this.index,
    required this.ctrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final rng     = math.Random(index * 13);
    final x       = rng.nextDouble() * size.width;
    final delay   = rng.nextDouble() * 0.5;
    final dotSize = 6.0 + rng.nextDouble() * 6;
    final colors  = [
      AppColors.metallicGold, AppColors.royalBlue,
      AppColors.success, AppColors.error,
      AppColors.skyBlue, AppColors.luxuryGold,
    ];
    final color = colors[index % colors.length];

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final progress = ((ctrl.value - delay).clamp(0, 1) / (1 - delay));
        if (progress <= 0) return const SizedBox.shrink();

        final y      = -50 + progress * (size.height + 100);
        final wobble = math.sin(progress * math.pi * 4 + index) * 20;
        final opacity = (1 - progress).clamp(0.0, 1.0);

        return Positioned(
          left: x + wobble,
          top:  y,
          child: Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: progress * math.pi * 3,
              child: Container(
                width:  dotSize, height: dotSize * 0.6,
                decoration: BoxDecoration(
                  color:        color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
