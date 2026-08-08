// Service tracking — light design (31-hs-tracking.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../presentation/providers/service_providers.dart';

class ServiceTrackingLightScreen extends ConsumerWidget {
  const ServiceTrackingLightScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final bookingAsync = ref.watch(serviceBookingProvider(bookingId));

    return bookingAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (booking) {
    final tech = booking.technician;

    final steps = ar
        ? ['تم التأكيد', 'الفني في الطريق', 'وصل للموقع', 'جاري التنفيذ']
        : ['Confirmed', 'On the way', 'Arrived', 'In progress'];
    const activeStep = 1;

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: Column(
        children: [
          KayanSectionHero(
            title: ar ? 'تتبع الحجز' : 'Track booking',
            variant: KayanSectionHeroVariant.green,
            leading: KayanHeroIconButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => context.pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: KayanDesignTokens.kGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: KayanDesignTokens.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map_rounded, size: 40, color: KayanDesignTokens.kGreen),
                      const SizedBox(height: 8),
                      Text(ar ? 'الفني على بعد 12 دقيقة' : 'Technician ETA 12 min', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (tech != null)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: KayanDesignTokens.border)),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: KayanDesignTokens.kGreen, child: Text(tech.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tech.name, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                              Text('${tech.rating} ⭐ · ${tech.completedJobs} ${ar ? 'مهمة' : 'jobs'}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.phone_rounded, color: KayanDesignTokens.kGreen)),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                KayanSectionHeader(title: ar ? 'حالة الطلب' : 'Status'),
                const SizedBox(height: 12),
                ...List.generate(steps.length, (i) {
                  final done = i <= activeStep;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: done ? KayanDesignTokens.kGreen : KayanDesignTokens.bg,
                            shape: BoxShape.circle,
                            border: Border.all(color: done ? KayanDesignTokens.kGreen : KayanDesignTokens.border),
                          ),
                          child: Icon(done ? Icons.check_rounded : Icons.circle, size: 14, color: done ? Colors.white : KayanDesignTokens.muted),
                        ),
                        const SizedBox(width: 12),
                        Text(steps[i], style: KayanDesignTokens.cairo(fontWeight: done ? FontWeight.w800 : FontWeight.w500, color: done ? KayanDesignTokens.kBlueDeep : KayanDesignTokens.muted)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}
