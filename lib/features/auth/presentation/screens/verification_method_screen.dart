// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';

class VerificationMethodScreen extends StatelessWidget {
  const VerificationMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      appBar: AppBar(title: Text(isArabic ? 'طريقة التحقق' : 'Verification Method')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(isArabic ? 'البريد الإلكتروني' : 'Email'),
            onTap: () => context.push(AppRoutes.emailPin),
          ),
          ListTile(
            leading: const Icon(Icons.phone_iphone_rounded),
            title: Text(isArabic ? 'رقم الجوال' : 'Phone'),
            onTap: () => context.push(AppRoutes.phoneInput),
          ),
        ],
      ),
    );
  }
}
