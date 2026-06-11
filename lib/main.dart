// ============================================================
// KAYAN Super App — Entry Point
// ============================================================
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/di/providers.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/kayan_motion.dart';
import 'core/services/admin_data_service.dart';
import 'features/super_admin/services/design_engine_service.dart';
import 'shared/services/local_storage_service.dart';
import 'shared/services/notification_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    KayanMotion.prepareHighRefreshPipeline();

    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiDark);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await Hive.initFlutter();
    await LocalStorageService.initialize();
    await AdminDataService.instance.initialize();
    await DesignEngineService.instance.initialize();
    await NotificationService.initialize();

    runApp(
      ProviderScope(
        overrides: AppDI.overrides,
        observers: [if (kDebugMode) _RiverpodLogger()],
        child: const KayanApp(),
      ),
    );
  }, (error, stack) {
    if (kDebugMode) debugPrint('❌ $error');
  });
}

class _RiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<dynamic> provider, Object? prev,
      Object? next, ProviderContainer container) {
    if (kDebugMode) {
      debugPrint('[Riverpod] ${provider.name ?? provider.runtimeType}');
    }
  }
}
