// ============================================================
// KAYAN Super App — GoRouter Configuration
// lib/routing/app_router.dart
//
// Structure:
//   ┌─────────────────────────────────────────────────────┐
//   │  GoRouter (root)                                     │
//   │  ├─ /              → SplashScreen                   │
//   │  ├─ /onboarding    → OnboardingScreen               │
//   │  ├─ /auth/*        → Auth flow                      │
//   │  ├─ /cart          → CartScreen (root nav)          │
//   │  ├─ /checkout/*    → Checkout flow (root nav)       │
//   │  ├─ /orders/*      → Orders (root nav)              │
//   │  ├─ /chat/*        → Chat (root nav)                │
//   │  └─ StatefulShellRoute (Bottom Nav)                 │
//   │     ├─ Branch 0: /home         → HomeScreen         │
//   │     ├─ Branch 1: /shop/*       → E-commerce         │
//   │     ├─ Branch 2: /services/*   → Services           │
//   │     ├─ Branch 3: /classifieds/*→ Classifieds        │
//   │     └─ Branch 4: /profile/*    → Profile            │
//   └─────────────────────────────────────────────────────┘
//
// Auth Guard: redirect unauthenticated to /auth/phone
// Onboarding Guard: redirect first-launch to /onboarding
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'main_shell.dart';
import '../shared/providers/auth_provider.dart';
import '../shared/services/local_storage_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

// ─── Feature Screen Imports ───────────────────────────────────
// Splash & Onboarding
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/onboarding/presentation/screens/language_region_screen.dart';
// Auth
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/verification_method_screen.dart';
import '../features/auth/presentation/screens/email_pin_screen.dart';
import '../features/auth/presentation/screens/phone_input_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';
import '../features/auth/presentation/screens/profile_setup_screen.dart';
// Dashboard & Home
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
// E-commerce
import '../features/ecommerce/categories/presentation/screens/categories_screen.dart';
import '../features/ecommerce/product/presentation/screens/product_list_screen.dart';
import '../features/ecommerce/product/presentation/screens/product_detail_screen.dart';
import '../features/ecommerce/search/presentation/screens/search_screen.dart';
import '../features/ecommerce/flash_deals/presentation/screens/flash_deals_screen.dart';
import '../features/ecommerce/vendors/presentation/screens/vendor_profile_screen.dart';
import '../features/ecommerce/product/presentation/screens/product_reviews_screen.dart';
import '../features/ecommerce/product/presentation/screens/product_compare_screen.dart';
import '../features/ecommerce/product/presentation/screens/best_sellers_screen.dart';
import '../features/ecommerce/product/presentation/screens/exclusive_offers_screen.dart';
import '../features/checkout/presentation/screens/select_address_screen.dart';
import '../features/checkout/presentation/screens/add_address_screen.dart' as checkout_address;
import '../features/checkout/presentation/screens/payment_method_checkout_screen.dart';
import '../features/checkout/presentation/screens/add_card_checkout_screen.dart';
import '../features/checkout/presentation/screens/order_confirmation_screen.dart';
import '../features/checkout/presentation/screens/cod_details_screen.dart';
import '../features/checkout/presentation/screens/paypal_payment_screen.dart';
import '../features/checkout/presentation/screens/digital_wallet_screen.dart';
import '../features/returns/presentation/screens/return_select_product_screen.dart';
import '../features/returns/presentation/screens/return_details_screen.dart';
import '../features/returns/presentation/screens/return_status_screen.dart';

