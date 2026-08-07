// Service booking success — light design (30-hs-success.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';

class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(gradient: KayanDesignTokens.gradGreen, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 52),
              ),
              const SizedBox(height: 24),
              Text(
                ar ? 'تم الحجز بنجاح!' : 'Booking confirmed!',
                style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep),
              ),
              const SizedBox(height: 8),
              Text(
                ar ? 'رقم الحجز: $bookingId' : 'Booking #$bookingId',
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
              ),
              const SizedBox(height: 32),
              KayanCtaButton(
                label: ar ? 'حجوزاتي' : 'My bookings',
                trailingIcon: Icons.event_note_rounded,
                variant: KayanCtaVariant.green,
                onPressed: () => context.push(AppRoutes.myBookings),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(ar ? 'العودة للرئيسية' : 'Back to home', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.kGreen)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
