// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';
import '../../data/models/ad_models.dart';

class SearchAdsScreen extends ConsumerStatefulWidget {
  const SearchAdsScreen({super.key});

  @override
  ConsumerState<SearchAdsScreen> createState() => _SearchAdsScreenState();
}

class _SearchAdsScreenState extends ConsumerState<SearchAdsScreen> {
  final _queryCtrl = TextEditingController();

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final q = _queryCtrl.text.trim().toLowerCase();
    final results = mockAds.where((a) {
      if (q.isEmpty) return true;
      return a.title.toLowerCase().contains(q) ||
          a.city.toLowerCase().contains(q);
    }).toList();

    return Phase5ClassifiedsScaffold(
      titleAr: 'بحث الإعلانات',
      titleEn: 'Search Ads',
      subtitleAr: 'ابحث بالعنوان أو المدينة أو الفئة.',
      subtitleEn: 'Search by title, city, or category.',
      children: [
        TextField(
          controller: _queryCtrl,
          textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: ar ? 'ابحث...' : 'Search...',
            prefixIcon: const Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 16),
        ...results.map(
          (ad) => Phase5ClassifiedsCard(
            icon: Icons.campaign_outlined,
            titleAr: ad.title,
            titleEn: ad.title,
            bodyAr: '${ad.city} • ${ad.timeAgo(true)}',
            bodyEn: '${ad.city} • ${ad.timeAgo(false)}',
            onTap: () => context.push(AppRoutes.adPath(ad.slug)),
          ),
        ),
      ],
    );
  }
}