// Cart & Checkout
import '../features/cart/presentation/screens/cart_screen.dart';
import '../features/checkout/presentation/screens/checkout_screen.dart';
import '../features/checkout/presentation/screens/payment_screen.dart';
import '../features/checkout/presentation/screens/order_success_screen.dart';
// Orders
import '../features/orders/presentation/screens/orders_list_screen.dart';
import '../features/orders/presentation/screens/order_detail_screen.dart';
import '../features/orders/presentation/screens/order_tracking_screen.dart';
// Services
import '../features/services/categories/presentation/screens/services_home_screen.dart';
import '../features/services/browse/presentation/screens/services_list_screen.dart';
import '../features/services/browse/presentation/screens/service_detail_screen.dart';
import '../features/services/booking/presentation/screens/booking_calendar_screen.dart';
import '../features/services/booking/presentation/screens/booking_confirmation_screen.dart';
import '../features/services/booking/presentation/screens/booking_success_screen.dart';
import '../features/services/booking/presentation/screens/my_bookings_screen.dart';
import '../features/services/booking/presentation/screens/booking_detail_screen.dart';
import '../features/services/tracking/presentation/screens/live_tracking_screen.dart';
import '../features/services/browse/presentation/screens/advanced_filters_screen.dart';
import '../features/services/browse/presentation/screens/service_subcategories_screen.dart';
import '../features/services/booking/presentation/screens/address_entry_screen.dart';
import '../features/services/booking/presentation/screens/payment_method_screen.dart';
import '../features/services/booking/presentation/screens/add_card_screen.dart';
import '../features/services/booking/presentation/screens/payment_success_screen.dart';
import '../features/services/booking/presentation/screens/urgent_service_screen.dart';
import '../features/services/booking/presentation/screens/extra_materials_screen.dart';
import '../features/services/booking/presentation/screens/technician_arrival_screen.dart';
import '../features/services/booking/presentation/screens/service_completion_screen.dart';
import '../features/services/booking/presentation/screens/service_invoice_screen.dart';
import '../features/services/booking/presentation/screens/service_qr_screen.dart';

// Classifieds
import '../features/classifieds/browse/presentation/screens/ads_list_screen.dart';
import '../features/classifieds/browse/presentation/screens/classifieds_home_screen.dart';
import '../features/classifieds/ad_detail/presentation/screens/ad_detail_screen.dart';
import '../features/classifieds/post_ad/presentation/screens/post_ad_screen.dart';
import '../features/classifieds/post_ad/presentation/screens/boost_ad_screen.dart';
import '../features/classifieds/my_ads/presentation/screens/my_ads_screen.dart';
// Chat
import '../features/chat/presentation/screens/conversations_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
// Profile
import '../features/profile/presentation/screens/favorites_screen.dart' as fav_screen;
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/profile/presentation/screens/addresses_screen.dart';
import '../features/profile/presentation/screens/add_address_screen.dart';
import '../features/profile/presentation/screens/help_support_screen.dart';
import '../features/profile/presentation/screens/live_chat_screen.dart';
import '../features/profile/presentation/screens/rate_app_screen.dart';
import '../features/profile/presentation/screens/about_kayan_screen.dart';
import '../features/profile/presentation/screens/security_screen.dart';
import '../features/profile/presentation/screens/two_fa_setup_screen.dart';
import '../features/profile/presentation/screens/two_fa_verify_screen.dart';
import '../features/profile/presentation/screens/connected_devices_screen.dart';
import '../features/profile/presentation/screens/privacy_policy_screen.dart';
import '../features/profile/presentation/screens/terms_screen.dart';
import '../features/profile/presentation/screens/faq_general_screen.dart';
import '../features/profile/presentation/screens/contact_support_screen.dart';
import '../features/profile/presentation/screens/loyalty_cards_screen.dart';
import '../features/profile/presentation/screens/referrals_screen.dart';
import '../features/profile/presentation/screens/subscriptions_screen.dart';
import '../features/profile/presentation/screens/manage_subscription_screen.dart';
import '../features/wallet/presentation/screens/transfer_points_screen.dart';
import '../features/wallet/presentation/screens/earn_points_screen.dart';
import '../features/wallet/presentation/screens/redeem_points_screen.dart';
import '../features/wallet/presentation/screens/withdraw_earnings_screen.dart';
import '../features/wallet/presentation/screens/earnings_history_screen.dart';
import '../features/wallet/presentation/screens/payment_receipt_screen.dart';

// Notifications
import '../features/notifications/presentation/screens/notifications_screen.dart';
// Wallet
import '../features/wallet/presentation/screens/wallet_screen.dart';
// Settings
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/settings/presentation/screens/settings_detail_screens.dart';

// ──────────────────────────────────────────────────────────────
// NAVIGATOR KEYS
// Each tab and the root need their own GlobalKey<NavigatorState>
// so GoRouter can maintain separate back-stacks per tab.
// ──────────────────────────────────────────────────────────────

