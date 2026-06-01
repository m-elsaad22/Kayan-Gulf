// KAYAN — Order Tracking Screen
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/providers/locale_provider.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});
  @override ConsumerState<OrderTrackingScreen> createState() => _OTS();
}

class _OTS extends ConsumerState<OrderTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  double _progress = 0.45; // delivery truck progress
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _t = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && _progress < 0.9) setState(() => _progress += 0.05);
    });
  }

  @override void dispose() { _pulse.dispose(); _t?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    final steps = ar
      ? ['تم الطلب', 'قيد التجهيز', 'تم الشحن', 'في الطريق', 'تم التوصيل']
      : ['Ordered', 'Processing', 'Shipped', 'On the Way', 'Delivered'];

    final currentStep = 3; // "في الطريق"

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle: true,
        title: Text(ar ? 'تتبع الطلب' : 'Track Order',
            style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(
          icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(children: [
          // Order number
          Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(gradient: AppGradients.card, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderGold)),
            child: Row(children: [
              const Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.metallicGold),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ar ? 'رقم الطلب' : 'Order Number', style: AppTextStyles.caption),
                Text(widget.orderId, style: AppTextStyles.orderNumber.copyWith(fontSize: 16, letterSpacing: 2)),
              ]),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppColors.categoryTeal.withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.categoryTeal.withOpacity(0.3))),
                child: Text(ar ? '🚚 في الطريق' : '🚚 On the Way',
                    style: AppTextStyles.badgeMedium.copyWith(color: AppColors.categoryTeal))),
            ])),

          const SizedBox(height: 20),

          // Simulated map area
          Container(height: 200, decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
            clipBehavior: Clip.antiAlias,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => CustomPaint(
                painter: _MapPainter(_progress, _pulse.value),
                size: const Size(double.infinity, 200),
              ),
            )),

          const SizedBox(height: 8),
          Text(ar ? 'الموقع المباشر للشاحنة (محاكاة)' : 'Live truck location (simulated)',
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted), textAlign: TextAlign.center),

          const SizedBox(height: 20),

          // ETA card
          Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _ETACell(Icons.schedule_rounded, AppColors.royalBlue, ar ? 'وقت الوصول المتوقع' : 'Estimated Arrival', ar ? 'اليوم 4:30 م' : 'Today 4:30 PM'),
              Container(width: 1, height: 40, color: AppColors.borderSubtle),
              _ETACell(Icons.location_on_rounded, AppColors.metallicGold, ar ? 'المسافة المتبقية' : 'Distance Left', ar ? '3.2 كم' : '3.2 km'),
              Container(width: 1, height: 40, color: AppColors.borderSubtle),
              _ETACell(Icons.local_shipping_rounded, AppColors.categoryTeal, ar ? 'الشاحن' : 'Driver', 'محمد'),
            ])),

          const SizedBox(height: 20),

          // Timeline
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderSubtle)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(ar ? 'مراحل التوصيل' : 'Delivery Timeline',
                  style: ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
              const SizedBox(height: 16),
              ...List.generate(steps.length, (i) {
                final done    = i < currentStep;
                final current = i == currentStep;
                final color   = done || current ? AppColors.royalBlue : AppColors.textDisabled;
                return Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(children: [
                    AnimatedContainer(duration: const Duration(milliseconds: 300),
                      width:  current ? 28 : 22, height: current ? 28 : 22,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        gradient: (done || current) ? AppGradients.primaryButton : null,
                        color: (done || current) ? null : AppColors.bgCard2,
                        border: (done || current) ? null : Border.all(color: AppColors.borderDefault),
                        boxShadow: current ? [BoxShadow(color: AppColors.royalBlue.withOpacity(0.4), blurRadius: 12)] : [],
                      ),
                      child: Center(child: done ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) :
                        current ? AnimatedBuilder(animation: _pulse, builder: (_, __) => Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.5 + _pulse.value * 0.5), shape: BoxShape.circle))) :
                        null)),
                    if (i < steps.length - 1) Container(width: 2, height: 24, color: done ? AppColors.royalBlue : AppColors.borderDefault),
                  ]),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: 3),
                    Text(steps[i], style: TextStyle(fontSize: 13, fontWeight: current ? FontWeight.w700 : FontWeight.w500, color: color)),
                    if (current) Text(ar ? 'الشاحن في طريقه إليك الآن' : 'Driver is heading to you now',
                        style: AppTextStyles.caption.copyWith(color: AppColors.royalBlue)),
                    if (done) Text(ar ? 'مكتمل ✓' : 'Completed ✓', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                  ])),
                  if (done || current)
                    Text(['12:30 ص', '1:45 م', '2:20 م', '3:10 م', ''][i],
                        style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
                ]));
              }),
            ])),

          const SizedBox(height: 20),

          // Contact driver button
          Container(
            height: 50,
            decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: AppBorderRadius.button,
                boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]),
            child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(ar ? 'التواصل مع السائق' : 'Contact Driver',
                  style: ar ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium),
            ]))),
        ]),
      ),
    );
  }
}

