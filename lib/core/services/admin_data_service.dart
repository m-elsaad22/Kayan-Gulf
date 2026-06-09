// TODO: connect to real backend
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock/mock_products.dart';
import '../../features/classifieds/browse/data/models/ad_models.dart';
import '../../features/services/browse/data/models/service_models.dart';

class AdminServiceItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final String categorySlug;
  final double price;
  final String descriptionAr;
  final String imageUrl;
  final int durationMin;
  final double rating;
  final bool isActive;

  const AdminServiceItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.categorySlug,
    required this.price,
    required this.descriptionAr,
    required this.imageUrl,
    this.durationMin = 60,
    this.rating = 4.5,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'categorySlug': categorySlug,
        'price': price,
        'descriptionAr': descriptionAr,
        'imageUrl': imageUrl,
        'durationMin': durationMin,
        'rating': rating,
        'isActive': isActive,
      };

  factory AdminServiceItem.fromJson(Map<String, dynamic> j) =>
      AdminServiceItem(
        id: j['id'] as String,
        nameAr: j['nameAr'] as String,
        nameEn: j['nameEn'] as String,
        categorySlug: j['categorySlug'] as String,
        price: (j['price'] as num).toDouble(),
        descriptionAr: j['descriptionAr'] as String,
        imageUrl: j['imageUrl'] as String,
        durationMin: j['durationMin'] as int? ?? 60,
        rating: (j['rating'] as num?)?.toDouble() ?? 4.5,
        isActive: j['isActive'] as bool? ?? true,
      );
}

class AdminAdItem {
  final String id;
  final String title;
  final String slug;
  final double? price;
  final String city;
  final String imageUrl;
  final String status; // pending, approved, rejected
  final String descriptionAr;

  const AdminAdItem({
    required this.id,
    required this.title,
    required this.slug,
    this.price,
    required this.city,
    required this.imageUrl,
    this.status = 'pending',
    this.descriptionAr = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'price': price,
        'city': city,
        'imageUrl': imageUrl,
        'status': status,
        'descriptionAr': descriptionAr,
      };

  factory AdminAdItem.fromJson(Map<String, dynamic> j) => AdminAdItem(
        id: j['id'] as String,
        title: j['title'] as String,
        slug: j['slug'] as String,
        price: (j['price'] as num?)?.toDouble(),
        city: j['city'] as String,
        imageUrl: j['imageUrl'] as String,
        status: j['status'] as String? ?? 'pending',
        descriptionAr: j['descriptionAr'] as String? ?? '',
      );
}

class AdminSettings {
  final String appName;
  final String logoUrl;
  final List<String> bannerUrls;
  final List<String> featuredProductIds;
  final String welcomeOfferText;
  final String welcomeOfferCode;
  final String contactPhone;
  final String contactEmail;

  const AdminSettings({
    this.appName = 'كيان KAYAN',
    this.logoUrl = 'assets/images/kayan_logo.png',
    this.bannerUrls = const [],
    this.featuredProductIds = const [],
    this.welcomeOfferText = 'خصم 15% على أول طلب',
    this.welcomeOfferCode = 'KAYAN15',
    this.contactPhone = '+966 9200 12345',
    this.contactEmail = 'support@kayan.sa',
  });

  Map<String, dynamic> toJson() => {
        'appName': appName,
        'logoUrl': logoUrl,
        'bannerUrls': bannerUrls,
        'featuredProductIds': featuredProductIds,
        'welcomeOfferText': welcomeOfferText,
        'welcomeOfferCode': welcomeOfferCode,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
      };