final _rootNavigatorKey        = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeTabKey              = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shopTabKey              = GlobalKey<NavigatorState>(debugLabel: 'shop');
final _servicesTabKey          = GlobalKey<NavigatorState>(debugLabel: 'services');
final _classifiedsTabKey       = GlobalKey<NavigatorState>(debugLabel: 'classifieds');
final _profileTabKey           = GlobalKey<NavigatorState>(debugLabel: 'profile');

// ──────────────────────────────────────────────────────────────
// ROUTER PROVIDER
// ──────────────────────────────────────────────────────────────

/// Riverpod provider that exposes the GoRouter singleton.
/// Re-evaluates redirect when authStateProvider changes.
final appRouterProvider = Provider<GoRouter>((ref) {
  // Watch auth state — router refreshes when auth changes
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey:      _rootNavigatorKey,
    initialLocation:   AppRoutes.splash,
    debugLogDiagnostics: true,

    // ── Global redirect guard ────────────────────────────
    // Called on every navigation event.
    redirect: (context, state) {
      final location          = state.uri.path;
      final isAuthenticated   = authState.isAuthenticated;
      final isProfileComplete = authState.isProfileComplete;
      final hasSelectedRegion = LocalStorageService.hasSelectedLanguageRegion;
      final hasSeenOnboarding = LocalStorageService.hasSeenOnboarding;
      final isGuestMode       = LocalStorageService.isGuestMode;

      // Always allow splash
      if (location == AppRoutes.splash) return null;

      if (!hasSelectedRegion && location != AppRoutes.languageRegion) {
        return AppRoutes.languageRegion;
      }
      if (hasSelectedRegion && location == AppRoutes.languageRegion) {
        return hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding;
      }

      // Onboarding guard (first launch)
      if (!hasSeenOnboarding && location != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      if (hasSeenOnboarding && location == AppRoutes.onboarding) {
        return (isAuthenticated || isGuestMode) ? AppRoutes.dashboard : AppRoutes.login;
      }

      // Public routes — always allow
      const publicPrefixes = ['/auth/', '/onboarding', '/language-region', '/404', '/no-internet'];
      final isPublic = publicPrefixes.any((p) => location.startsWith(p));
      if (isPublic) {
        // But if already authenticated, don't show login pages again
        if ((isAuthenticated || isGuestMode) && location.startsWith('/auth/')) {
          return AppRoutes.dashboard;
        }
        return null;
      }

      // Unauthenticated → send to login
      if (!isAuthenticated && !isGuestMode) return AppRoutes.login;

      // Authenticated but profile incomplete → profile setup
      if (isAuthenticated && !isGuestMode && !isProfileComplete &&
          location != AppRoutes.profileSetup) {
        return AppRoutes.profileSetup;
      }

      // All checks passed — allow
      return null;
    },

    // ── Error page ───────────────────────────────────────
    errorBuilder: (context, state) => _RouterErrorPage(
      error: state.error.toString(),
    ),

    // ────────────────────────────────────────────────────
    // ROUTES
    // ────────────────────────────────────────────────────
    routes: [

      // ════════════════════════════════════════════════════
      // SPLASH
      // ════════════════════════════════════════════════════
      GoRoute(
        path:        AppRoutes.splash,
        pageBuilder: (context, state) => _buildFadePage(
          key:   state.pageKey,
          child: const SplashScreen(),
        ),
      ),

      GoRoute(
        path:        AppRoutes.languageRegion,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const LanguageRegionScreen(),
        ),
      ),

      GoRoute(
        path:        AppRoutes.dashboard,
        pageBuilder: (context, state) => _buildFadePage(
          key:   state.pageKey,
          child: const DashboardScreen(),
        ),
      ),

      // ════════════════════════════════════════════════════
      // ONBOARDING
      // ════════════════════════════════════════════════════
      GoRoute(
        path:        AppRoutes.onboarding,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),

      // ════════════════════════════════════════════════════
      // AUTH FLOW
      // ════════════════════════════════════════════════════
      GoRoute(
        path:        AppRoutes.login,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path:        AppRoutes.signup,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path:        AppRoutes.forgotPassword,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path:        AppRoutes.resetPassword,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const ResetPasswordScreen(),
        ),
      ),
      GoRoute(
        path:        AppRoutes.verificationMethod,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const VerificationMethodScreen(),
        ),
      ),
      GoRoute(
        path:        AppRoutes.emailPin,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: EmailPinScreen(email: state.extra as String? ?? ''),
        ),
      ),
      GoRoute(
        path:        AppRoutes.phoneInput,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const PhoneInputScreen(),
        ),
      ),
      GoRoute(
        path:        AppRoutes.otpVerify,
        pageBuilder: (context, state) {
          final phone = state.extra as String? ?? '';
          return _buildSlidePage(
            key:   state.pageKey,
            child: OtpVerificationScreen(phone: phone),
          );
        },
      ),
      GoRoute(
        path:        AppRoutes.profileSetup,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const ProfileSetupScreen(),
        ),
      ),

      // ════════════════════════════════════════════════════
      // CART  (root-level → appears above bottom nav)
      // ════════════════════════════════════════════════════
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path:        AppRoutes.cart,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const CartScreen(),
        ),
      ),

      // ════════════════════════════════════════════════════
      // CHECKOUT FLOW  (root-level)
      // ════════════════════════════════════════════════════
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path:        AppRoutes.checkout,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const CheckoutScreen(),
        ),
        routes: [
          GoRoute(
            path:        'payment',
            pageBuilder: (context, state) => _buildSlidePage(
              key:   state.pageKey,
              child: PaymentScreen(
                paymentData: state.extra as Map<String, dynamic>? ?? {},
              ),
            ),
          ),
          GoRoute(
            path:        'success/:orderId',
            pageBuilder: (context, state) => _buildFadePage(
              key:   state.pageKey,
              child: OrderSuccessScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
        ],
      ),

      // ════════════════════════════════════════════════════
      // ORDERS  (root-level)
      // ════════════════════════════════════════════════════
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path:        AppRoutes.orders,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const OrdersListScreen(),
        ),
        routes: [
          GoRoute(
            path:        ':orderId',
            pageBuilder: (context, state) => _buildSlidePage(
              key:   state.pageKey,
              child: OrderDetailScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
            routes: [
              GoRoute(
                path:        'tracking',
                pageBuilder: (context, state) => _buildSlidePage(
                  key:   state.pageKey,
                  child: OrderTrackingScreen(
                    orderId: state.pathParameters['orderId']!,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // ════════════════════════════════════════════════════
      // CHAT  (root-level, opens over everything)
      // ════════════════════════════════════════════════════
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path:        AppRoutes.conversations,
        pageBuilder: (context, state) => _buildSlidePage(
          key:   state.pageKey,
          child: const ConversationsScreen(),
        ),
        routes: [
          GoRoute(
            path:        ':conversationId',
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return _buildSlidePage(
                key:   state.pageKey,
                child: ChatScreen(
                  convId: state.pathParameters['conversationId']!,
                  adTitle: extra?['adTitle'] as String?,
                  adImage: extra?['adImage'] as String?,
                ),
              );
            },
          ),
        ],
      ),


      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.helpSupport,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const HelpSupportScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.liveChat,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const LiveChatScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.rateApp,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const RateAppScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.aboutKayan,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const AboutKayanScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileSecurity,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const SecurityScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.twoFASetup,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const TwoFaSetupScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.twoFAVerify,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const TwoFaVerifyScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.connectedDevices,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ConnectedDevicesScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profilePrivacy,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const PrivacyPolicyScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileTerms,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const TermsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.faqGeneral,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const FaqGeneralScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.contactSupport,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ContactSupportScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.loyaltyCards,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const LoyaltyCardsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.referrals,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ReferralsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.subscriptions,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const SubscriptionsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.manageSubscription,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ManageSubscriptionScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.transferPoints,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const TransferPointsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.earnPoints,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const EarnPointsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.redeemPoints,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const RedeemPointsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.withdrawEarnings,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const WithdrawEarningsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.earningsHistory,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const EarningsHistoryScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.paymentReceipt,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const PaymentReceiptScreen(),
        ),
      ),


      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.advancedServiceFilters,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const AdvancedFiltersScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.serviceSubcategories,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ServiceSubcategoriesScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.serviceAddressEntry,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const AddressEntryScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.servicePaymentMethod,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const PaymentMethodScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.serviceAddCard,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const AddCardScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.servicePaymentSuccess,
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const PaymentSuccessScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.urgentService,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const UrgentServiceScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.extraMaterials,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ExtraMaterialsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.technicianArrival,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const TechnicianArrivalScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.serviceCompletion,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ServiceCompletionScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.serviceInvoice,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ServiceInvoiceScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.serviceQr,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ServiceQrScreen(),
        ),
      ),


      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.productReviews,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ProductReviewsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.productCompare,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ProductCompareScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.bestSellers,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const BestSellersScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.exclusiveOffers,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ExclusiveOffersScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.checkoutSelectAddress,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const SelectAddressScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.checkoutAddAddress,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const checkout_address.CheckoutAddAddressScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.checkoutPaymentMethod,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const PaymentMethodCheckoutScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.checkoutAddCard,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const AddCardCheckoutScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.orderConfirmation,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const OrderConfirmationScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.codDetails,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const CodDetailsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.paypalPayment,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const PaypalPaymentScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.digitalWallet,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const DigitalWalletScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.returnSelectProduct,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ReturnSelectProductScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.returnDetails,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ReturnDetailsScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.returnStatus,
        pageBuilder: (context, state) => _buildSlidePage(
          key: state.pageKey,
          child: const ReturnStatusScreen(),
        ),
      ),

      // ════════════════════════════════════════════════════
      // MAIN SHELL — Stateful Bottom Navigation (5 tabs)
      // Each branch maintains its own navigation stack.
      // ════════════════════════════════════════════════════
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) => MainShell(
          navigationShell: navigationShell,
        ),

        branches: [

          // ──────────────────────────────────────────────
          // TAB 0 — HOME 🏠
          // ──────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _homeTabKey,
            routes: [
              GoRoute(
                path:        AppRoutes.home,
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  key:   state.pageKey,
                  child: const HomeScreen(),
                ),
                routes: [
                  // Notifications accessible from home bell icon
                  GoRoute(
                    path:        'notifications',
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const NotificationsScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ──────────────────────────────────────────────
          // TAB 1 — SHOP 🛒
          // ──────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _shopTabKey,
            routes: [
              GoRoute(
                path:        AppRoutes.shop,
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  key:   state.pageKey,
                  child: const ProductListScreen(),
                ),
                routes: [
                  // Search
                  GoRoute(
                    path:        AppRoutes.$search,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: SearchScreen(
                        initialQuery: state.uri.queryParameters['q'],
                      ),
                    ),
                  ),
                  // Flash Deals
                  GoRoute(
                    path:        AppRoutes.$flashDeals,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const FlashDealsScreen(),
                    ),
                  ),
                  // All categories grid
                  GoRoute(
                    path:        AppRoutes.$categories,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const CategoriesScreen(),
                    ),
                  ),
                  // Products filtered by category
                  GoRoute(
                    path:        AppRoutes.$categoryProducts,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: ProductListScreen(
                        categorySlug: state.pathParameters['categorySlug']!,
                      ),
                    ),
                  ),
                  // Single product detail
                  GoRoute(
                    path:        AppRoutes.$productDetail,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: ProductDetailScreen(
                        slug: state.pathParameters['productSlug']!,
                      ),
                    ),
                  ),
                  // Vendor storefront
                  GoRoute(
                    path:        AppRoutes.$vendorProfile,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: VendorProfileScreen(
                        vendorSlug: state.pathParameters['vendorSlug']!,
                      ),
                    ),
                  ),
                  // Favorites
                  GoRoute(
                    path:        AppRoutes.$favorites,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const fav_screen.FavoritesScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ──────────────────────────────────────────────
          // TAB 2 — SERVICES 🔧
          // ──────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _servicesTabKey,
            routes: [
              GoRoute(
                path:        AppRoutes.services,
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  key:   state.pageKey,
                  child: const ServicesHomeScreen(),
                ),
                routes: [
                  // Categories route kept for deep-link compatibility
                  GoRoute(
                    path:        'categories',
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const ServicesHomeScreen(),
                    ),
                  ),
                  // Browse services list (by category)
                  GoRoute(
                    path:        'browse',
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: ServicesListScreen(
                        categoryId: state.uri.queryParameters['categoryId'] ?? state.uri.queryParameters['catId'],
                      ),
                    ),
                  ),
                  // My bookings
                  GoRoute(
                    path:        AppRoutes.$myBookings,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const MyBookingsScreen(),
                    ),
                    routes: [
                      GoRoute(
                        path:        ':bookingId',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: BookingDetailScreen(
                            bookingId: state.pathParameters['bookingId']!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Booking confirmation (passed via extra)
                  GoRoute(
                    path:        AppRoutes.$bookingConfirm,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: BookingConfirmationScreen(
                        bookingData: state.extra as Map<String, dynamic>? ?? {},
                      ),
                    ),
                  ),
                  // Booking success
                  GoRoute(
                    path:        AppRoutes.$bookingSuccessId,
                    pageBuilder: (context, state) => _buildFadePage(
                      key:   state.pageKey,
                      child: BookingSuccessScreen(
                        bookingId: state.pathParameters['bookingId']!,
                      ),
                    ),
                  ),
                  // Live technician tracking
                  GoRoute(
                    path:        AppRoutes.$trackingId,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: LiveTrackingScreen(
                        bookingId: state.pathParameters['bookingId']!,
                      ),
                    ),
                  ),
                  // Service detail (slug-based)
                  GoRoute(
                    path:        AppRoutes.$serviceSlug,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: ServiceDetailScreen(
                        slug: state.pathParameters['serviceSlug']!,
                      ),
                    ),
                    routes: [
                      // Booking calendar picker
                      GoRoute(
                        path:        'book',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: BookingCalendarScreen(
                            serviceSlug: state.pathParameters['serviceSlug']!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ──────────────────────────────────────────────
          // TAB 3 — CLASSIFIEDS 📢
          // ──────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _classifiedsTabKey,
            routes: [
              GoRoute(
                path:        AppRoutes.classifieds,
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  key:   state.pageKey,
                  child: const ClassifiedsHomeScreen(),
                ),
                routes: [
                  // Browse all ads
                  GoRoute(
                    path:        'browse',
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const AdsListScreen(),
                    ),
                  ),
                  // Post new ad
                  GoRoute(
                    path:        AppRoutes.$postAd,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const PostAdScreen(),
                    ),
                  ),
                  // My ads management
                  GoRoute(
                    path:        AppRoutes.$myAds,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const MyAdsScreen(),
                    ),
                  ),
                  // Edit existing ad
                  GoRoute(
                    path:        AppRoutes.$editAdId,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: PostAdScreen(
                        editAdId: state.pathParameters['adId'],
                      ),
                    ),
                  ),
                  // Boost ad
                  GoRoute(
                    path:        AppRoutes.$boostId,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: BoostAdScreen(
                        adId: state.pathParameters['adId']!,
                      ),
                    ),
                  ),
                  // Ad detail (must be last — slug catches everything)
                  GoRoute(
                    path:        AppRoutes.$adSlug,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: AdDetailScreen(
                        adSlug: state.pathParameters['adSlug']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ──────────────────────────────────────────────
          // TAB 4 — PROFILE 👤
          // ──────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _profileTabKey,
            routes: [
              GoRoute(
                path:        AppRoutes.profile,
                pageBuilder: (context, state) => _buildNoTransitionPage(
                  key:   state.pageKey,
                  child: const ProfileScreen(),
                ),
                routes: [
                  GoRoute(
                    path:        AppRoutes.$editProfile,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const EditProfileScreen(),
                    ),
                  ),
                  GoRoute(
                    path:        AppRoutes.$addresses,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const AddressesScreen(),
                    ),
                    routes: [
                      GoRoute(
                        path:        'add',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: const AddAddressScreen(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path:        AppRoutes.$notifications,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const NotificationsScreen(),
                    ),
                  ),
                  GoRoute(
                    path:        AppRoutes.$wallet,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const WalletScreen(),
                    ),
                  ),
                  GoRoute(
                    path:        AppRoutes.$loyalty,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const LoyaltyScreen(),
                    ),
                  ),
                  GoRoute(
                    path:        AppRoutes.$settings,
                    pageBuilder: (context, state) => _buildSlidePage(
                      key:   state.pageKey,
                      child: const SettingsScreen(),
                    ),
                    routes: [
                      GoRoute(
                        path:        'language',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: const LanguageSettingsScreen(),
                        ),
                      ),
                      GoRoute(
                        path:        'theme',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: const ThemeSettingsScreen(),
                        ),
                      ),
                      GoRoute(
                        path:        'notifications',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: const NotificationSettingsScreen(),
                        ),
                      ),
                      GoRoute(
                        path:        'security',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: const SecuritySettingsScreen(),
                        ),
                      ),
                      GoRoute(
                        path:        'about',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: const AboutAppScreen(),
                        ),
                      ),
                      GoRoute(
                        path:        'privacy',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: const LegalScreen(type: LegalType.privacy),
                        ),
                      ),
                      GoRoute(
                        path:        'terms',
                        pageBuilder: (context, state) => _buildSlidePage(
                          key:   state.pageKey,
                          child: const LegalScreen(type: LegalType.terms),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ════════════════════════════════════════════════════
      // SYSTEM ROUTES
      // ════════════════════════════════════════════════════
      GoRoute(
        path:        AppRoutes.notFound,
        pageBuilder: (context, state) => _buildFadePage(
          key:   state.pageKey,
          child: const _NotFoundScreen(),
        ),
      ),
      GoRoute(
        path:        AppRoutes.noInternet,
        pageBuilder: (context, state) => _buildFadePage(
          key:   state.pageKey,
          child: const _NoInternetScreen(),
        ),
      ),
      GoRoute(
        path:        AppRoutes.maintenance,
        pageBuilder: (context, state) => _buildFadePage(
          key:   state.pageKey,
          child: const _MaintenanceScreen(),
        ),
      ),
    ],
  );
});

