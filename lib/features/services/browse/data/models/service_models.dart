// KAYAN — Services Data Models
import 'dart:math' as math;

class ServiceCategory { final String id,slug,nameAr,nameEn,emoji,colorHex; final int serviceCount; final bool isEmergency;
  const ServiceCategory({required this.id,required this.slug,required this.nameAr,required this.nameEn,required this.emoji,required this.colorHex,this.serviceCount=0,this.isEmergency=false});
  factory ServiceCategory.fromJson(Map<String,dynamic> j)=>ServiceCategory(
    id:j['id'] as String,
    slug:j['slug'] as String,
    nameAr:j['nameAr'] as String,
    nameEn:j['name'] as String? ?? j['nameEn'] as String? ?? '',
    emoji:j['emoji'] as String? ?? '🔧',
    colorHex:j['colorHex'] as String? ?? '#3B82F6',
    serviceCount:j['serviceCount'] as int? ?? 0,
    isEmergency:j['isEmergency'] as bool? ?? false,
  ); }

class TechnicianModel { final String id,name; final String? avatarUrl; final double rating; final int reviewCount,completedJobs; final bool isVerified,isAvailable; final List<String> specializations;
  const TechnicianModel({required this.id,required this.name,this.avatarUrl,this.rating=0,this.reviewCount=0,this.completedJobs=0,this.isVerified=true,this.isAvailable=true,this.specializations=const[]}); }

class ServiceFeature { final String icon,textAr,textEn; const ServiceFeature({required this.icon,required this.textAr,required this.textEn}); }

class ServiceReview { final String id; final String? userName,comment; final double rating; final DateTime createdAt; final bool isVerified;
  const ServiceReview({required this.id,this.userName,this.comment,required this.rating,required this.createdAt,this.isVerified=false});
  String timeAgo(bool ar) { final d=DateTime.now().difference(createdAt); if(ar){if(d.inDays>30)return'منذ ${d.inDays~/30} شهر';if(d.inDays>0)return'منذ ${d.inDays} يوم';return'منذ ${d.inHours} ساعة';} if(d.inDays>30)return'${d.inDays~/30}mo ago';if(d.inDays>0)return'${d.inDays}d ago';return'${d.inHours}h ago';} }

class ServiceFaq { final String questionAr,questionEn,answerAr,answerEn; const ServiceFaq({required this.questionAr,required this.questionEn,required this.answerAr,required this.answerEn}); }

class ServiceDetailModel { final String id,slug,nameAr,nameEn; final String? descriptionAr,descriptionEn,imageUrl,categoryNameAr,categorySlug; final List<String> galleryUrls; final double basePrice,rating; final double? discountedPrice; final String pricingType,currency; final int totalRatings,totalBookings,estimatedDurationMin; final bool isEmergency,isAvailable; final List<TechnicianModel> technicians; final List<ServiceFeature> features; final List<ServiceReview> reviews; final List<ServiceFaq> faqs; final List<String> whatToExpect;
  const ServiceDetailModel({required this.id,required this.slug,required this.nameAr,required this.nameEn,this.descriptionAr,this.descriptionEn,required this.basePrice,this.discountedPrice,this.pricingType='FIXED',this.currency='SAR',this.imageUrl,this.galleryUrls=const[],this.rating=0,this.totalRatings=0,this.totalBookings=0,this.isEmergency=false,this.isAvailable=true,this.categoryNameAr,this.categorySlug,this.estimatedDurationMin=60,this.technicians=const[],this.features=const[],this.reviews=const[],this.faqs=const[],this.whatToExpect=const[]});
  bool get hasDiscount=>discountedPrice!=null&&discountedPrice!<basePrice; double get finalPrice=>discountedPrice??basePrice;
  factory ServiceDetailModel.fromJson(Map<String,dynamic> j)=>ServiceDetailModel(
    id:j['id'] as String,
    slug:j['slug'] as String,
    nameAr:j['nameAr'] as String,
    nameEn:j['name'] as String? ?? j['nameEn'] as String? ?? '',
    descriptionAr:j['descriptionAr'] as String?,
    descriptionEn:j['descriptionEn'] as String?,
    basePrice:(j['basePrice'] as num?)?.toDouble() ?? (j['price'] as num).toDouble(),
    discountedPrice:(j['discountedPrice'] as num?)?.toDouble(),
    pricingType:j['pricingType'] as String? ?? 'FIXED',
    currency:j['currency'] as String? ?? 'SAR',
    imageUrl:j['imageUrl'] as String?,
    galleryUrls:(j['galleryUrls'] as List?)?.cast<String>() ?? [],
    rating:(j['rating'] as num?)?.toDouble() ?? 0,
    totalRatings:j['totalRatings'] as int? ?? 0,
    totalBookings:j['totalBookings'] as int? ?? 0,
    isEmergency:j['isEmergency'] as bool? ?? false,
    isAvailable:j['isAvailable'] as bool? ?? true,
    categoryNameAr:j['categoryNameAr'] as String?,
    categorySlug:j['categorySlug'] as String?,
    estimatedDurationMin:j['estimatedDurationMin'] as int? ?? 60,
  ); }

