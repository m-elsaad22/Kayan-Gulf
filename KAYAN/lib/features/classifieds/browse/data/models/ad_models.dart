// ============================================================
// KAYAN — Classifieds Data Models
// lib/features/classifieds/browse/data/models/ad_models.dart
// ============================================================

// ── Ad Category ───────────────────────────────────────────────
class AdCategory {
  final String id, slug, nameAr, nameEn, emoji;
  final int    adCount;
  const AdCategory({
    required this.id, required this.slug,
    required this.nameAr, required this.nameEn,
    required this.emoji, this.adCount = 0,
  });
}

// ── Ad Condition ──────────────────────────────────────────────
enum AdCondition { newItem, likeNew, good, acceptable, forParts }

extension AdConditionX on AdCondition {
  String labelAr() => switch (this) {
    AdCondition.newItem    => 'جديد',
    AdCondition.likeNew    => 'شبه جديد',
    AdCondition.good       => 'جيد',
    AdCondition.acceptable => 'مقبول',
    AdCondition.forParts   => 'للقطع',
  };
  String labelEn() => switch (this) {
    AdCondition.newItem    => 'New',
    AdCondition.likeNew    => 'Like New',
    AdCondition.good       => 'Good',
    AdCondition.acceptable => 'Acceptable',
    AdCondition.forParts   => 'For Parts',
  };
}

// ── Ad Seller ─────────────────────────────────────────────────
class AdSeller {
  final String  id, name;
  final String? avatarUrl;
  final int     totalAds, memberDays;
  final double  rating;
  final bool    isVerified;
  const AdSeller({
    required this.id, required this.name,
    this.avatarUrl,
    this.totalAds = 0, this.memberDays = 0,
    this.rating = 0, this.isVerified = false,
  });
}

// ── Ad Model (list card) ──────────────────────────────────────
class AdModel {
  final String      id, slug, title;
  final String?     description;
  final double?     price;
  final bool        isFree, isNegotiable;
  final String      city, district;
  final String      categoryId, categorySlug;
  final String?     categoryNameAr, categoryNameEn;
  final AdCondition condition;
  final List<String> imageUrls;
  final DateTime    createdAt;
  final int         viewCount, favoriteCount;
  final bool        isBoosted, isFeatured;
  final AdSeller?   seller;
  final bool        isFavorited;

  const AdModel({
    required this.id, required this.slug, required this.title,
    this.description,
    this.price, this.isFree = false, this.isNegotiable = false,
    required this.city, this.district = '',
    required this.categoryId, required this.categorySlug,
    this.categoryNameAr, this.categoryNameEn,
    this.condition      = AdCondition.good,
    this.imageUrls      = const [],
    required this.createdAt,
    this.viewCount      = 0, this.favoriteCount = 0,
    this.isBoosted      = false, this.isFeatured = false,
    this.seller, this.isFavorited = false,
  });

  String timeAgo(bool ar) {
    final d = DateTime.now().difference(createdAt);
    if (ar) {
      if (d.inDays > 30)  return 'منذ ${d.inDays ~/ 30} شهر';
      if (d.inDays > 0)   return 'منذ ${d.inDays} ${d.inDays == 1 ? "يوم" : "أيام"}';
      if (d.inHours > 0)  return 'منذ ${d.inHours} ساعة';
      if (d.inMinutes > 0)return 'منذ ${d.inMinutes} دقيقة';
      return 'الآن';
    }
    if (d.inDays > 30)  return '${d.inDays ~/ 30}mo ago';
    if (d.inDays > 0)   return '${d.inDays}d ago';
    if (d.inHours > 0)  return '${d.inHours}h ago';
    return 'Just now';
  }

  String get mainImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';
  bool   get hasImages    => imageUrls.isNotEmpty;
}

// ── My Ad (owned by user) ─────────────────────────────────────
class MyAdModel {
  final AdModel ad;
  final String  status;     // ACTIVE, PAUSED, SOLD, EXPIRED
  final int     daysLeft;
  final bool    canBoost;

  const MyAdModel({
    required this.ad, this.status = 'ACTIVE',
    this.daysLeft = 0, this.canBoost = true,
  });

  String statusLabelAr() => switch (status) {
    'ACTIVE'  => 'نشط',
    'PAUSED'  => 'موقوف',
    'SOLD'    => 'مُباع',
    'EXPIRED' => 'منتهي',
    _         => status,
  };
}

// ──────────────────────────────────────────────────────────────
// MOCK DATA
// ──────────────────────────────────────────────────────────────