// ──────────────────────────────────────────────────────────────
// PAGE TRANSITION BUILDERS
// ──────────────────────────────────────────────────────────────

/// Slide from right — standard push navigation
CustomTransitionPage<void> _buildSlidePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key:                       key,
    child:                     child,
    transitionDuration:        const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Primary: slide in from right
      final slideAnim = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end:   Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

      // Secondary: fade out current page slightly
      final fadePreviousAnim = Tween<double>(begin: 1.0, end: 0.92)
          .chain(CurveTween(curve: Curves.easeOut))
          .animate(secondaryAnimation);

      // Incoming page: fade in quickly
      final fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: const Interval(0.0, 0.5, curve: Curves.easeOut)))
          .animate(animation);

      return FadeTransition(
        opacity: fadePreviousAnim,
        child: SlideTransition(
          position: slideAnim,
          child: FadeTransition(opacity: fadeAnim, child: child),
        ),
      );
    },
  );
}

/// Fade — for splash → home, success screens
CustomTransitionPage<void> _buildFadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key:                       key,
    child:                     child,
    transitionDuration:        const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child:   child,
      );
    },
  );
}

/// No transition — for bottom-tab switches
NoTransitionPage<void> _buildNoTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return NoTransitionPage<void>(key: key, child: child);
}

// ──────────────────────────────────────────────────────────────
// ERROR / SYSTEM SCREENS
// (Inline — these are router-level system screens, not features)
// ──────────────────────────────────────────────────────────────

