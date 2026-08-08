// ============================================================
// KAYAN Super App — Route Constants
// lib/routing/app_routes.dart
//
// Single source of truth for all route paths.
// Never hardcode path strings in widgets — always use this.
//
// Pattern:
//   - Static const  → exact path (for GoRoute path:)
//   - Static method → parametrized path (for context.go())
// ============================================================

abstract final class AppRoutes {
  // ──────────────────────────────────────────────────────────
  // 🚀 ENTRY FLOWS
  // ──────────────────────────────────────────────────────────

  static const String splash      = '/';
  static const String onboarding  = '/onboarding';
  static const String languageRegion = '/language-region';
  static const String dashboard   = '/dashboard';

  // ──────────────────────────────────────────────────────────
  // 🔐 AUTH
  // ──────────────────────────────────────────────────────────

  static const String login        = '/auth/login';
  static const String signup       = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verificationMethod = '/auth/verify-method';
  static const String emailPin     = '/auth/email-pin';
  static const String phoneInput   = '/auth/phone';
  static const String otpVerify    = '/auth/otp';
  static const String profileSetup = '/auth/profile-setup';

  // ──────────────────────────────────────────────────────────
  // 🏠 MAIN SHELL TABS (Bottom Navigation)
  // ──────────────────────────────────────────────────────────

  static const String home        = '/home';
  static const String delivery    = '/delivery';
  static const String shop        = '/shop';
  static const String services    = '/services';
  static const String classifieds = '/classifieds';
  static const String profile     = '/profile';

  // ──────────────────────────────────────────────────────────
  // 🍔 FOOD & GROCERY DELIVERY (طلبات — nested + checkout flow)
  // ──────────────────────────────────────────────────────────

  static const String deliveryVendors  = '/delivery/vendors';
  static const String deliveryCart     = '/delivery/cart';
  static const String deliveryAddress  = '/delivery/address';
  static const String deliveryPayment  = '/delivery/payment';
  static const String deliverySuccess  = '/delivery/success';
  static const String deliveryTracking = '/delivery/tracking';
  static const String deliveryMyOrders = '/delivery/my-orders';
  static const String deliveryFavorites = '/delivery/favorites';
  static const String deliveryCoupons = '/delivery/coupons';

  static const String _deliveryVendorSlug = 'vendors/:vendorSlug';
  static const String _deliveryItemId     = 'vendors/:vendorSlug/items/:itemId';
  static const String _deliveryMyOrders   = 'my-orders';
  static const String _deliveryFavorites  = 'favorites';
  static const String _deliveryCoupons    = 'coupons';
  static const String _deliveryOrderId    = 'orders/:orderId';
  static const String _deliveryRateOrderId = 'rate/:orderId';

  // ──────────────────────────────────────────────────────────
  // 🛒 E-COMMERCE (nested under /shop)
  // ──────────────────────────────────────────────────────────

  // Relative paths (used inside ShellBranch routes list)
  static const String _categories       = 'categories';
  static const String _categoryProducts = 'categories/:categorySlug';
  static const String _productDetail    = 'products/:productSlug';
  static const String _search           = 'search';
  static const String _flashDeals       = 'flash-deals';
  static const String _vendorProfile    = 'vendors/:vendorSlug';
  static const String _favorites        = 'favorites';
  static const String _browse           = 'browse';
  static const String _shopNotifications = 'notifications';
  static const String _shopMyOrders      = 'my-orders';
  static const String _shopCart          = 'cart';
  static const String _shopCheckout      = 'checkout';
  static const String _shopSuccess       = 'success';

  // Full absolute paths (used by context.go / context.push)
  static const String categories       = '/shop/categories';
  static const String search           = '/shop/search';
  static const String flashDeals       = '/shop/flash-deals';
  static const String favorites        = '/shop/favorites';
  static const String shopBrowse       = '/shop/browse';
  static const String productReviews    = '/shop/product-reviews';
  static const String productCompare    = '/shop/product-compare';
  static const String bestSellers       = '/shop/best-sellers';
  static const String exclusiveOffers   = '/shop/exclusive-offers';
  static const String shopMyOrders      = '/shop/my-orders';
  static const String shopCart          = '/shop/cart';
  static const String shopCheckout      = '/shop/checkout';
  static const String shopSuccess       = '/shop/success';