class TimeSlot { final String id; final DateTime startTime,endTime; final bool isAvailable;
  const TimeSlot({required this.id,required this.startTime,required this.endTime,this.isAvailable=true});
  String get label{final h=startTime.hour;final m=startTime.minute.toString().padLeft(2,'0');final p=h<12?'ص':'م';final dh=h>12?h-12:(h==0?12:h);return'$dh:$m $p';} }

class BookingModel { final String id,bookingNumber,serviceNameAr,serviceNameEn,serviceId,status,addressLine; final double price; final String currency; final DateTime scheduledAt; final TechnicianModel? technician; final String? notes;
  const BookingModel({required this.id,required this.bookingNumber,required this.serviceNameAr,required this.serviceNameEn,required this.serviceId,required this.price,this.currency='SAR',required this.scheduledAt,this.status='CONFIRMED',this.technician,required this.addressLine,this.notes});
  String statusAr()=>switch(status){'PENDING'=>'قيد الانتظار','CONFIRMED'=>'مؤكد','IN_PROGRESS'=>'جاري التنفيذ','COMPLETED'=>'مكتمل','CANCELLED'=>'ملغي',_=>status};
  factory BookingModel.fromJson(Map<String,dynamic> j)=>BookingModel(
    id:j['id'] as String,
    bookingNumber:j['bookingNumber'] as String,
    serviceNameAr:j['serviceNameAr'] as String,
    serviceNameEn:j['serviceNameEn'] as String? ?? '',
    serviceId:j['serviceId'] as String,
    price:(j['price'] as num).toDouble(),
    currency:j['currency'] as String? ?? 'SAR',
    scheduledAt:DateTime.tryParse(j['scheduledAt'] as String? ?? '') ?? DateTime.now(),
    status:j['status'] as String? ?? 'CONFIRMED',
    addressLine:j['addressLine'] as String? ?? '',
    notes:j['notes'] as String?,
  ); }

class TechPosition { final double lat,lng,bearing; final int etaMinutes; const TechPosition({required this.lat,required this.lng,this.bearing=0,this.etaMinutes=0}); }