class _RouterErrorPage extends StatelessWidget {
  final String error;
  const _RouterErrorPage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 64, color: AppColors.error),
              const SizedBox(height: 20),
              Text('Page not found',
                  style: AppTextStyles.titleLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(error,
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Go to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.royalBlue.withOpacity(0.4),
                  fontWeight: FontWeight.w800,
                )),
            const SizedBox(height: 12),
            Text('الصفحة غير موجودة',
                style: AppTextStyles.arabicTitleLarge),
            const SizedBox(height: 4),
            Text('Page not found', style: AppTextStyles.bodySmall),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('الصفحة الرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoInternetScreen extends StatelessWidget {
  const _NoInternetScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 80, color: AppColors.textMuted.withOpacity(0.5)),
            const SizedBox(height: 20),
            Text('لا يوجد اتصال بالإنترنت',
                style: AppTextStyles.arabicTitleMedium),
            const SizedBox(height: 4),
            Text('Check your connection and try again',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceScreen extends StatelessWidget {
  const _MaintenanceScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.royalNavy, AppColors.bgCard, AppColors.deepBlue],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [AppColors.metallicGold, AppColors.goldLight]),
                  ),
                  child: const Icon(Icons.engineering_rounded, color: AppColors.bgPrimary, size: 52),
                ),
                const SizedBox(height: 24),
                Text('تحديثات فاخرة قيد التنفيذ', style: AppTextStyles.arabicTitleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('KAYAN is being refined. Please try again shortly.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
