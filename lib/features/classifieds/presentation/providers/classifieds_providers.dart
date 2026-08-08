import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/repository_providers.dart';
import '../../browse/data/models/ad_models.dart';
import '../../domain/ad_filter.dart';

export '../../domain/ad_filter.dart';

final adCategoriesProvider =
    FutureProvider.autoDispose<List<AdCategory>>((ref) async {
  final repo = ref.watch(classifiedsRepositoryProvider);
  return repo.getCategories();
});

final adFilterProvider = StateProvider<AdFilter>((_) => const AdFilter());

final adsListProvider =
    FutureProvider.autoDispose.family<List<AdModel>, AdFilter>((ref, filter) async {
  final repo = ref.watch(classifiedsRepositoryProvider);
  return repo.getAds(filter);
});

final adDetailProvider = FutureProvider.autoDispose.family<AdModel, String>(
  (ref, slug) async {
    final repo = ref.watch(classifiedsRepositoryProvider);
    return repo.getAdDetail(slug);
  },
);

final myAdsProvider = FutureProvider.autoDispose<List<MyAdModel>>((ref) async {
  final repo = ref.watch(classifiedsRepositoryProvider);
  return repo.getMyAds();
});

final featuredAdsProvider = FutureProvider.autoDispose<List<AdModel>>((ref) async {
  final repo = ref.watch(classifiedsRepositoryProvider);
  return repo.getFeaturedAds();
});