  factory AdminSettings.fromJson(Map<String, dynamic> j) => AdminSettings(
        appName: j['appName'] as String? ?? 'كيان KAYAN',
        logoUrl: j['logoUrl'] as String? ?? 'assets/images/kayan_logo.png',
        bannerUrls: (j['bannerUrls'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        featuredProductIds: (j['featuredProductIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        welcomeOfferText:
            j['welcomeOfferText'] as String? ?? 'خصم 15% على أول طلب',
        welcomeOfferCode: j['welcomeOfferCode'] as String? ?? 'KAYAN15',
        contactPhone: j['contactPhone'] as String? ?? '+966 9200 12345',
        contactEmail: j['contactEmail'] as String? ?? 'support@kayan.sa',
      );

  AdminSettings copyWith({
    String? appName,
    String? logoUrl,
    List<String>? bannerUrls,
    List<String>? featuredProductIds,
    String? welcomeOfferText,
    String? welcomeOfferCode,
    String? contactPhone,
    String? contactEmail,
  }) =>
      AdminSettings(
        appName: appName ?? this.appName,
        logoUrl: logoUrl ?? this.logoUrl,
        bannerUrls: bannerUrls ?? this.bannerUrls,
        featuredProductIds: featuredProductIds ?? this.featuredProductIds,
        welcomeOfferText: welcomeOfferText ?? this.welcomeOfferText,
        welcomeOfferCode: welcomeOfferCode ?? this.welcomeOfferCode,
        contactPhone: contactPhone ?? this.contactPhone,
        contactEmail: contactEmail ?? this.contactEmail,
      );
}

class AdminThemeColors {
  final String primaryHex;
  final String accentHex;
  final String goldHex;
  final String turquoiseHex;

  const AdminThemeColors({
    this.primaryHex = '#0A2B5E',
    this.accentHex = '#0033A0',
    this.goldHex = '#F4D03F',
    this.turquoiseHex = '#00A8A8',
  });

  Map<String, dynamic> toJson() => {
        'primaryHex': primaryHex,
        'accentHex': accentHex,
        'goldHex': goldHex,
        'turquoiseHex': turquoiseHex,
      };

  factory AdminThemeColors.fromJson(Map<String, dynamic> j) => AdminThemeColors(
        primaryHex: j['primaryHex'] as String? ?? '#0A2B5E',
        accentHex: j['accentHex'] as String? ?? '#0033A0',
        goldHex: j['goldHex'] as String? ?? '#F4D03F',
        turquoiseHex: j['turquoiseHex'] as String? ?? '#00A8A8',
      );
}

class AdminFontSettings {
  final double titleScale;
  final double bodyScale;
  final double captionScale;

  const AdminFontSettings({
    this.titleScale = 1.0,
    this.bodyScale = 1.0,
    this.captionScale = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'titleScale': titleScale,
        'bodyScale': bodyScale,
        'captionScale': captionScale,
      };

  factory AdminFontSettings.fromJson(Map<String, dynamic> j) => AdminFontSettings(
        titleScale: (j['titleScale'] as num?)?.toDouble() ?? 1.0,
        bodyScale: (j['bodyScale'] as num?)?.toDouble() ?? 1.0,
        captionScale: (j['captionScale'] as num?)?.toDouble() ?? 1.0,
      );
}

class AdminDataService {
  AdminDataService._();
  static final AdminDataService instance = AdminDataService._();

  static const _kProducts = 'admin_products_v1';
  static const _kCategories = 'admin_categories_v1';
  static const _kServices = 'admin_services_v1';
  static const _kAds = 'admin_ads_v1';
  static const _kSettings = 'admin_settings_v1';
  static const _kThemeColors = 'admin_theme_colors_v1';
  static const _kFontSettings = 'admin_font_settings_v1';
  static const _kScreenVisibility = 'admin_screen_visibility_v1';
  static const _kLoggedIn = 'admin_logged_in_v1';

  SharedPreferences? _prefs;
  List<MockProduct>? _products;
  List<MockProductCategory>? _categories;
  List<AdminServiceItem>? _services;
  List<AdminAdItem>? _ads;
  AdminSettings? _settings;
  AdminThemeColors? _themeColors;
  AdminFontSettings? _fontSettings;
  Map<String, bool>? _screenVisibility;
  bool _loggedIn = false;
  int _revision = 0;
  final ValueNotifier<int> revisionNotifier = ValueNotifier<int>(0);

  bool get isAdminLoggedIn => _loggedIn;
  int get revision => _revision;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loggedIn = _prefs!.getBool(_kLoggedIn) ?? false;
    await _loadAll();
  }

  Future<void> _loadAll() async {
    _products = _readList(_kProducts, mockProducts, MockProduct.fromJson);
    _categories = _readList(
      _kCategories,
      mockProductCategories,
      (j) => MockProductCategory(
        id: j['id'] as String,
        nameAr: j['nameAr'] as String,
        nameEn: j['nameEn'] as String,
        imageUrl: j['imageUrl'] as String,
        subcategories: (j['subcategories'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      ),
    );
    _services = _readList(_kServices, _defaultServices(), AdminServiceItem.fromJson);
    _ads = _readList(_kAds, _defaultAds(), AdminAdItem.fromJson);
    final settingsRaw = _prefs?.getString(_kSettings);
    _settings = settingsRaw != null
        ? AdminSettings.fromJson(jsonDecode(settingsRaw) as Map<String, dynamic>)
        : AdminSettings(
            bannerUrls: [
              'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
              'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
            ],
            featuredProductIds:
                mockProducts.take(5).map((p) => p.id).toList(),
          );
    final colorsRaw = _prefs?.getString(_kThemeColors);
    _themeColors = colorsRaw != null
        ? AdminThemeColors.fromJson(
            jsonDecode(colorsRaw) as Map<String, dynamic>,
          )
        : const AdminThemeColors();
    final fontsRaw = _prefs?.getString(_kFontSettings);
    _fontSettings = fontsRaw != null
        ? AdminFontSettings.fromJson(
            jsonDecode(fontsRaw) as Map<String, dynamic>,
          )
        : const AdminFontSettings();
    final visRaw = _prefs?.getString(_kScreenVisibility);
    _screenVisibility = visRaw != null
        ? Map<String, bool>.from(jsonDecode(visRaw) as Map)
        : <String, bool>{};
  }

  void _bumpRevision() {
    _revision++;
    revisionNotifier.value = _revision;
  }

  List<T> _readList<T>(
    String key,
    List<T> fallback,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final raw = _prefs?.getString(key);
    if (raw == null) return List<T>.from(fallback);
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return List<T>.from(fallback);
    }
  }

  Future<void> _saveList(String key, List<dynamic> items) async {
    await _prefs?.setString(
      key,
      jsonEncode(items.map((e) => (e as dynamic).toJson()).toList()),
    );
  }

  List<MockProduct> getProducts() =>
      List<MockProduct>.from(_products ?? mockProducts);

  List<MockProductCategory> getCategories() =>
      List<MockProductCategory>.from(_categories ?? mockProductCategories);

  List<AdminServiceItem> getServices() =>
      List<AdminServiceItem>.from(_services ?? _defaultServices());

  List<AdminAdItem> getAds() => List<AdminAdItem>.from(_ads ?? _defaultAds());

  AdminSettings getSettings() => _settings ?? const AdminSettings();

  AdminThemeColors getThemeColors() =>
      _themeColors ?? const AdminThemeColors();

  AdminFontSettings getFontSettings() =>
      _fontSettings ?? const AdminFontSettings();

  bool isScreenVisible(String routeKey) =>
      _screenVisibility?[routeKey] ?? true;

  Future<void> saveThemeColors(AdminThemeColors colors) async {
    _themeColors = colors;
    await _prefs?.setString(_kThemeColors, jsonEncode(colors.toJson()));
    _bumpRevision();
  }

  Future<void> saveFontSettings(AdminFontSettings fonts) async {
    _fontSettings = fonts;
    await _prefs?.setString(_kFontSettings, jsonEncode(fonts.toJson()));
    _bumpRevision();
  }

  Future<void> saveScreenVisibility(Map<String, bool> visibility) async {
    _screenVisibility = Map<String, bool>.from(visibility);
    await _prefs?.setString(_kScreenVisibility, jsonEncode(visibility));
    _bumpRevision();
  }

  Future<void> saveBanners(List<String> urls) async {
    final s = getSettings().copyWith(bannerUrls: urls);
    await saveSettings(s);
    _bumpRevision();
  }

  List<String> getBannerUrls() => getSettings().bannerUrls;

  String getAppName() => getSettings().appName;

  String getLogoPath() {
    final url = getSettings().logoUrl;
    return url.startsWith('http') ? url : url;
  }

  Future<bool> login(String username, String password) async {
    if (username == 'admin' && password == 'kayan@admin') {
      _loggedIn = true;
      await _prefs?.setBool(_kLoggedIn, true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _loggedIn = false;
    await _prefs?.setBool(_kLoggedIn, false);
  }

  Future<void> saveProducts(List<MockProduct> products) async {
    _products = List<MockProduct>.from(products);
    await _saveList(_kProducts, _products!);
  }

  Future<void> upsertProduct(MockProduct product) async {
    final list = getProducts();
    final i = list.indexWhere((p) => p.id == product.id);
    if (i >= 0) {
      list[i] = product;
    } else {
      list.add(product);
    }
    await saveProducts(list);
  }

  Future<void> deleteProduct(String id) async {
    final list = getProducts()..removeWhere((p) => p.id == id);
    await saveProducts(list);
  }

  Future<void> saveCategories(List<MockProductCategory> categories) async {
    _categories = List<MockProductCategory>.from(categories);
    await _saveList(
      _kCategories,
      _categories!
          .map(
            (c) => {
              'id': c.id,
              'nameAr': c.nameAr,
              'nameEn': c.nameEn,
              'imageUrl': c.imageUrl,
              'subcategories': c.subcategories,
            },
          )
          .toList(),
    );
  }

  Future<void> saveServices(List<AdminServiceItem> services) async {
    _services = List<AdminServiceItem>.from(services);
    await _saveList(_kServices, _services!);
  }

  Future<void> saveAds(List<AdminAdItem> ads) async {
    _ads = List<AdminAdItem>.from(ads);
    await _saveList(_kAds, _ads!);
  }

  Future<void> saveSettings(AdminSettings settings) async {
    _settings = settings;
    await _prefs?.setString(_kSettings, jsonEncode(settings.toJson()));
    _bumpRevision();
  }

  int get userCount => 1284;

  List<AdminServiceItem> _defaultServices() => mockServiceCategories
      .take(6)
      .map(
        (c) => AdminServiceItem(
          id: 'svc-${c.id}',
          nameAr: c.nameAr,
          nameEn: c.nameEn,
          categorySlug: c.slug,
          price: 120.0 + c.serviceCount,
          descriptionAr: 'خدمة ${c.nameAr} مع فنيين معتمدين.',
          imageUrl: 'https://picsum.photos/400/300?random=${c.id}',
          durationMin: 90,
          rating: 4.6,
        ),
      )
      .toList();

  List<AdminAdItem> _defaultAds() => mockAds
      .map(
        (a) => AdminAdItem(
          id: a.id,
          title: a.title,
          slug: a.slug,
          price: a.price,
          city: a.city,
          imageUrl: a.mainImageUrl,
          status: 'approved',
          descriptionAr: a.description ?? '',
        ),
      )
      .toList();

  AdModel _adminAdToModel(AdminAdItem a) => AdModel(
        id: a.id,
        slug: a.slug,
        title: a.title,
        description: a.descriptionAr,
        price: a.price,
        city: a.city,
        categoryId: 'general',
        categorySlug: 'general',
        imageUrls: [a.imageUrl],
        createdAt: DateTime.now(),
      );

  ServiceDetailModel _adminServiceToModel(AdminServiceItem s) =>
      ServiceDetailModel(
        id: s.id,
        slug: s.id,
        nameAr: s.nameAr,
        nameEn: s.nameEn,
        descriptionAr: s.descriptionAr,
        basePrice: s.price,
        imageUrl: s.imageUrl,
        rating: s.rating,
        categorySlug: s.categorySlug,
        estimatedDurationMin: s.durationMin,
      );

  /// Classified ads for app screens — approved admin ads, fallback to mock.
  List<AdModel> getClassifiedAds() {
    final ads = getAds()
        .where((a) => a.status == 'approved')
        .map(_adminAdToModel)
        .toList();
    return ads.isEmpty ? mockAds : ads;
  }

  /// Home services for app screens — active admin services, fallback to mock.
  List<ServiceDetailModel> getServiceDetails({String? categorySlug}) {
    final services = getServices()
        .where((s) => s.isActive)
        .map(_adminServiceToModel)
        .toList();

    List<ServiceDetailModel> fallback() => mockServiceCategories
        .map((c) => mockServiceDetail(c.slug))
        .toList();

    final list = services.isEmpty ? fallback() : services;

    if (categorySlug == null || categorySlug.isEmpty) return list;
    return list
        .where(
          (s) => s.categorySlug == categorySlug || s.slug == categorySlug,
        )
        .toList();
  }
}
