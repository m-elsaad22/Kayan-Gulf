// KAYAN — Booking Success Screen
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';

class BookingSuccessScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const BookingSuccessScreen({super.key, required this.bookingId});
  @override ConsumerState<BookingSuccessScreen> createState() => _BSS();
}

class _BSS extends ConsumerState<BookingSuccessScreen> with TickerProviderStateMixin {
  late final AnimationController _chk = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  late final AnimationController _cnf = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
  late final Animation<double> _cs    = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)).animate(_chk);

  @override void dispose() { _chk.dispose(); _cnf.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ar   = ref.watch(isArabicProvider);
    final size = MediaQuery.sizeOf(context);
    return WillPopScope(onWillPop: () async { context.go(AppRoutes.home); return false; }, child: Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: AppGradients.hero)),
        ...List.generate(16, (i) => _CP(i: i, ctrl: _cnf, size: size)),
        SafeArea(child: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ScaleTransition(scale: _cs, child: Container(width: 110, height: 110,
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppColors.success, AppColors.successDark]),
                boxShadow: [BoxShadow(color: AppColors.success, blurRadius: 30)]),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 56))),
          const SizedBox(height: 28),
          Text(ar ? '🎉 تم تأكيد الحجز!' : '🎉 Booking Confirmed!',
              style: ar ? AppTextStyles.arabicHeadlineMedium : AppTextStyles.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(ar ? 'سيصلك إشعار عندما يتوجه الفني إليك' : "You'll be notified when the technician heads your way",
              style: (ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium).copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
          const SizedBox(height: 28),
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card,
                border: Border.all(color: AppColors.borderGold),
                boxShadow: [BoxShadow(color: AppColors.metallicGold.withOpacity(0.1), blurRadius: 20)]),
            child: Column(children: [
              Text(ar ? 'رقم الحجز' : 'Booking Number', style: AppTextStyles.caption),
              const SizedBox(height: 6),
              Text(widget.bookingId, style: AppTextStyles.orderNumber.copyWith(fontSize: 16, letterSpacing: 2)),
              const SizedBox(height: 12),
              const Divider(color: AppColors.borderSubtle, height: 1),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _SI('📅', ar ? 'غداً 9ص' : 'Tomorrow 9AM'),
                Container(width: 1, height: 30, color: AppColors.borderSubtle),
                _SI('👤', ar ? 'محمد الغامدي' : 'Mohammed'),
                Container(width: 1, height: 30, color: AppColors.borderSubtle),
                _SI('⏱️', ar ? 'ساعتان' : '2 hours'),
              ]),
            ])),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => context.push(AppRoutes.myBookings),
            child: Container(height: 50, decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: AppBorderRadius.button,
                boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]),
                child: Center(child: Text(ar ? 'عرض حجوزاتي' : 'View My Bookings', style: ar ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium)))),
          const SizedBox(height: 12),
          TextButton(onPressed: () => context.go(AppRoutes.home), child: Text(ar ? 'العودة للرئيسية' : 'Back to Home',
              style: (ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium).copyWith(color: AppColors.textSecondary))),
        ])))),
      ]),
    ));
  }
}

Widget _SI(String e, String l) => Column(children: [Text(e, style: const TextStyle(fontSize: 18)), const SizedBox(height: 2), Text(l, style: AppTextStyles.caption.copyWith(fontSize: 8))]);

class _CP extends StatelessWidget {
  final int i; final AnimationController ctrl; final Size size;
  const _CP({required this.i, required this.ctrl, required this.size});
  @override
  Widget build(BuildContext context) {
    final rng   = math.Random(i * 17);
    final x     = rng.nextDouble() * size.width;
    final delay = rng.nextDouble() * 0.4;
    final colors = [AppColors.metallicGold, AppColors.royalBlue, AppColors.success, AppColors.error, AppColors.skyBlue];
    return AnimatedBuilder(animation: ctrl, builder: (_, __) {
      final p = ((ctrl.value - delay).clamp(0.0, 1.0) / (1 - delay));
      if (p <= 0) return const SizedBox.shrink();
      return Positioned(left: x + math.sin(p * math.pi * 4 + i) * 20, top: -50 + p * (size.height + 100),
          child: Opacity(opacity: (1 - p).clamp(0.0, 1.0), child: Transform.rotate(angle: p * math.pi * 3,
              child: Container(width: 8, height: 5, decoration: BoxDecoration(color: colors[i % colors.length], borderRadius: BorderRadius.circular(2))))));
    });
  }
}