final mockServiceCategories=[
  const ServiceCategory(id:'c1',slug:'ac',nameAr:'تكييف',nameEn:'AC & Cooling',emoji:'❄️',colorHex:'#06B6D4',serviceCount:48),
  const ServiceCategory(id:'c2',slug:'plumbing',nameAr:'سباكة',nameEn:'Plumbing',emoji:'🔧',colorHex:'#3B82F6',serviceCount:32),
  const ServiceCategory(id:'c3',slug:'electrical',nameAr:'كهرباء',nameEn:'Electrical',emoji:'⚡',colorHex:'#F59E0B',serviceCount:28,isEmergency:true),
  const ServiceCategory(id:'c4',slug:'cleaning',nameAr:'تنظيف',nameEn:'Cleaning',emoji:'🧹',colorHex:'#10B981',serviceCount:64),
  const ServiceCategory(id:'c5',slug:'painting',nameAr:'دهان',nameEn:'Painting',emoji:'🎨',colorHex:'#8B5CF6',serviceCount:22),
  const ServiceCategory(id:'c6',slug:'movers',nameAr:'نقل عفش',nameEn:'Moving',emoji:'📦',colorHex:'#F97316',serviceCount:18),
  const ServiceCategory(id:'c7',slug:'carpentry',nameAr:'نجارة',nameEn:'Carpentry',emoji:'🪚',colorHex:'#92400E',serviceCount:14),
  const ServiceCategory(id:'c8',slug:'pest',nameAr:'مكافحة حشرات',nameEn:'Pest Control',emoji:'🐛',colorHex:'#EF4444',serviceCount:20),
  const ServiceCategory(id:'c9',slug:'security',nameAr:'كاميرات',nameEn:'Security Cams',emoji:'📷',colorHex:'#6366F1',serviceCount:16),
  const ServiceCategory(id:'c10',slug:'appliance',nameAr:'صيانة أجهزة',nameEn:'Appliance Repair',emoji:'🔌',colorHex:'#64748B',serviceCount:35),
];

