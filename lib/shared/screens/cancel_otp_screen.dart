import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/widgets/design/kayan_design_widgets.dart';
import '../../shared/widgets/design/kayan_entry_widgets.dart';

/// تأكيد الإلغاء برمز OTP — light design
class CancelOtpScreen extends ConsumerWidget {
  const CancelOtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    final pinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w800),
      decoration: BoxDecoration(
        color: KayanDesignTokens.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KayanDesignTokens.border),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'تأكيد الإلغاء' : 'Confirm cancellation', onBack: () => context.pop()),
              const SizedBox(height: 20),
              Text(
                ar ? 'أدخل رمز التأكيد المرسل لجوالك' : 'Enter the confirmation code sent to your phone',
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 28),
              Pinput(
                length: 6,
                defaultPinTheme: pinTheme,
                focusedPinTheme: pinTheme.copyWith(
                  decoration: pinTheme.decoration!.copyWith(
                    border: Border.all(color: KayanDesignTokens.danger, width: 1.5),
                  ),
                ),
                onCompleted: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم إلغاء الحجز' : 'Booking cancelled')),
                  );
                  context.pop(true);
                },
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'إعادة إرسال الرمز' : 'Resend code',
                variant: KayanCtaVariant.blue,
                trailingIcon: Icons.refresh_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم إرسال رمز جديد' : 'New code sent')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
