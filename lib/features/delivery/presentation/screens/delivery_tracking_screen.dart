import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';

/// Matches design/html/99-or-tracking.html
class DeliveryTrackingScreen extends ConsumerWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final steps = ar
        ? ['تم الطلب', 'المطعم يجهّز', 'السائق في الطريق', 'تم التوصيل']
        : ['Order placed', 'Restaurant preparing', 'Driver on the way', 'Delivered'];

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: KayanDesignTokens.kBlueDeep,
        elevation: 0,
        title: Text(ar ? 'تتبع الطلب' : 'Track order', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(colors: [Color(0xFFDCEFE7), Color(0xFFEAF4F0)]),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 160),
                  painter: _GridPainter(),
                ),
                Transform.rotate(
                  angle: -0.785,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: KayanDesignTokens.gradGreen,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      boxShadow: KayanDesignTokens.shadowM,
                    ),
                    child: Transform.rotate(
                      angle: 0.785,
                      child: const Icon(Icons.location_on_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(steps.length, (i) {
            final done = i < 2;
            final active = i == 2;
            return Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: done || active ? KayanDesignTokens.gradGreen : null,
                      color: done || active ? null : KayanDesignTokens.border,
                      shape: BoxShape.circle,
                      boxShadow: active
                          ? [BoxShadow(color: KayanDesignTokens.success.withValues(alpha: 0.18), blurRadius: 0, spreadRadius: 5)]
                          : null,
                    ),
                    child: done
                        ? const Icon(Icons.check, size: 11, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(steps[i], style: KayanDesignTokens.cairo(fontSize: 13.5, fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                        Text(
                          active ? (ar ? 'الوصول خلال 12 دقيقة' : 'Arriving in 12 min') : (ar ? 'مكتمل' : 'Done'),
                          style: KayanDesignTokens.cairo(fontSize: 11.5, color: KayanDesignTokens.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KayanDesignTokens.border),
              boxShadow: KayanDesignTokens.shadowS,
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(gradient: KayanDesignTokens.gradGreen, shape: BoxShape.circle),
                  child: const Center(child: Text('م', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ar ? 'محمد — سائق التوصيل' : 'Mohammed — Delivery driver', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                      Text(ar ? '4.9 تقييم • دراجة نارية' : '4.9 rating • Motorcycle', style: KayanDesignTokens.cairo(fontSize: 11.5, color: KayanDesignTokens.muted)),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.phone_rounded, color: KayanDesignTokens.kGreen)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = KayanDesignTokens.success.withValues(alpha: 0.12)..strokeWidth = 1;
    const step = 22.0;
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