  // ──────────────────────────────────────────────────────────
  // 🛍️ CART & CHECKOUT (global, outside shell)
  // ──────────────────────────────────────────────────────────

  static const String cart           = '/cart';
  static const String checkout       = '/checkout';
  static const String paymentScreen  = '/checkout/payment';
  static const String checkoutSelectAddress = '/checkout/select-address';
  static const String checkoutAddAddress = '/checkout/add-address';
  static const String checkoutPaymentMethod = '/checkout/payment-method';
  static const String checkoutAddCard = '/checkout/add-card';
  static const String orderConfirmation = '/checkout/order-confirmation';
  static const String codDetails      = '/checkout/cod-details';
  static const String paypalPayment   = '/checkout/paypal';
  static const String digitalWallet   = '/checkout/digital-wallet';

  static const String returnSelectProduct = '/returns/select-product';
  static const String returnDetails   = '/returns/details';
  static const String returnStatus    = '/returns/status';
  // orderSuccess built with helper below

  // ──────────────────────────────────────────────────────────
  // 📦 ORDERS (global)
  // ──────────────────────────────────────────────────────────

  static const String orders         = '/orders';
  // orderDetail + orderTracking built with helpers below

  // ──────────────────────────────────────────────────────────
  // 🔧 SERVICES (nested under /services)
  // ──────────────────────────────────────────────────────────

  static const String serviceCategories  = '/services/categories';
  static const String servicesList       = '/services/browse';
  static const String myBookings         = '/services/my-bookings';
  static const String bookingConfirm     = '/services/booking/confirm';
  static const String advancedServiceFilters = '/services/filters';
  static const String serviceSubcategories  = '/services/subcategories';
  static const String serviceAddressEntry   = '/services/booking/address';
  static const String servicePaymentMethod  = '/services/booking/payment-method';
  static const String serviceAddCard        = '/services/booking/add-card';
  static const String servicePaymentSuccess = '/services/booking/payment-success';
  static const String urgentService         = '/services/urgent';
  static const String extraMaterials        = '/services/booking/extra-materials';
  static const String technicianArrival     = '/services/booking/technician-arrival';
  static const String serviceCompletion     = '/services/booking/completion';
  static const String serviceInvoice        = '/services/booking/invoice';
  static const String serviceQr             = '/services/booking/qr';
  // serviceDetail, serviceBook, bookingDetail, bookingSuccess,
  // liveTracking → built with helpers below

  // Relative sub-paths (for GoRoute nesting)
  static const String _serviceSlug      = ':serviceSlug';
  static const String _bookSlug         = ':serviceSlug/book';
  static const String _bookingConfirm   = 'booking/confirm';
  static const String _bookingSuccessId = 'booking/success/:bookingId';
  static const String _myBookings       = 'my-bookings';
  static const String _bookingDetailId  = 'my-bookings/:bookingId';
  static const String _trackingId       = 'tracking/:bookingId';

  // ──────────────────────────────────────────────────────────
  // 📢 CLASSIFIEDS (nested under /classifieds)
  // ──────────────────────────────────────────────────────────

  static const String adsList   = '/classifieds/browse';
  static const String postAd    = '/classifieds/post';
  static const String myAds     = '/classifieds/my-ads';
  static const String searchAds = '/classifieds/search';
  static const String adFilters = '/classifieds/filters';
  static const String featuredAds = '/classifieds/featured';
  static const String savedAds  = '/classifieds/saved';
  static const String classifiedsChats = '/classifieds/chats';
  static const String classifiedsCategories = '/classifieds/ad-categories';
  static const String contactSeller = '/classifieds/contact-seller';
  static const String recentViews = '/classifieds/recent-views';
  static const String classifiedsNotifications = '/classifieds/notifications';
  static const String pendingAds = '/classifieds/my-ads/pending';
  static const String rejectedAds = '/classifieds/my-ads/rejected';
  // adDetail, editAd, boostAd, seller, report, similar, stats → helpers

