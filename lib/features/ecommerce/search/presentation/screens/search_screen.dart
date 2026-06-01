// KAYAN — Search Screen
// lib/features/ecommerce/search/presentation/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../home/data/models/home_models.dart';
import '../../../../ecommerce/product/presentation/providers/product_providers.dart';
import '../../../../../shared/widgets/cards/product_card.dart';
import '../../../../../shared/widgets/loaders/shimmer_loader.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _ctrl;
  final FocusNode _focus = FocusNode();
  bool _hasQuery = false;

  final _recent = ['سماعات سوني', 'آيفون 15', 'تكييف سبليت', 'كامري 2022', 'ماك بوك'];
  final _trending = ['سامسونج S24', 'بلايستيشن 5', 'شاشة 4K', 'AirPods Pro', 'Apple Watch'];

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery ?? '');
    _hasQuery = _ctrl.text.isNotEmpty;
    if (_hasQuery) {
      ref.read(productFilterProvider.notifier).setSearch(_ctrl.text);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() { _ctrl.dispose(); _focus.dispose(); super.dispose(); }

  void _onSearch(String q) {
    setState(() => _hasQuery = q.trim().isNotEmpty);
    ref.read(productFilterProvider.notifier).setSearch(q.trim().isEmpty ? null : q.trim());
  }

  void _setQuery(String q) {
    _ctrl.text = q;
    _ctrl.selection = TextSelection.collapsed(offset: q.length);
    _onSearch(q);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final products = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor:        AppColors.bgSurface,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            GestureDetector(
              onTap: () { HapticFeedback.lightImpact(); context.pop(); },
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container(
              height: 40,
              decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: AppBorderRadius.pill, border: Border.all(color: AppColors.borderActive, width: 1.5)),
              child: Row(children: [
                const SizedBox(width: 12),
                const Icon(Icons.search_rounded, size: 18, color: AppColors.royalBlue),
                const SizedBox(width: 8),
                Expanded(child: TextField(
                  controller:   _ctrl,
                  focusNode:    _focus,
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style:        isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
                  decoration:   InputDecoration(
                    hintText:  isArabic ? 'ابحث عن أي شيء...' : 'Search anything...',
                    hintStyle: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textMuted),
                    border: InputBorder.none, contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged:   _onSearch,
                  onSubmitted: _onSearch,
                  textInputAction: TextInputAction.search,
                )),
                if (_hasQuery)
                  GestureDetector(
                    onTap: () => _setQuery(''),
                    child: Padding(padding: const EdgeInsets.only(right: 10), child: Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted)),
                  ),
              ]),
            )),
          ]),
        ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.borderSubtle)),
      ),
      body: _hasQuery ? _ResultsView(products: products, isArabic: isArabic) : _SuggestionsView(
        recent:   _recent, trending: _trending, isArabic: isArabic,
        onSelect: _setQuery,
        onClearRecent: () => setState(() {}),
      ),
    );
  }
}

class _SuggestionsView extends StatelessWidget {
  final List<String> recent, trending;
  final bool         isArabic;
  final ValueChanged<String> onSelect;
  final VoidCallback onClearRecent;
  const _SuggestionsView({required this.recent, required this.trending, required this.isArabic, required this.onSelect, required this.onClearRecent});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(AppSpacing.pagePadding), children: [
    // Recent
    Row(children: [
      const Icon(Icons.history_rounded, size: 16, color: AppColors.textMuted),
      const SizedBox(width: 8),
      Text(isArabic ? 'عمليات البحث الأخيرة' : 'Recent Searches',
          style: isArabic ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
      const Spacer(),
      GestureDetector(onTap: onClearRecent, child: Text(isArabic ? 'مسح الكل' : 'Clear All', style: AppTextStyles.seeAll)),
    ]),
    const SizedBox(height: 12),
    Wrap(spacing: 8, runSpacing: 8, children: recent.map((r) => GestureDetector(
      onTap: () => onSelect(r),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.pill, border: Border.all(color: AppColors.borderSubtle)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.history_rounded, size: 12, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(r, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
        ])),
    )).toList()),
    const SizedBox(height: 24),
    // Trending
    Row(children: [
      const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.metallicGold),
      const SizedBox(width: 8),
      Text(isArabic ? 'الأكثر بحثاً' : 'Trending Now',
          style: isArabic ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
    ]),
    const SizedBox(height: 12),
    ...trending.asMap().entries.map((e) => GestureDetector(
      onTap: () => onSelect(e.value),
      child: Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.metallicGold.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(child: Text('${e.key + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              color: e.key < 3 ? AppColors.metallicGold : AppColors.textMuted)))),
        const SizedBox(width: 12),
        Expanded(child: Text(e.value, style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium)),
        const Icon(Icons.north_west_rounded, size: 14, color: AppColors.textMuted),
      ])),
    )),
  ]);
}

class _ResultsView extends StatelessWidget {
  final AsyncValue<List<ProductCardModel>> products;
  final bool isArabic;
  const _ResultsView({required this.products, required this.isArabic});

  @override
  Widget build(BuildContext context) => products.when(
    loading: () => GridView.count(crossAxisCount: 2, shrinkWrap: true, padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.65,
        children: List.generate(6, (_) => const ProductCardShimmer())),
    error: (_, __) => Center(child: Text(isArabic ? 'حدث خطأ' : 'Error loading')),
    data: (list) => list.isEmpty
        ? Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(isArabic ? 'لا توجد نتائج' : 'No results found', style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
          ])))
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), child: Text(
              isArabic ? '${list.length} نتيجة' : '${list.length} results',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary))),
            Expanded(child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.65),
              itemCount: list.length,
              itemBuilder: (_, i) => ProductCard(product: list[i], onTap: () => context.push(AppRoutes.productPath(list[i].slug))),
            )),
          ]),
  );
}
