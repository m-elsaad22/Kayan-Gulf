// ============================================================
// KAYAN — Home Screen Providers
// lib/features/home/presentation/providers/home_providers.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/repository_providers.dart';
import '../../data/models/home_models.dart';

final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getHomeData();
});