  static const String _adSlug   = ':adSlug';
  static const String _postAd   = 'post';
  static const String _editAdId = 'edit/:adId';
  static const String _boostId  = 'boost/:adId';
  static const String _myAds    = 'my-ads';
  static const String _searchAds = 'search';
  static const String _adFilters = 'filters';
  static const String _featuredAds = 'featured';
  static const String _savedAds = 'saved';
  static const String _recentViews = 'recent-views';
  static const String _classifiedsNotif = 'notifications';
  static const String _pendingAds = 'my-ads/pending';
  static const String _rejectedAds = 'my-ads/rejected';
  static const String _adStatsId = 'my-ads/stats/:adId';
  static const String _sellerId = 'seller/:sellerId';
  static const String _reportAdSlug = 'report/:adSlug';
  static const String _similarAdSlug = 'similar/:adSlug';
  static const String _classifiedsChats = 'chats';
  static const String _classifiedsChatId = 'chats/:chatId';
  static const String _contactSeller = 'contact-seller';
  static const String _classifiedsCategories = 'ad-categories';
  static const String _categoryBrowse = 'category/:categorySlug';

  // ──────────────────────────────────────────────────────────
  // 💬 CHAT (global)
  // ──────────────────────────────────────────────────────────

  static const String conversations    = '/chat';
  // chatRoom → helper

  // ──────────────────────────────────────────────────────────
  // 👤 PROFILE (nested under /profile)
  // ──────────────────────────────────────────────────────────

  static const String editProfile      = '/profile/edit';
  static const String addresses        = '/profile/addresses';
  static const String addAddress       = '/profile/addresses/add';
  static const String notifications    = '/profile/notifications';
  static const String wallet           = '/profile/wallet';
  static const String loyalty          = '/profile/loyalty';
  static const String settings         = '/profile/settings';
  static const String helpSupport      = '/profile/help-support';
  static const String liveChat         = '/profile/live-chat';
  static const String rateApp          = '/profile/rate-app';
  static const String aboutKayan       = '/profile/about-kayan';
  static const String profileSecurity  = '/profile/security';
  static const String twoFASetup       = '/profile/security/2fa-setup';
  static const String twoFAVerify      = '/profile/security/2fa-verify';
  static const String connectedDevices = '/profile/security/devices';
  static const String profilePrivacy   = '/profile/privacy';
  static const String profileTerms     = '/profile/terms';
  static const String faqGeneral       = '/profile/faq';
  static const String contactSupport   = '/profile/contact-support';
  static const String loyaltyCards     = '/profile/loyalty/cards';
  static const String referrals        = '/profile/referrals';
  static const String subscriptions    = '/profile/subscriptions';
  static const String manageSubscription = '/profile/subscriptions/manage';

  static const String transferPoints   = '/profile/wallet/transfer-points';
  static const String earnPoints       = '/profile/wallet/earn-points';
  static const String redeemPoints     = '/profile/wallet/redeem-points';
  static const String withdrawEarnings = '/profile/wallet/withdraw-earnings';
  static const String earningsHistory  = '/profile/wallet/earnings-history';
  static const String paymentReceipt   = '/profile/wallet/payment-receipt';

  // Relative paths
  static const String _editProfile     = 'edit';
  static const String _addresses       = 'addresses';
  static const String _addAddress      = 'addresses/add';
  static const String _notifications   = 'notifications';
  static const String _wallet          = 'wallet';
  static const String _loyalty         = 'loyalty';
  static const String _settings        = 'settings';

  // ──────────────────────────────────────────────────────────
  // ⚙️ SETTINGS (nested under /profile/settings)
  // ──────────────────────────────────────────────────────────

  static const String settingsLanguage = '/profile/settings/language';
  static const String settingsTheme    = '/profile/settings/theme';
  static const String settingsNotif    = '/profile/settings/notifications';
  static const String settingsSecurity = '/profile/settings/security';
  static const String aboutApp         = '/profile/settings/about';
  static const String privacyPolicy    = '/profile/settings/privacy';
  static const String termsOfService   = '/profile/settings/terms';

  // ──────────────────────────────────────────────────────────
  // 🚨 SYSTEM
  // ──────────────────────────────────────────────────────────

  static const String notFound    = '/404';
  static const String noInternet  = '/no-internet';
  static const String maintenance = '/maintenance';
  static const String quickSwitch = '/quick-switch';
  static const String fullscreenGallery = '/gallery';
  static const String welcomeOffer = '/welcome-offer';

