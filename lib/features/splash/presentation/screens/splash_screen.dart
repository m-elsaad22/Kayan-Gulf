// Splash — matches design/html/01-splash.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/app_status_service.dart';
import '../../../../routing/app_routes.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final minDelay = Future<void>.delayed(const Duration(milliseconds: 1600));
    final status = await AppStatusService.check(force: true);
    await minDelay;
    if (!mounted) return;

    if (status.isBlocked) {
      context.go(AppRoutes.maintenance);
      return;
    }
    _navigate();
  }

  void _navigate() {
    final authState = ref.read(authStateProvider);
    final hasLanguageRegion = LocalStorageService.hasSelectedLanguageRegion;
    final hasOnboarding = LocalStorageService.hasSeenOnboarding;
    final isGuest = LocalStorageService.isGuestMode;

    if (!hasLanguageRegion) {
      context.go(AppRoutes.languageRegion);
    } else if (!hasOnboarding) {
      context.go(AppRoutes.onboarding);
    } else if (authState.isAuthenticated || isGuest) {
      context.go(AppRoutes.dashboard);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KayanDesignTokens.kBlueDeep,
      body: KayanHeroBackdrop(
        minHeight: MediaQuery.sizeOf(context).height,
        child: const Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KayanBrandLogo(size: 150),
                  SizedBox(height: 22),
                  KayanWordmark(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: Center(child: KayanSplashProgress()),
            ),
          ],
        ),
      ),
    );
  }
}