Widget _ETACell(IconData ic, Color c, String l, String v) => Column(children: [
  Icon(ic, size: 18, color: c),
  const SizedBox(height: 4),
  Text(l, style: AppTextStyles.caption.copyWith(fontSize: 9), textAlign: TextAlign.center),
  Text(v, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.center),
]);

class _MapPainter extends CustomPainter {
  final double progress, pulse;
  _MapPainter(this.progress, this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = const Color(0xFF0E1C32));

    // Grid lines
    final gridPaint = Paint()..color = const Color(0xFF1E3055)..strokeWidth = 0.5;
    for (var x = 0.0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Road
    final roadPaint = Paint()..color = const Color(0xFF1A2A50)..strokeWidth = 12..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(40, size.height * 0.7), Offset(size.width - 40, size.height * 0.35), roadPaint);

    // Dashes on road
    final dashPaint = Paint()..color = const Color(0xFFD4AF37).withOpacity(0.5)..strokeWidth = 2;
    for (var t = 0.0; t < 1.0; t += 0.1) {
      final x1 = 40 + (size.width - 80) * t;
      final y1 = size.height * 0.7 + (size.height * 0.35 - size.height * 0.7) * t;
      final x2 = 40 + (size.width - 80) * (t + 0.05);
      final y2 = size.height * 0.7 + (size.height * 0.35 - size.height * 0.7) * (t + 0.05);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashPaint);
    }

    // Origin marker
    canvas.drawCircle(Offset(40, size.height * 0.7), 8, Paint()..color = AppColors.royalBlue);
    canvas.drawCircle(Offset(40, size.height * 0.7), 4, Paint()..color = Colors.white);

    // Destination marker
    final destPaint = Paint()..color = AppColors.success;
    canvas.drawCircle(Offset(size.width - 40, size.height * 0.35), 10, destPaint..color = AppColors.success.withOpacity(0.3 + pulse * 0.3));
    canvas.drawCircle(Offset(size.width - 40, size.height * 0.35), 6, destPaint..color = AppColors.success);
    canvas.drawCircle(Offset(size.width - 40, size.height * 0.35), 3, Paint()..color = Colors.white);

    // Truck position
    final tx = 40 + (size.width - 80) * progress;
    final ty = size.height * 0.7 + (size.height * 0.35 - size.height * 0.7) * progress;

    // Truck glow
    canvas.drawCircle(Offset(tx, ty), 16 + pulse * 4,
        Paint()..color = const Color(0xFF4169E1).withOpacity(0.15 + pulse * 0.1));

    // Truck body
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(tx, ty), width: 24, height: 14), const Radius.circular(4)),
        Paint()..color = const Color(0xFF4169E1));
    canvas.drawCircle(Offset(tx, ty), 4, Paint()..color = Colors.white);

    // Truck text
    final tp = TextPainter(text: const TextSpan(text: '🚚', style: TextStyle(fontSize: 14)), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(tx - 10, ty - 10));
  }

  @override bool shouldRepaint(_MapPainter old) => old.progress != progress || old.pulse != pulse;
}
