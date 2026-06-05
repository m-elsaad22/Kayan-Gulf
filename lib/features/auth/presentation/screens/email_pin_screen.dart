// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';

class EmailPinScreen extends StatelessWidget {
  final String email;
  const EmailPinScreen({super.key, this.email = ''});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      appBar: AppBar(title: Text(isArabic ? 'تأكيد البريد' : 'Email Verification')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isArabic
                  ? 'أدخل رمز التحقق المرسل إلى $email'
                  : 'Enter the PIN sent to $email',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Pinput(
              length: 6,
              onCompleted: (_) => context.push(AppRoutes.resetPassword),
            ),
          ],
        ),
      ),
    );
  }
}