  // ──────────────────────────────────────────────────────────
  // 🛡️ ADMIN (hidden)
  // ──────────────────────────────────────────────────────────

  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminProducts = '/admin/products';
  static const String adminCategories = '/admin/categories';
  static const String adminServices = '/admin/services';
  static const String adminAds = '/admin/ads';
  static const String adminSettings = '/admin/settings';
  static const String adminBanners = '/admin/banners';
  static const String adminColors = '/admin/colors';
  static const String adminFonts = '/admin/fonts';
  static const String adminScreens = '/admin/screens';

  // ── Super Admin Design Engine ──
  static const String superAdminDashboard = '/super-admin/dashboard';
  static const String superAdminColors = '/super-admin/colors';
  static const String superAdminTypography = '/super-admin/typography';
  static const String superAdminRadius = '/super-admin/radius-shadows';
  static const String superAdminAnimations = '/super-admin/animations';

  // ── Additional documented screens ──
  static const String unifiedOrders = '/orders-unified';
  static const String unifiedWishlist = '/wishlist';
  static const String searchServices = '/services/search';
  static const String cancelBooking = '/services/cancel-booking';
  static const String rescheduleBooking = '/services/reschedule-booking';
  static const String reportIssue = '/services/report-issue';
  static const String serviceNotifications = '/services/notifications';
  static const String servicePackages      = '/services/packages';
  static const String shopFilters = '/shop/filters';
  static const String shopNotifications = '/shop/notifications';
  static const String postAdSuccess = '/classifieds/post/success';
  static const String whatsNew = '/whats-new';
  static const String appPermissions = '/permissions';
  static const String emptyState = '/empty-state';
  static const String advancedSearch = '/search/advanced';
  static const String mapPicker = '/map-picker';
  static const String qrDisplay = '/qr';
  static const String callScreen = '/call';
  static const String cancelOtp = '/cancel-confirm-otp';
  static const String reviewReply = '/review-reply';
  static const String virtualTour = '/virtual-tour';
  static const String changePassword = '/profile/security/change-password';
  static const String deleteAccount = '/profile/security/delete-account';
  static const String pointsRefund = '/profile/wallet/points-refund';
  static const String languageSettings = '/profile/settings/language';

  // Legacy screen aliases (deep-link compatibility)
  static const String legacyProductList = '/shop/product-list';
  static const String legacyProductDetail = '/shop/product-detail/:productSlug';
  static const String legacyLiveTracking = '/services/live-tracking/:bookingId';
  static const String legacyProfile = '/profile/classic';
  static const String legacySettings = '/settings/classic';

  // ──────────────────────────────────────────────────────────
  // 🔗 Relative path constants (used in GoRoute `path:`)
  //
  // These are exposed so router can reference them without
  // duplicating strings. Prefix with $ to indicate "relative".
  // ──────────────────────────────────────────────────────────

  // E-commerce relative paths
  static const String $categories       = _categories;
  static const String $categoryProducts = _categoryProducts;
  static const String $productDetail    = _productDetail;
  static const String $search           = _search;
  static const String $flashDeals       = _flashDeals;
  static const String $vendorProfile    = _vendorProfile;
  static const String $favorites        = _favorites;
  static const String $browse           = _browse;
  static const String $shopNotifications = _shopNotifications;

  // Services relative paths
  static const String $serviceSlug      = _serviceSlug;
  static const String $bookSlug         = _bookSlug;
  static const String $bookingConfirm   = _bookingConfirm;
  static const String $bookingSuccessId = _bookingSuccessId;
  static const String $myBookings       = _myBookings;
  static const String $bookingDetailId  = _bookingDetailId;
  static const String $trackingId       = _trackingId;

  // Classifieds relative paths
  static const String $adSlug           = _adSlug;
  static const String $postAd           = _postAd;
  static const String $editAdId         = _editAdId;
  static const String $boostId          = _boostId;
  static const String $myAds            = _myAds;
  static const String $searchAds        = _searchAds;
  static const String $adFilters        = _adFilters;
  static const String $featuredAds      = _featuredAds;
  static const String $savedAds         = _savedAds;
  static const String $recentViews      = _recentViews;
  static const String $classifiedsNotif = _classifiedsNotif;
  static const String $pendingAds       = _pendingAds;
  static const String $rejectedAds      = _rejectedAds;
  static const String $adStatsId        = _adStatsId;
  static const String $sellerId         = _sellerId;
  static const String $reportAdSlug     = _reportAdSlug;
  static const String $similarAdSlug    = _similarAdSlug;
  static const String $classifiedsChats  = _classifiedsChats;
  static const String $classifiedsChatId = _classifiedsChatId;
  static const String $contactSeller     = _contactSeller;
  static const String $classifiedsCategories = _classifiedsCategories;
  static const String $categoryBrowse = _categoryBrowse;

