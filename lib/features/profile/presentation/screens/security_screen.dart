// Security — light design (14b-security-2fa)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../widgets/kayan_profile_widgets.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'الأمان' : 'Security', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    KayanProfileMenuTile(icon: Icons.lock_outline_rounded, title: ar ? 'تغيير كلمة المرور' : 'Change password', onTap: () => context.push(AppRoutes.changePassword)),
                    KayanProfileMenuTile(icon: Icons.verified_user_outlined, title: ar ? 'التحقق الثنائي' : 'Two-factor auth', onTap: () => context.push(AppRoutes.twoFASetup)),
                    KayanProfileMenuTile(icon: Icons.devices_rounded, title: ar ? 'الأجهزة المتصلة' : 'Connected devices', onTap: () => context.push(AppRoutes.connectedDevices)),
                    KayanProfileMenuTile(icon: Icons.delete_outline_rounded, title: ar ? 'حذف الحساب' : 'Delete account', danger: true, onTap: () => context.push(AppRoutes.deleteAccount)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