// ─────────────────────────────────────────────────────────────
// Mock service catalogue — keyed by slug / slug prefix.
// Each entry has distinct name, price, duration, and features.
// ─────────────────────────────────────────────────────────────
const _svcCatalog = <String, _SvcData>{
  // ── A/C ──────────────────────────────────────────────────
  'ac':       _SvcData(id:'svc-ac',  nameAr:'تركيب وصيانة تكييف سبليت',  nameEn:'Split AC Installation & Service',  catAr:'تكييف',    catSlug:'ac',       price:150,disc:120,dur:120,img:90,  descAr:'تركيب وصيانة تكييف سبليت بجميع الأحجام والماركات. ضمان سنة كاملة.', descEn:'Split AC install & service for all brands. 1-year warranty.',  f1Ar:'ضمان سنة',       f1En:'1-year warranty', f2Ar:'أدوات مشمولة', f2En:'Tools included'),
  'service-0':_SvcData(id:'svc-ac0', nameAr:'صيانة وتنظيف تكييف',         nameEn:'AC Service & Cleaning',            catAr:'تكييف',    catSlug:'ac',       price:120,disc:99, dur:90, img:91,  descAr:'تنظيف شامل لفلاتر التكييف وصيانة دورية كاملة لضمان أداء مثالي.',   descEn:'Full AC filter cleaning and periodic maintenance for optimal performance.',f1Ar:'غسيل الفلاتر',   f1En:'Filter wash',     f2Ar:'فحص الغاز',    f2En:'Gas check'),
  // ── Plumbing ─────────────────────────────────────────────
  'plumbing': _SvcData(id:'svc-pl',  nameAr:'إصلاح تسربات وسباكة',       nameEn:'Plumbing & Leak Repair',           catAr:'سباكة',    catSlug:'plumbing', price:90, disc:75, dur:60, img:92,  descAr:'إصلاح تسربات المياه والصرف وتركيب الصنابير. فنيون معتمدون على مدار الساعة.',descEn:'Water leak repair, drainage, and faucet installation by certified plumbers.',f1Ar:'متاح ٢٤/٧',      f1En:'24/7 available',  f2Ar:'ضمان شهر',     f2En:'30-day warranty'),
  'service-1':_SvcData(id:'svc-pl1', nameAr:'تسليك مجاري',                nameEn:'Drain Unclogging',                 catAr:'سباكة',    catSlug:'plumbing', price:80, disc:65, dur:45, img:93,  descAr:'تسليك مجاري المطبخ والحمام بأحدث المعدات الضاغطة.',               descEn:'Kitchen and bathroom drain unclogging with high-pressure equipment.',     f1Ar:'معدات حديثة',    f1En:'Modern equipment',f2Ar:'خلال ساعة',    f2En:'Within 1 hour'),
  // ── Cleaning ─────────────────────────────────────────────
  'cleaning': _SvcData(id:'svc-cl',  nameAr:'تنظيف منزلي شامل',          nameEn:'Full Home Deep Cleaning',          catAr:'تنظيف',   catSlug:'cleaning', price:200,disc:160,dur:180,img:94,  descAr:'تنظيف شامل للمنزل من الأرضيات والجدران والمطبخ والحمامات بمنتجات آمنة.',descEn:'Complete home cleaning including floors, walls, kitchen, and bathrooms.', f1Ar:'منتجات آمنة',    f1En:'Safe products',   f2Ar:'فريق متخصص',  f2En:'Dedicated team'),
  'service-2':_SvcData(id:'svc-cl2', nameAr:'تنظيف شامل',                 nameEn:'Deep Cleaning',                    catAr:'تنظيف',   catSlug:'cleaning', price:200,disc:170,dur:180,img:95,  descAr:'تنظيف عميق شامل لجميع أركان المنزل بأعلى معايير النظافة.',          descEn:'Comprehensive deep cleaning for every corner of your home.',             f1Ar:'٣ ساعات عمل',    f1En:'3 hrs service',   f2Ar:'ضمان الجودة',  f2En:'Quality guarantee'),
  // ── Carpentry / Furniture ────────────────────────────────
  'carpentry':_SvcData(id:'svc-cp',  nameAr:'نجارة وتركيب أثاث',         nameEn:'Carpentry & Furniture Assembly',   catAr:'نجارة',    catSlug:'carpentry',price:150,disc:130,dur:120,img:96,  descAr:'تركيب جميع أنواع الأثاث والخزائن والأبواب بيد فنيين متخصصين.',      descEn:'Assembly of all furniture types, wardrobes, and doors by specialists.',  f1Ar:'خبرة ١٠ سنوات', f1En:'10 yrs experience',f2Ar:'دقة عالية',   f2En:'High precision'),
  'service-3':_SvcData(id:'svc-cp3', nameAr:'تركيب أثاث',                 nameEn:'Furniture Assembly',               catAr:'نجارة',    catSlug:'carpentry',price:150,disc:120,dur:90, img:97,  descAr:'تركيب طاقم غرف النوم والمعيشة والمطبخ بسرعة واحترافية.',           descEn:'Fast and professional assembly of bedroom, living, and kitchen sets.',   f1Ar:'يصل في ٩٠ دق',  f1En:'90-min arrival',  f2Ar:'خدمة منزلية', f2En:'Home service'),
  // ── Electrical ───────────────────────────────────────────
  'electrical':_SvcData(id:'svc-el', nameAr:'كهرباء وإصلاح أعطال',       nameEn:'Electrical & Fault Repair',        catAr:'كهرباء',   catSlug:'electrical',price:100,disc:85,dur:60,img:98, descAr:'إصلاح جميع أعطال الكهرباء المنزلية وتركيب الإضاءة والمفاتيح.',     descEn:'Repair of all home electrical faults, lighting, and switch installation.',f1Ar:'كهربائي معتمد',  f1En:'Certified electrician',f2Ar:'متاح ٢٤/٧',f2En:'24/7 available'),
  // ── Painting ────────────────────────────────────────────
  'painting': _SvcData(id:'svc-pt',  nameAr:'دهان وطلاء جدران',          nameEn:'Painting & Wall Coating',          catAr:'دهان',     catSlug:'painting', price:300,disc:250,dur:240,img:99, descAr:'دهان جدران المنازل والشركات بأحدث الألوان وأعلى جودة.',            descEn:'Interior and exterior wall painting with premium paints.',               f1Ar:'ألوان متنوعة',   f1En:'Wide color range', f2Ar:'ضمان ٦ أشهر',  f2En:'6-month warranty'),
  // ── Movers ──────────────────────────────────────────────
  'movers':   _SvcData(id:'svc-mv',  nameAr:'نقل عفش',                   nameEn:'Home Moving Service',              catAr:'نقل عفش',  catSlug:'movers',   price:400,disc:350,dur:300,img:100,descAr:'نقل عفش منظم وآمن مع فريق متخصص وسيارات مجهزة لجميع مناطق المملكة.',descEn:'Safe and organized home moving with equipped trucks across Saudi Arabia.', f1Ar:'تغليف مشمول',    f1En:'Packing included', f2Ar:'تأمين كامل',   f2En:'Full insurance'),
  // ── Pest Control ─────────────────────────────────────────
  'pest':     _SvcData(id:'svc-pc',  nameAr:'مكافحة حشرات',              nameEn:'Pest Control',                     catAr:'حشرات',    catSlug:'pest',     price:200,disc:170,dur:120,img:101,descAr:'إبادة جميع أنواع الحشرات والقوارض بمبيدات آمنة على الأطفال والحيوانات.',descEn:'Elimination of all insects and rodents with child and pet-safe pesticides.',f1Ar:'مواد آمنة',      f1En:'Safe chemicals',  f2Ar:'ضمان ٣ أشهر',  f2En:'3-month guarantee'),
  // ── Security Cameras ─────────────────────────────────────
  'security': _SvcData(id:'svc-sc',  nameAr:'تركيب كاميرات مراقبة',      nameEn:'Security Camera Installation',     catAr:'كاميرات',  catSlug:'security', price:350,disc:300,dur:150,img:102,descAr:'تركيب وبرمجة كاميرات المراقبة الداخلية والخارجية مع ربطها بالهاتف.', descEn:'Indoor and outdoor security camera installation with mobile app linkage.',f1Ar:'دعم فني مجاني',  f1En:'Free tech support',f2Ar:'ربط بالهاتف',  f2En:'Mobile linked'),
  // ── Appliance Repair ─────────────────────────────────────
  'appliance':_SvcData(id:'svc-ap',  nameAr:'صيانة أجهزة كهربائية',      nameEn:'Appliance Repair',                 catAr:'صيانة',    catSlug:'appliance',price:120,disc:100,dur:90, img:103,descAr:'إصلاح وصيانة الغسالات والثلاجات والأفران والأجهزة المنزلية بجميع أنواعها.',descEn:'Repair of washing machines, refrigerators, ovens, and all home appliances.',f1Ar:'جميع الماركات',  f1En:'All brands',      f2Ar:'قطع أصلية',    f2En:'Genuine parts'),
};

