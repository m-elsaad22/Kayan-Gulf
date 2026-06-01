// ============================================================
// KAYAN — Profile Screen
// lib/features/profile/presentation/screens/profile_screen.dart
//
// Sections:
//   • Header: Avatar + Name + Phone + Stats (orders, reviews, wallet)
//   • Quick Stats: Gold card with totals
//   • Menu Groups:
//       - Account: Edit Profile, Addresses, Favorites
//       - Orders & Finance: My Orders, Wallet, Loyalty Points
//       - Settings: Language, Theme, Notifications, Privacy, About
//   • Logout
//   • App version footer
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/locale_provider.dart';

// ──────────────────────────────────────────────────────────────
// PROFILE DATA (mock — replace with real provider)
// ──────────────────────────────────────────────────────────────

class _ProfileData {
  final String firstName;
  final String lastName;
  final String phone;
  final String? avatarUrl;
  final int    totalOrders;
  final int    totalReviews;
  final double walletBalance;
  final int    loyaltyPoints;
  final String tier; // Bronze, Silver, Gold, Platinum
  final DateTime memberSince;

  const _ProfileData({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.avatarUrl,
    this.totalOrders     = 0,
    this.totalReviews    = 0,
    this.walletBalance   = 0,
    this.loyaltyPoints   = 0,
    this.tier            = 'Silver',
    required this.memberSince,
  });

  String get fullName => '$firstName $lastName';
}

final _mockProfile = _ProfileData(
  firstName:     'محمود',
  lastName:      'السعد',
  phone:         '+966 50 123 4567',
  totalOrders:   24,
  totalReviews:  12,
  walletBalance: 250,
  loyaltyPoints: 1840,
  tier:          'Gold',
  memberSince:   DateTime(2023, 6, 1),
);

