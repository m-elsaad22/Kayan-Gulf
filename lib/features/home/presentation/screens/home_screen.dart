// ============================================================
// KAYAN Super App — Home Screen
// lib/features/home/presentation/screens/home_screen.dart
//
// Layout (top → bottom):
//   1.  Custom AppBar (greeting + search + cart + notification)
//   2.  Hero Banner Slider (auto-slide, 3 banners)
//   3.  E-commerce Categories (horizontal scroll, 8 icons)
//   4.  Flash Deals section (with countdown timers)
//   5.  Emergency Services strip (red, always visible)
//   6.  Service Categories (horizontal scroll)
//   7.  Featured Products (horizontal scroll)
//   8.  Recent Classifieds Ads (horizontal scroll)
//   9.  "For You" Recommendations (horizontal scroll)
//   10. Bottom padding for nav bar
//
// State: Riverpod FutureProvider with loading skeleton
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../providers/home_providers.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scroll = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final scrolled = _scroll.offset > 10;
      if (scrolled != _isScrolled) {
        setState(() => _isScrolled = scrolled);
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    ref.invalidate(homeDataProvider);
    await ref.read(homeDataProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic  = ref.watch(isArabicProvider);
    final authState = ref.watch(authStateProvider);
    final homeAsync = ref.watch(homeDataProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      extendBodyBehindAppBar: true,

      // ── Custom App Bar ─────────────────────────────────────
      appBar: _HomeAppBar(
        isScrolled: _isScrolled,
        isArabic:   isArabic,
        userName:   authState.userId != null ? 'محمود' : null, // TODO: real name
        onSearch:   () => context.push(AppRoutes.search),
        onCart:     () => context.push(AppRoutes.cart),
        onNotif:    () => context.push(AppRoutes.notifications),
      ),

      body: homeAsync.when(
        // ── Loading state ──────────────────────────────────
        loading: () => const _HomeLoadingSkeleton(),

        // ── Error state ─────────────────────────────────────
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 56, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text(
                isArabic ? 'حدث خطأ في التحميل' : 'Failed to load',
                style: isArabic
                    ? AppTextStyles.arabicTitleSmall
                    : AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(homeDataProvider),
                icon:  const Icon(Icons.refresh_rounded),
                label: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
              ),
            ],
          ),
        ),

        // ── Data state ──────────────────────────────────────
        data: (home) => RefreshIndicator(
          onRefresh:   _onRefresh,
          color:       AppColors.royalBlue,
          strokeWidth: 2,
          child: CustomScrollView(
            controller: _scroll,
            physics:    const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Top padding for AppBar
              const SliverToBoxAdapter(
                child: SizedBox(height: kToolbarHeight + 60),
              ),

              // ── 1. Hero Banners ─────────────────────────
              SliverToBoxAdapter(
                child: HeroBannerSlider(
                  banners:  home.banners,
                  isArabic: isArabic,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── 2. E-commerce Categories ───────────────
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SectionHeader(
                      titleAr:     'تسوق حسب الفئة',
                      titleEn:     'Shop by Category',
                      seeAllRoute: AppRoutes.categories,
                      isArabic:    isArabic,
                    ),
                    const SizedBox(height: 12),
                    CategoryGrid(
                      categories:  home.ecommerceCategories,
                      isArabic:    isArabic,
                      routePrefix: '/shop',
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── 3. Flash Deals ─────────────────────────
              if (home.flashDeals.isNotEmpty)
                SliverToBoxAdapter(
                  child: FlashDealSection(
                    products: home.flashDeals,
                    isArabic: isArabic,
                  ),
                ),

              if (home.flashDeals.isNotEmpty)
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── 4. Emergency Strip ─────────────────────
              SliverToBoxAdapter(
                child: EmergencyStrip(isArabic: isArabic),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── 5. Service Categories ──────────────────
              if (home.serviceCategories.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SectionHeader(
                        titleAr:     'خدمات منزلية',
                        titleEn:     'Home Services',
                        seeAllRoute: AppRoutes.services,
                        isArabic:    isArabic,
                      ),
                      const SizedBox(height: 12),
                      CategoryGrid(
                        categories:  home.serviceCategories,
                        isArabic:    isArabic,
                        routePrefix: '/services',
                      ),
                    ],
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── 6. Featured Services ───────────────────
              if (home.featuredServices.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SectionHeader(
                        titleAr:     'خدمات مميزة',
                        titleEn:     'Featured Services',
                        seeAllRoute: '${AppRoutes.services}/browse',
                        isArabic:    isArabic,
                      ),
                      const SizedBox(height: 12),
                      FeaturedServicesRow(
                        services: home.featuredServices,
                        isArabic: isArabic,
                      ),
                    ],
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── 7. Featured Products ───────────────────
              if (home.featuredProducts.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SectionHeader(
                        titleAr:     'منتجات مميزة',
                        titleEn:     'Featured Products',
                        seeAllRoute: AppRoutes.shop,
                        isArabic:    isArabic,
                      ),
                      const SizedBox(height: 12),
                      HorizontalProductsRow(
                        products: home.featuredProducts,
                        isArabic: isArabic,
                      ),
                    ],
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── 8. Recent Ads ──────────────────────────
              if (home.recentAds.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SectionHeader(
                        titleAr:     'إعلانات قريبة منك',
                        titleEn:     'Nearby Classifieds',
                        seeAllRoute: AppRoutes.classifieds,
                        isArabic:    isArabic,
                      ),
                      const SizedBox(height: 12),
                      RecentAdsRow(
                        ads:      home.recentAds,
                        isArabic: isArabic,
                      ),
                    ],
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── 9. Recommendations ─────────────────────
              if (home.recommendations.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SectionHeader(
                        titleAr:  'مقترح لك',
                        titleEn:  'Recommended For You',
                        isArabic: isArabic,
                      ),
                      const SizedBox(height: 12),
                      HorizontalProductsRow(
                        products: home.recommendations,
                        isArabic: isArabic,
                      ),
                    ],
                  ),
                ),

              // ── Bottom padding ─────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CUSTOM HOME APP BAR
// ──────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool       isScrolled;
  final bool       isArabic;
  final String?    userName;
  final VoidCallback onSearch;
  final VoidCallback onCart;
  final VoidCallback onNotif;

  const _HomeAppBar({
    required this.isScrolled,
    required this.isArabic,
    this.userName,
    required this.onSearch,
    required this.onCart,
    required this.onNotif,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 52);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        boxShadow: isScrolled ? [
          BoxShadow(
            color:      Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset:     const Offset(0, 4),
          ),
        ] : [],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Top row: greeting + actions ──────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding,
                vertical:   8,
              ),
              child: Row(
                children: [
                  // Greeting
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic
                              ? _greetingAr()
                              : _greetingEn(),
                          style: (isArabic
                                  ? AppTextStyles.arabicCaption
                                  : AppTextStyles.caption)
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        if (userName != null)
                          Text(
                            userName!,
                            style: isArabic
                                ? AppTextStyles.arabicTitleMedium
                                : AppTextStyles.titleMedium,
                          ),
                        // KAYAN logo if no user
                        if (userName == null)
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppGradients.goldShimmer.createShader(bounds),
                            child: Text(
                              'KAYAN',
                              style: AppTextStyles.titleLarge.copyWith(
                                letterSpacing: 4,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Notification bell
                  _AppBarIconButton(
                    icon:    Icons.notifications_outlined,
                    onTap:   onNotif,
                    badgeCount: 3, // TODO: real count
                  ),
                  const SizedBox(width: 8),

                  // Cart
                  _AppBarIconButton(
                    icon:    Icons.shopping_cart_outlined,
                    onTap:   onCart,
                    badgeCount: 2, // TODO: real count
                  ),
                ],
              ),
            ),

            // ── Search bar ───────────────────────────────
            GestureDetector(
              onTap: onSearch,
              child: Container(
                height: 42,
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                ).copyWith(bottom: 8),
                decoration: BoxDecoration(
                  color:        AppColors.bgInput,
                  borderRadius: AppBorderRadius.pill,
                  border:       Border.all(color: AppColors.borderDefault),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search_rounded,
                        color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isArabic
                            ? 'ابحث عن منتجات، خدمات، إعلانات...'
                            : 'Search products, services, ads...',
                        style: (isArabic
                                ? AppTextStyles.arabicBodyMedium
                                : AppTextStyles.bodyMedium)
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ),
                    // Mic icon
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.mic_none_rounded,
                        color: AppColors.textMuted, size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greetingAr() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير 🌅';
    if (hour < 17) return 'مساء الخير ☀️';
    return 'مساء النور 🌙';
  }

  String _greetingEn() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 🌅';
    if (hour < 17) return 'Good afternoon ☀️';
    return 'Good evening 🌙';
  }
}

// ──────────────────────────────────────────────────────────────
// APP BAR ICON BUTTON WITH BADGE
// ──────────────────────────────────────────────────────────────

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int?     badgeCount;

  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color:        AppColors.bgCard.withOpacity(0.6),
              borderRadius: AppBorderRadius.sm,
              border:       Border.all(color: AppColors.borderSubtle),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          if (badgeCount != null && badgeCount! > 0)
            Positioned(
              top:   -4, right: -4,
              child: Container(
                width:  16, height: 16,
                decoration: const BoxDecoration(
                  color:  AppColors.error,
                  shape:  BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize:   9,
                      fontWeight: FontWeight.w700,
                      color:      Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// HOME LOADING SKELETON
// ──────────────────────────────────────────────────────────────

class _HomeLoadingSkeleton extends StatelessWidget {
  const _HomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: kToolbarHeight + 60),

        // Banner skeleton
        const BannerShimmer(),
        const SizedBox(height: 24),

        // Categories skeleton
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:   SectionHeaderShimmer(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 7,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(right: 12),
              child:   CategoryShimmer(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Products row skeleton
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:   SectionHeaderShimmer(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(right: 12),
              child:   SizedBox(
                width: 158,
                child: ProductCardShimmer(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Second products row
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:   SectionHeaderShimmer(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(right: 12),
              child:   SizedBox(
                width: 158,
                child: ProductCardShimmer(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