final mockAdCategories = [
  const AdCategory(id:'a1', slug:'electronics', nameAr:'إلكترونيات',  nameEn:'Electronics',  emoji:'📱', adCount:4821),
  const AdCategory(id:'a2', slug:'vehicles',    nameAr:'سيارات',       nameEn:'Vehicles',     emoji:'🚗', adCount:2340),
  const AdCategory(id:'a3', slug:'realestate',  nameAr:'عقارات',       nameEn:'Real Estate',  emoji:'🏠', adCount:1820),
  const AdCategory(id:'a4', slug:'furniture',   nameAr:'أثاث',         nameEn:'Furniture',    emoji:'🛋️', adCount:1240),
  const AdCategory(id:'a5', slug:'fashion',     nameAr:'ملابس',        nameEn:'Fashion',      emoji:'👗', adCount:980),
  const AdCategory(id:'a6', slug:'jobs',        nameAr:'وظائف',        nameEn:'Jobs',         emoji:'💼', adCount:760),
  const AdCategory(id:'a7', slug:'sports',      nameAr:'رياضة',        nameEn:'Sports',       emoji:'⚽', adCount:540),
  const AdCategory(id:'a8', slug:'kids',        nameAr:'أطفال',        nameEn:'Kids',         emoji:'🧸', adCount:480),
  const AdCategory(id:'a9', slug:'books',       nameAr:'كتب',          nameEn:'Books',        emoji:'📚', adCount:320),
  const AdCategory(id:'a10',slug:'other',       nameAr:'أخرى',         nameEn:'Other',        emoji:'📦', adCount:210),
];

const _seller1 = AdSeller(id:'s1', name:'أحمد محمد', totalAds:12, memberDays:180, rating:4.8, isVerified:true);
const _seller2 = AdSeller(id:'s2', name:'فاطمة العلي', totalAds:5, memberDays:45, rating:4.5, isVerified:false);
const _seller3 = AdSeller(id:'s3', name:'خالد الرشيد', totalAds:28, memberDays:365, rating:4.9, isVerified:true);