class _SvcData {
  final String id,nameAr,nameEn,catAr,catSlug,descAr,descEn,f1Ar,f1En,f2Ar,f2En;
  final int price,disc,dur,img;
  const _SvcData({required this.id,required this.nameAr,required this.nameEn,required this.catAr,required this.catSlug,required this.price,required this.disc,required this.dur,required this.img,required this.descAr,required this.descEn,required this.f1Ar,required this.f1En,required this.f2Ar,required this.f2En});
}

ServiceDetailModel mockServiceDetail(String slug) {
  // Exact slug match first, then prefix match (e.g. 'ac-unit-repair' → 'ac')
  final d = _svcCatalog[slug] ??
      _svcCatalog.entries.where((e) => slug.startsWith(e.key)).map((e) => e.value).firstOrNull ??
      _svcCatalog['ac']!;
  return ServiceDetailModel(
    id: d.id, slug: slug,
    nameAr: d.nameAr, nameEn: d.nameEn,
    descriptionAr: d.descAr, descriptionEn: d.descEn,
    basePrice: d.price.toDouble(), discountedPrice: d.disc.toDouble(),
    imageUrl: 'https://picsum.photos/600/400?random=${d.img}',
    galleryUrls: ['https://picsum.photos/600/400?random=${d.img}','https://picsum.photos/600/400?random=${d.img+1}','https://picsum.photos/600/400?random=${d.img+2}'],
    rating: 4.7, totalRatings: 180 + d.img, totalBookings: 500 + d.img * 10,
    categoryNameAr: d.catAr, categorySlug: d.catSlug,
    estimatedDurationMin: d.dur,
    features: [
      ServiceFeature(icon:'✅',textAr:'فنيون معتمدون',textEn:'Certified technicians'),
      ServiceFeature(icon:'🏷️',textAr:'سعر ثابت',textEn:'Fixed price'),
      ServiceFeature(icon:d.f1Ar=='ضمان سنة'?'🛡️':'⭐',textAr:d.f1Ar,textEn:d.f1En),
      ServiceFeature(icon:'🔧',textAr:d.f2Ar,textEn:d.f2En),
      ServiceFeature(icon:'📞',textAr:'دعم ما بعد الخدمة',textEn:'Post-service support'),
    ],
    whatToExpect: ['سيتواصل الفني معك قبل الوصول بـ 30 دقيقة','تقييم الموقع والبدء بالعمل','إنجاز الخدمة حسب المواصفات المتفق عليها','اختبار النتيجة والتأكد من رضاك','تقرير العمل المنجز'],
    technicians: const [TechnicianModel(id:'t1',name:'محمد الغامدي',rating:4.9,reviewCount:128,completedJobs:340),TechnicianModel(id:'t2',name:'علي الشمري',rating:4.7,reviewCount:89,completedJobs:210)],
    reviews: [ServiceReview(id:'r1',userName:'فهد',rating:5,isVerified:true,comment:'خدمة ممتازة، الفني محترف وسريع.',createdAt:DateTime.now().subtract(const Duration(days:2))),ServiceReview(id:'r2',userName:'سارة',rating:5,isVerified:true,comment:'تم الإنجاز بشكل احترافي والنتيجة رائعة.',createdAt:DateTime.now().subtract(const Duration(days:7))),ServiceReview(id:'r3',userName:'خالد',rating:4,comment:'جيد جداً، أنصح به.',createdAt:DateTime.now().subtract(const Duration(days:14)))],
    faqs: const [ServiceFaq(questionAr:'هل السعر شامل جميع التكاليف؟',questionEn:'Does price include all costs?',answerAr:'نعم، السعر شامل العمالة والأدوات.',answerEn:'Yes, includes labor and materials.'),ServiceFaq(questionAr:'كيف يمكنني إلغاء الحجز؟',questionEn:'How to cancel?',answerAr:'يمكنك الإلغاء مجاناً قبل 24 ساعة من الموعد.',answerEn:'Free cancellation up to 24 hours before the appointment.')],
  );
}

