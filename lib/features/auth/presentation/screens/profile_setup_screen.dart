import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إعداد الملف الشخصي — light design
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _firstCtrl.addListener(() => setState(() {}));
    _lastCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  bool get _isValid => _firstCtrl.text.trim().length >= 2 && _lastCtrl.text.trim().length >= 2;

  Future<void> _complete() async {
    if (!_isValid) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    ref.read(authStateProvider.notifier).markProfileComplete();
    if (mounted) context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'إعداد الحساب' : 'Profile setup'),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: KayanDesignTokens.surface,
                        border: Border.all(color: KayanDesignTokens.border, width: 2),
                      ),
                      child: Icon(Icons.person_rounded, size: 48, color: KayanDesignTokens.muted),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: KayanDesignTokens.gradGold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ar ? 'أكمل بياناتك للبدء' : 'Complete your details to get started',
                textAlign: TextAlign.center,
                style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 24),
              KayanDesignTextField(
                label: ar ? 'الاسم الأول' : 'First name',
                controller: _firstCtrl,
                hint: ar ? 'محمد' : 'Mohammed',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 14),
              KayanDesignTextField(
                label: ar ? 'اسم العائلة' : 'Last name',
                controller: _lastCtrl,
                hint: ar ? 'الغامدي' : 'Al-Ghamdi',
                icon: Icons.badge_outlined,
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'ابدأ الاستخدام' : 'Get started',
                loading: _loading,
                variant: KayanCtaVariant.gold,
                trailingIcon: Icons.arrow_back_ios_new_rounded,
                onPressed: _isValid && !_loading ? _complete : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