final mockAds = [
  AdModel(id:'ad1', slug:'iphone-15-pro-max', title:'آيفون 15 برو ماكس 256GB - أسود تيتانيوم',
    description:'جهاز بحالة ممتازة، استخدام شخصي لمدة 3 أشهر فقط. يأتي مع الكرتونة الأصلية وجميع الملحقات. البطارية 97%. سعر غير قابل للتفاوض.',
    price:3200, isNegotiable:false, city:'الرياض', district:'حي النخيل',
    categoryId:'a1', categorySlug:'electronics', categoryNameAr:'إلكترونيات',
    condition:AdCondition.likeNew, isBoosted:true, isFeatured:true,
    imageUrls:['https://picsum.photos/600/500?random=101','https://picsum.photos/600/500?random=102','https://picsum.photos/600/500?random=103'],
    createdAt:DateTime.now().subtract(const Duration(hours:2)), viewCount:342, favoriteCount:28, seller:_seller1),

  AdModel(id:'ad2', slug:'camry-2022', title:'تويوتا كامري 2022 XLE - فل كامل',
    description:'سيارة بحالة ممتازة، وارد اليابان، ماشية 45,000 كم فقط. السيارة نظيفة جداً ولا تحتاج أي إصلاحات. جميع الخدمات محدثة.',
    price:95000, isNegotiable:true, city:'جدة', district:'حي الروضة',
    categoryId:'a2', categorySlug:'vehicles', categoryNameAr:'سيارات',
    condition:AdCondition.likeNew, isBoosted:false,
    imageUrls:['https://picsum.photos/600/500?random=104','https://picsum.photos/600/500?random=105'],
    createdAt:DateTime.now().subtract(const Duration(days:1)), viewCount:589, favoriteCount:45, seller:_seller3),

  AdModel(id:'ad3', slug:'شقة-للايجار-العليا', title:'شقة للإيجار - حي العليا - 3 غرف',
    description:'شقة فاخرة في حي العليا الراقي. 3 غرف نوم، 2 دورة مياه، صالة كبيرة، مطبخ مجهز. الدور الثالث مع مصعد. قريبة من الخدمات.',
    price:3500, isNegotiable:false, city:'الرياض', district:'حي العليا',
    categoryId:'a3', categorySlug:'realestate', categoryNameAr:'عقارات',
    condition:AdCondition.newItem,
    imageUrls:['https://picsum.photos/600/500?random=106','https://picsum.photos/600/500?random=107','https://picsum.photos/600/500?random=108'],
    createdAt:DateTime.now().subtract(const Duration(hours:5)), viewCount:210, favoriteCount:18, seller:_seller2),

  AdModel(id:'ad4', slug:'macbook-pro-m3', title:'MacBook Pro M3 Pro 14" - فضي',
    description:'لابتوب بحالة ممتازة، استخدام خفيف لمدة شهرين. مواصفات: M3 Pro, 18GB RAM, 512GB SSD. يأتي مع الشاحن الأصلي.',
    price:4800, isNegotiable:true, city:'الرياض', district:'حي اليرموك',
    categoryId:'a1', categorySlug:'electronics', categoryNameAr:'إلكترونيات',
    condition:AdCondition.likeNew, isBoosted:true,
    imageUrls:['https://picsum.photos/600/500?random=109','https://picsum.photos/600/500?random=110'],
    createdAt:DateTime.now().subtract(const Duration(hours:8)), viewCount:198, favoriteCount:31, seller:_seller1),

  AdModel(id:'ad5', slug:'playstation-5-slim', title:'بلايستيشن 5 Slim - مع دراعتين',
    description:'جهاز جديد بالكرتونة، اشتريته قبل أسبوع ولم أستخدمه. يأتي مع 2 دراعة وكابل HDMI 2.1.',
    price:1650, isFree:false, isNegotiable:false, city:'دبي', district:'الخليج التجاري',
    categoryId:'a1', categorySlug:'electronics', categoryNameAr:'إلكترونيات',
    condition:AdCondition.newItem,
    imageUrls:['https://picsum.photos/600/500?random=111'],
    createdAt:DateTime.now().subtract(const Duration(days:2)), viewCount:422, favoriteCount:67, seller:_seller3),

  AdModel(id:'ad6', slug:'كتب-هندسة-مدنية', title:'كتب هندسة مدنية - دفعة كاملة',
    description:'مجموعة كاملة من كتب الهندسة المدنية للمستوى الجامعي. الكتب بحالة جيدة ومعظمها بدون تظليل.',
    price:null, isFree:true, city:'الرياض', district:'حي الجامعة',
    categoryId:'a9', categorySlug:'books', categoryNameAr:'كتب',
    condition:AdCondition.good,
    imageUrls:['https://picsum.photos/600/500?random=112'],
    createdAt:DateTime.now().subtract(const Duration(days:3)), viewCount:87, favoriteCount:9, seller:_seller2),

  AdModel(id:'ad7', slug:'samsung-55-tv', title:'شاشة Samsung QLED 55 بوصة 4K',
    description:'شاشة بحالة ممتازة، نادراً ما استخدمت. جميع الكابلات والريموت موجودة.',
    price:1800, isNegotiable:true, city:'أبوظبي', district:'منطقة الكورنيش',
    categoryId:'a1', categorySlug:'electronics', categoryNameAr:'إلكترونيات',
    condition:AdCondition.good,
    imageUrls:['https://picsum.photos/600/500?random=113','https://picsum.photos/600/500?random=114'],
    createdAt:DateTime.now().subtract(const Duration(days:1,hours:3)), viewCount:156, favoriteCount:22, seller:_seller3),

  AdModel(id:'ad8', slug:'دراجة-هوائية-تريك', title:'دراجة هوائية Trek FX3 - 2023',
    description:'دراجة رياضية احترافية نادراً ما استخدمتها. الإطارات والفرامل بحالة ممتازة. مناسبة للمسافات الطويلة.',
    price:1200, isNegotiable:true, city:'الرياض', district:'حي الملقا',
    categoryId:'a7', categorySlug:'sports', categoryNameAr:'رياضة',
    condition:AdCondition.likeNew,
    imageUrls:['https://picsum.photos/600/500?random=115'],
    createdAt:DateTime.now().subtract(const Duration(hours:12)), viewCount:94, favoriteCount:11, seller:_seller1),
];

// Mock my ads (user's own)
final mockMyAds = [
  MyAdModel(ad: mockAds[0], status: 'ACTIVE',  daysLeft: 28, canBoost: true),
  MyAdModel(ad: mockAds[3], status: 'ACTIVE',  daysLeft: 12, canBoost: false),
  MyAdModel(ad: mockAds[7], status: 'PAUSED',  daysLeft: 20, canBoost: true),
  MyAdModel(ad: mockAds[5].copyWith(status: 'SOLD'), status: 'SOLD', daysLeft: 0, canBoost: false),
];

// Extension for easy status override in mock
extension AdModelX on AdModel {
  AdModel copyWith({String? status}) => AdModel(
    id: id, slug: slug, title: title, description: description,
    price: price, isFree: isFree, isNegotiable: isNegotiable,
    city: city, district: district,
    categoryId: categoryId, categorySlug: categorySlug,
    categoryNameAr: categoryNameAr, categoryNameEn: categoryNameEn,
    condition: condition, imageUrls: imageUrls, createdAt: createdAt,
    viewCount: viewCount, favoriteCount: favoriteCount,
    isBoosted: isBoosted, isFeatured: isFeatured,
    seller: seller, isFavorited: isFavorited,
  );
}