  // Delivery relative paths
  static const String $deliveryVendorSlug = _deliveryVendorSlug;
  static const String $deliveryItemId     = _deliveryItemId;
  static const String $deliveryMyOrders   = _deliveryMyOrders;
  static const String $deliveryFavorites  = _deliveryFavorites;
  static const String $deliveryCoupons    = _deliveryCoupons;
  static const String $deliveryOrderId    = _deliveryOrderId;
  static const String $deliveryRateOrderId = _deliveryRateOrderId;
  static const String $shopMyOrders       = _shopMyOrders;
  static const String $shopCart           = _shopCart;
  static const String $shopCheckout       = _shopCheckout;
  static const String $shopSuccess        = _shopSuccess;

  // Profile relative paths
  static const String $editProfile      = _editProfile;
  static const String $addresses        = _addresses;
  static const String $addAddress       = _addAddress;
  static const String $notifications    = _notifications;
  static const String $wallet           = _wallet;
  static const String $loyalty          = _loyalty;
  static const String $settings         = _settings;

  // ──────────────────────────────────────────────────────────
  // 🛠️ PATH BUILDER HELPERS
  //
  // Use these for context.go() / context.push() calls.
  // They guarantee correctly formatted paths with params.
  // ──────────────────────────────────────────────────────────

  // E-commerce
  static String categoryPath(String slug)   => '/shop/categories/$slug';
  static String productListPath(String slug) => categoryPath(slug);
  static String productPath(String slug)    => '/shop/products/$slug';
  static String vendorPath(String slug)     => '/shop/vendors/$slug';

  // Orders
  static String orderPath(String id)        => '/orders/$id';
  static String orderTrackPath(String id)   => '/orders/$id/tracking';
  static String orderSuccessPath(String id) => '/checkout/success/$id';

  // Services
  static String servicePath(String slug)        => '/services/$slug';
  static String serviceBookPath(String slug)    => '/services/$slug/book';
  static String bookingPath(String id)          => '/services/my-bookings/$id';
  static String trackingPath(String id)         => '/services/tracking/$id';
  static String liveTrackingPath(String id)     => '/services/live-tracking/$id';
  static String legacyProductDetailPath(String slug) => '/shop/product-detail/$slug';
  static String bookingSuccessPath(String id)   => '/services/booking/success/$id';

  // Classifieds
  static String adPath(String slug)         => '/classifieds/$slug';
  static String editAdPath(String id)       => '/classifieds/edit/$id';
  static String boostAdPath(String id)      => '/classifieds/boost/$id';
  static String sellerPath(String sellerId) => '/classifieds/seller/$sellerId';
  static String reportAdPath(String slug)   => '/classifieds/report/$slug';
  static String similarAdsPath(String slug) => '/classifieds/similar/$slug';
  static String adStatsPath(String adId)    => '/classifieds/my-ads/stats/$adId';
  static String contactSellerPath({String? adSlug, String? sellerId}) {
    final params = <String>[];
    if (adSlug != null) params.add('ad=$adSlug');
    if (sellerId != null) params.add('seller=$sellerId');
    if (params.isEmpty) return contactSeller;
    return '$contactSeller?${params.join('&')}';
  }

  static String classifiedsChatPath(String chatId) => '/classifieds/chats/$chatId';
  static String classifiedsCategoryPath(String slug) => '/classifieds/category/$slug';
  static String galleryPath()               => '/gallery';

  // Chat
  static String chatPath(String convId)     => '/chat/$convId';

  // Delivery (طلبات)
  static String deliveryVendorPath(String slug) => '/delivery/vendors/$slug';
  static String deliveryItemPath(String vendorSlug, String itemId) =>
      '/delivery/vendors/$vendorSlug/items/$itemId';
  static String deliveryOrderPath(String orderId) => '/delivery/orders/$orderId';
  static String deliveryRatePath(String orderId) => '/delivery/rate/$orderId';
}
