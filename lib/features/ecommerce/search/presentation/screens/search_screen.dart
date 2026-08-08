import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../product/presentation/providers/product_providers.dart';

/// بحث المتجر — light design
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _ctrl;
  bool _hasQuery = false;

  final _recent = ['سماعات سوني', 'آيفون 15', 'تكييف سبليت', 'كامري 2022'];
  final _trending = ['سامسونج S24', 'بلايستيشن 5', 'شاشة 4K', 'AirPods Pro'];

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery ?? '');
    _hasQuery = _ctrl.text.isNotEmpty;
    if (_hasQuery) {
      ref.read(productFilterProvider.notifier).setSearch(_ctrl.text);
    }
    _ctrl.addListener(() => _onSearch(_ctrl.text));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    setState(() => _hasQuery = q.trim().isNotEmpty);
    ref.read(productFilterProvider.notifier).setSearch(q.trim().isEmpty ? null : q.trim());
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final products = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'بحث المتجر' : 'Shop search', onBack: () => context.pop()),
              const SizedBox(height: 12),
              KayanDesignTextField(
                label: ar ? 'ابحث عن منتج' : 'Search products',
                controller: _ctrl,
                hint: ar ? 'ابحث عن أي شيء...' : 'Search anything...',
                icon: Icons.search_rounded,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(onPressed: () => _onSearch(_ctrl.text), child: Text(ar ? 'بحث' : 'Search')),
                  const Spacer(),
                  TextButton(onPressed: () => context.push(AppRoutes.shopFilters), child: Text(ar ? 'فلاتر' : 'Filters')),
                ],
              ),
              Expanded(
                child: _hasQuery
                    ? products.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => Center(child: Text(ar ? 'تعذّر التحميل' : 'Load failed')),
                        data: (list) => list.isEmpty
                            ? Center(child: Text(ar ? 'لا توجد نتائج' : 'No results', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)))
                            : ListView(
                                children: [
                                  Text('${list.length} ${ar ? 'نتيجة' : 'results'}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                                  const SizedBox(height: 8),
                                  for (final p in list)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: GestureDetector(
                                        onTap: () => context.push(AppRoutes.productPath(p.slug)),
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM), border: Border.all(color: KayanDesignTokens.border)),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 42,
                                                height: 42,
                                                decoration: BoxDecoration(gradient: KayanDesignTokens.gradOrange, borderRadius: BorderRadius.circular(12)),
                                                child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(ar ? p.nameAr : p.nameEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                                    Text('${p.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      )
                    : ListView(
                        children: [
                          Text(ar ? 'عمليات البحث الأخيرة' : 'Recent searches', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _recent.map((r) => GestureDetector(
                              onTap: () {
                                _ctrl.text = r;
                                _onSearch(r);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: KayanDesignTokens.border)),
                                child: Text(r, style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                              ),
                            )).toList(),
                          ),
                          const SizedBox(height: 16),
                          Text(ar ? 'الأكثر بحثاً' : 'Trending', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.text2)),
                          const SizedBox(height: 8),
                          for (final t in _trending)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.trending_up_rounded, color: KayanDesignTokens.oOrange),
                              title: Text(t, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700)),
                              onTap: () {
                                _ctrl.text = t;
                                _onSearch(t);
                              },
                            ),
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