// ──────────────────────────────────────────────────────────────
// SCREEN
// ──────────────────────────────────────────────────────────────

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);
    final profile  = _mockProfile;

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header SliverAppBar ─────────────────────────
          _ProfileSliverHeader(
            profile:  profile,
            isArabic: isArabic,
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // ── Quick Stats ───────────────────────────
                _StatsCard(profile: profile, isArabic: isArabic),

                const SizedBox(height: 20),

                // ── Wallet + Loyalty ──────────────────────
                _WalletLoyaltyCard(profile: profile, isArabic: isArabic),

                const SizedBox(height: 20),

                // ── Account Group ─────────────────────────
                _MenuGroup(
                  titleAr: 'الحساب',
                  titleEn: 'Account',
                  isArabic: isArabic,
                  items: [
                    _MenuItem(
                      icon:    Icons.person_outline_rounded,
                      labelAr: 'تعديل الملف الشخصي',
                      labelEn: 'Edit Profile',
                      color:   AppColors.royalBlue,
                      onTap:   () => context.push(AppRoutes.editProfile),
                    ),
                    _MenuItem(
                      icon:    Icons.location_on_outlined,
                      labelAr: 'عناويني',
                      labelEn: 'My Addresses',
                      color:   AppColors.categoryGreen,
                      badge:   '${2}',
                      onTap:   () => context.push(AppRoutes.addresses),
                    ),
                    _MenuItem(
                      icon:    Icons.favorite_outline_rounded,
                      labelAr: 'المفضلة',
                      labelEn: 'Favorites',
                      color:   AppColors.error,
                      badge:   '${7}',
                      onTap:   () => context.push(AppRoutes.favorites),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Orders & Finance Group ─────────────────
                _MenuGroup(
                  titleAr: 'الطلبات والمالية',
                  titleEn: 'Orders & Finance',
                  isArabic: isArabic,
                  items: [
                    _MenuItem(
                      icon:    Icons.receipt_long_rounded,
                      labelAr: 'طلباتي',
                      labelEn: 'My Orders',
                      color:   AppColors.categoryOrange,
                      badge:   '${profile.totalOrders}',
                      onTap:   () => context.push(AppRoutes.orders),
                    ),
                    _MenuItem(
                      icon:    Icons.account_balance_wallet_outlined,
                      labelAr: 'محفظة كيان',
                      labelEn: 'KAYAN Wallet',
                      color:   AppColors.metallicGold,
                      sublabelAr: '${profile.walletBalance.toInt()} ر.س',
                      sublabelEn: '${profile.walletBalance.toInt()} SAR',
                      onTap:   () => context.push(AppRoutes.wallet),
                    ),
                    _MenuItem(
                      icon:    Icons.stars_rounded,
                      labelAr: 'نقاط الولاء',
                      labelEn: 'Loyalty Points',
                      color:   AppColors.categoryPurple,
                      sublabelAr: '${profile.loyaltyPoints} نقطة',
                      sublabelEn: '${profile.loyaltyPoints} pts',
                      onTap:   () => context.push(AppRoutes.loyalty),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Settings Group ────────────────────────
                _MenuGroup(
                  titleAr: 'الإعدادات',
                  titleEn: 'Settings',
                  isArabic: isArabic,
                  items: [
                    _MenuItem(
                      icon:    Icons.language_rounded,
                      labelAr: 'اللغة',
                      labelEn: 'Language',
                      color:   AppColors.categoryTeal,
                      sublabelAr: 'العربية',
                      sublabelEn: isArabic ? 'العربية' : 'Arabic',
                      onTap:   () => context.push(AppRoutes.settingsLanguage),
                    ),
                    _MenuItem(
                      icon:    Icons.dark_mode_outlined,
                      labelAr: 'المظهر',
                      labelEn: 'Theme',
                      color:   AppColors.categoryIndigo,
                      sublabelAr: 'وضع داكن',
                      sublabelEn: 'Dark Mode',
                      onTap:   () => context.push(AppRoutes.settingsTheme),
                    ),
                    _MenuItem(
                      icon:    Icons.notifications_outlined,
                      labelAr: 'الإشعارات',
                      labelEn: 'Notifications',
                      color:   AppColors.categoryYellow,
                      onTap:   () => context.push(AppRoutes.notifications),
                    ),
                    _MenuItem(
                      icon:    Icons.security_outlined,
                      labelAr: 'الأمان والخصوصية',
                      labelEn: 'Security & Privacy',
                      color:   AppColors.categoryGreen,
                      onTap:   () => context.push(AppRoutes.privacyPolicy),
                    ),
                    _MenuItem(
                      icon:    Icons.info_outline_rounded,
                      labelAr: 'عن كيان',
                      labelEn: 'About KAYAN',
                      color:   AppColors.royalBlue,
                      onTap:   () => context.push(AppRoutes.aboutApp),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Logout ────────────────────────────────
                _LogoutButton(isArabic: isArabic),

                const SizedBox(height: 16),

                // ── Version ───────────────────────────────
                _VersionFooter(isArabic: isArabic),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PROFILE SLIVER HEADER
// ──────────────────────────────────────────────────────────────
class _ProfileSliverHeader extends StatelessWidget {
  final _ProfileData profile;
  final bool         isArabic;
  const _ProfileSliverHeader({
    required this.profile,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned:         true,
      backgroundColor: AppColors.bgScaffold,
      elevation:       0,
      scrolledUnderElevation: 0,

      // App bar actions
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded, size: 20),
          onPressed: () => HapticFeedback.lightImpact(),
        ),
      ],
      title: Text(
        isArabic ? 'حسابي' : 'Profile',
        style: isArabic
            ? AppTextStyles.arabicTitleMedium
            : AppTextStyles.titleMedium,
      ),

      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background:   Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.hero,
              ),
            ),

            // Decorative gold ring top-right
            Positioned(
              top: -60, right: -60,
              child: Container(
                width:  200, height: 200,
                decoration: BoxDecoration(
                  shape:  BoxShape.circle,
                  border: Border.all(
                    color: AppColors.metallicGold.withOpacity(0.08),
                    width: 40,
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              width:  80, height: 80,
                              decoration: BoxDecoration(
                                shape:    BoxShape.circle,
                                gradient: AppGradients.primaryButton,
                                border:   Border.all(
                                  color: AppColors.metallicGold,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:      AppColors.metallicGold
                                        .withOpacity(0.3),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  profile.firstName.isNotEmpty
                                      ? profile.firstName[0]
                                      : '?',
                                  style: AppTextStyles.displaySmall.copyWith(
                                    fontSize: 32,
                                    color:    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            // Camera edit badge
                            Positioned(
                              bottom: 0, right: 0,
                              child: GestureDetector(
                                onTap: () => HapticFeedback.lightImpact(),
                                child: Container(
                                  width:  26, height: 26,
                                  decoration: BoxDecoration(
                                    gradient:  AppGradients.goldButton,
                                    shape:     BoxShape.circle,
                                    border:    Border.all(
                                      color: AppColors.bgScaffold, width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 13, color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // Name + tier + phone
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name + tier badge
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      profile.fullName,
                                      style: isArabic
                                          ? AppTextStyles.arabicTitleLarge
                                          : AppTextStyles.titleLarge,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _TierBadge(tier: profile.tier),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.phone,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color:        AppColors.textSecondary,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic
                                    ? 'عضو منذ ${_arabicDate(profile.memberSince)}'
                                    : 'Member since ${_engDate(profile.memberSince)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  String _arabicDate(DateTime dt) {
    final months = ['يناير','فبراير','مارس','أبريل','مايو','يونيو',
        'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];
    return '${months[dt.month - 1]} ${dt.year}';
  }

  String _engDate(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} ${dt.year}';
  }
}

// ──────────────────────────────────────────────────────────────
// TIER BADGE
// ──────────────────────────────────────────────────────────────
class _TierBadge extends StatelessWidget {
  final String tier;
  const _TierBadge({required this.tier});

  Color get _color => switch (tier) {
    'Bronze'   => const Color(0xFFCD7F32),
    'Silver'   => AppColors.silverMetallic,
    'Gold'     => AppColors.metallicGold,
    'Platinum' => const Color(0xFFE5E4E2),
    _          => AppColors.royalBlue,
  };

  String get _emoji => switch (tier) {
    'Bronze'   => '🥉',
    'Silver'   => '🥈',
    'Gold'     => '🥇',
    'Platinum' => '💎',
    _          => '⭐',
  };

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color:        _color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(8),
      border:       Border.all(color: _color.withOpacity(0.4)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_emoji, style: const TextStyle(fontSize: 10)),
        const SizedBox(width: 3),
        Text(tier,
            style: AppTextStyles.badge.copyWith(
              color:      _color,
              fontSize:   9,
              fontWeight: FontWeight.w700,
            )),
      ],
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// QUICK STATS CARD
// ──────────────────────────────────────────────────────────────
class _StatsCard extends StatelessWidget {
  final _ProfileData profile;
  final bool         isArabic;
  const _StatsCard({required this.profile, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient:     AppGradients.card,
          borderRadius: AppBorderRadius.card,
          border:       Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            _StatItem(
              value:    '${profile.totalOrders}',
              labelAr:  'طلب',
              labelEn:  'Orders',
              icon:     Icons.shopping_bag_outlined,
              color:    AppColors.royalBlue,
              isArabic: isArabic,
              onTap:    () => context.push(AppRoutes.orders),
            ),
            _Divider(),
            _StatItem(
              value:    '${profile.totalReviews}',
              labelAr:  'تقييم',
              labelEn:  'Reviews',
              icon:     Icons.star_outline_rounded,
              color:    AppColors.metallicGold,
              isArabic: isArabic,
            ),
            _Divider(),
            _StatItem(
              value:    '${profile.loyaltyPoints}',
              labelAr:  'نقطة',
              labelEn:  'Points',
              icon:     Icons.stars_rounded,
              color:    AppColors.categoryPurple,
              isArabic: isArabic,
              onTap:    () => context.push(AppRoutes.loyalty),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String   value;
  final String   labelAr;
  final String   labelEn;
  final IconData icon;
  final Color    color;
  final bool     isArabic;
  final VoidCallback? onTap;

  const _StatItem({
    required this.value,
    required this.labelAr,
    required this.labelEn,
    required this.icon,
    required this.color,
    required this.isArabic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width:  42, height: 42,
            decoration: BoxDecoration(
              color:        color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize:  22,
                color:     color,
              )),
          Text(
            isArabic ? labelAr : labelEn,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    ),
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width:  1, height: 50,
    color:  AppColors.borderSubtle,
  );
}

// ──────────────────────────────────────────────────────────────
// WALLET + LOYALTY CARD
// ──────────────────────────────────────────────────────────────
class _WalletLoyaltyCard extends StatelessWidget {
  final _ProfileData profile;
  final bool         isArabic;
  const _WalletLoyaltyCard({required this.profile, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.wallet),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient:     AppGradients.goldPremium,
            borderRadius: AppBorderRadius.card,
            boxShadow: [
              BoxShadow(
                color:      AppColors.metallicGold.withOpacity(0.2),
                blurRadius: 20,
                offset:     const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Wallet icon
              Container(
                width:  50, height: 50,
                decoration: BoxDecoration(
                  color:        AppColors.bgPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color:  AppColors.bgPrimary,
                  size:   26,
                ),
              ),
              const SizedBox(width: 14),

              // Balance info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'محفظة كيان' : 'KAYAN Wallet',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.bgPrimary.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '${profile.walletBalance.toInt()} ${isArabic ? 'ر.س' : 'SAR'}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.bgPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              // Loyalty
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isArabic ? 'نقاط الولاء' : 'Loyalty',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.bgPrimary.withOpacity(0.7),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${profile.loyaltyPoints}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.bgPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.stars_rounded,
                          size: 16, color: AppColors.bgPrimary),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// MENU GROUP + ITEM
// ──────────────────────────────────────────────────────────────

class _MenuGroupItem {
  final IconData icon;
  final String   labelAr;
  final String   labelEn;
  final Color    color;
  final String?  badge;
  final String?  sublabelAr;
  final String?  sublabelEn;
  final VoidCallback? onTap;

  const _MenuGroupItem({
    required this.icon,
    required this.labelAr,
    required this.labelEn,
    required this.color,
    this.badge,
    this.sublabelAr,
    this.sublabelEn,
    this.onTap,
  });
}

// Helper to create _MenuGroupItem easily
_MenuGroupItem _MenuItem({
  required IconData icon,
  required String labelAr,
  required String labelEn,
  required Color color,
  String? badge,
  String? sublabelAr,
  String? sublabelEn,
  VoidCallback? onTap,
}) => _MenuGroupItem(
  icon: icon, labelAr: labelAr, labelEn: labelEn,
  color: color, badge: badge,
  sublabelAr: sublabelAr, sublabelEn: sublabelEn,
  onTap: onTap,
);

class _MenuGroup extends StatelessWidget {
  final String               titleAr;
  final String               titleEn;
  final bool                 isArabic;
  final List<_MenuGroupItem> items;

  const _MenuGroup({
    required this.titleAr,
    required this.titleEn,
    required this.isArabic,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group title
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 4, left: 4),
            child: Text(
              isArabic ? titleAr : titleEn,
              style: AppTextStyles.labelSmall.copyWith(
                color:         AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Cards
          Container(
            decoration: BoxDecoration(
              color:        AppColors.bgCard,
              borderRadius: AppBorderRadius.card,
              border:       Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                return _MenuTile(
                  item:      item,
                  isArabic:  isArabic,
                  isLast:    i == items.length - 1,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _MenuGroupItem item;
  final bool           isArabic;
  final bool           isLast;
  const _MenuTile({
    required this.item,
    required this.isArabic,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            item.onTap?.call();
          },
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(16))
              : BorderRadius.zero,
          splashColor: item.color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical:   13,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width:  38, height: 38,
                  decoration: BoxDecoration(
                    color:        item.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, size: 18, color: item.color),
                ),
                const SizedBox(width: 12),

                // Labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? item.labelAr : item.labelEn,
                        style: isArabic
                            ? AppTextStyles.arabicBodyMedium
                            : AppTextStyles.bodyMedium,
                      ),
                      if (item.sublabelAr != null)
                        Text(
                          isArabic
                              ? item.sublabelAr!
                              : (item.sublabelEn ?? item.sublabelAr!),
                          style: AppTextStyles.caption.copyWith(
                            color: item.color,
                          ),
                        ),
                    ],
                  ),
                ),

                // Badge or arrow
                if (item.badge != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color:        item.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: AppTextStyles.badge.copyWith(
                        color: item.color,
                      ),
                    ),
                  ),
                Icon(
                  isArabic
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.arrow_forward_ios_rounded,
                  size:  13,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.only(left: 66),
            child:   Divider(height: 1, color: AppColors.borderSubtle),
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// LOGOUT BUTTON
// ──────────────────────────────────────────────────────────────
class _LogoutButton extends ConsumerWidget {
  final bool isArabic;
  const _LogoutButton({required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(isArabic ? 'تسجيل الخروج' : 'Sign Out'),
              content: Text(
                isArabic
                    ? 'هل أنت متأكد من تسجيل الخروج؟'
                    : 'Are you sure you want to sign out?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(authStateProvider.notifier).logout();
                    context.go(AppRoutes.phoneInput);
                  },
                  child: Text(
                    isArabic ? 'خروج' : 'Sign Out',
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color:        AppColors.errorBg,
            borderRadius: AppBorderRadius.button,
            border:       Border.all(color: AppColors.borderError),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded,
                  size: 18, color: AppColors.error),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'تسجيل الخروج' : 'Sign Out',
                style: (isArabic
                        ? AppTextStyles.arabicButton
                        : AppTextStyles.buttonMedium)
                    .copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// VERSION FOOTER
// ──────────────────────────────────────────────────────────────
class _VersionFooter extends StatelessWidget {
  final bool isArabic;
  const _VersionFooter({required this.isArabic});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ShaderMask(
        shaderCallback: (b) => AppGradients.goldShimmer.createShader(b),
        child: const Text(
          'KAYAN',
          style: TextStyle(
            fontFamily:   'Inter',
            fontSize:     18,
            fontWeight:   FontWeight.w800,
            letterSpacing: 6,
            color:         Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        'v1.0.0 • ${isArabic ? 'تسوق ملكي في الخليج' : 'Royal Shopping in the Gulf'}',
        style: AppTextStyles.caption.copyWith(color: AppColors.textDisabled),
      ),
    ],
  );
}
