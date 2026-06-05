// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routing/app_routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      appBar: AppBar(title: Text(isArabic ? 'استعادة كلمة المرور' : 'Forgot Password')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Text(
            isArabic
                ? 'أدخل بريدك الإلكتروني لإرسال رمز التحقق'
                : 'Enter your email to receive a verification PIN',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: isArabic ? 'البريد الإلكتروني' : 'Email'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.emailPin, extra: _emailCtrl.text.trim()),
            child: Text(isArabic ? 'إرسال الرمز' : 'Send PIN'),
          ),
        ],
      ),
    );
  }
}