List<TimeSlot> generateSlots(DateTime date){final rng=math.Random(date.day);final hours=[8,9,10,11,12,13,14,15,16,17,18];return hours.map((h){final s=DateTime(date.year,date.month,date.day,h);return TimeSlot(id:'${date.day}-$h',startTime:s,endTime:s.add(const Duration(hours:2)),isAvailable:rng.nextBool()||h%3!=0);}).toList();}

final mockBookings=[
  BookingModel(id:'b1',bookingNumber:'BK-5829401',serviceNameAr:'تركيب تكييف سبليت',serviceNameEn:'AC Install',serviceId:'svc-1',price:120,scheduledAt:DateTime.now().add(const Duration(days:1,hours:9)),status:'CONFIRMED',technician:const TechnicianModel(id:'t1',name:'محمد الغامدي',rating:4.9,reviewCount:128,completedJobs:340),addressLine:'حي النخيل، الرياض',notes:'غرفة النوم'),
  BookingModel(id:'b2',bookingNumber:'BK-4718390',serviceNameAr:'تنظيف شامل',serviceNameEn:'Deep Cleaning',serviceId:'svc-4',price:280,scheduledAt:DateTime.now().subtract(const Duration(days:3)),status:'COMPLETED',technician:const TechnicianModel(id:'t3',name:'عبدالله القحطاني',rating:4.6,reviewCount:64,completedJobs:180),addressLine:'حي العليا، الرياض'),
  BookingModel(id:'b3',bookingNumber:'BK-3607289',serviceNameAr:'إصلاح تسرب مياه',serviceNameEn:'Water Leak Repair',serviceId:'svc-2',price:90,scheduledAt:DateTime.now().subtract(const Duration(hours:2)),status:'IN_PROGRESS',technician:const TechnicianModel(id:'t2',name:'علي الشمري',rating:4.7,reviewCount:89,completedJobs:210),addressLine:'حي الروضة، جدة'),
];
