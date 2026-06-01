// KAYAN — Services Data Models
import 'dart:math' as math;

class ServiceCategory { final String id,slug,nameAr,nameEn,emoji,colorHex; final int serviceCount; final bool isEmergency;
  const ServiceCategory({required this.id,required this.slug,required this.nameAr,required this.nameEn,required this.emoji,required this.colorHex,this.serviceCount=0,this.isEmergency=false}); }

class TechnicianModel { final String id,name; final String? avatarUrl; final double rating; final int reviewCount,completedJobs; final bool isVerified,isAvailable; final List<String> specializations;
  const TechnicianModel({required this.id,required this.name,this.avatarUrl,this.rating=0,this.reviewCount=0,this.completedJobs=0,this.isVerified=true,this.isAvailable=true,this.specializations=const[]}); }

class ServiceFeature { final String icon,textAr,textEn; const ServiceFeature({required this.icon,required this.textAr,required this.textEn}); }

class ServiceReview { final String id; final String? userName,comment; final double rating; final DateTime createdAt; final bool isVerified;
  const ServiceReview({required this.id,this.userName,this.comment,required this.rating,required this.createdAt,this.isVerified=false});
  String timeAgo(bool ar) { final d=DateTime.now().difference(createdAt); if(ar){if(d.inDays>30)return'منذ ${d.inDays~/30} شهر';if(d.inDays>0)return'منذ ${d.inDays} يوم';return'منذ ${d.inHours} ساعة';} if(d.inDays>30)return'${d.inDays~/30}mo ago';if(d.inDays>0)return'${d.inDays}d ago';return'${d.inHours}h ago';} }

class ServiceFaq { final String questionAr,questionEn,answerAr,answerEn; const ServiceFaq({required this.questionAr,required this.questionEn,required this.answerAr,required this.answerEn}); }

class ServiceDetailModel { final String id,slug,nameAr,nameEn; final String? descriptionAr,descriptionEn,imageUrl,categoryNameAr,categorySlug; final List<String> galleryUrls; final double basePrice,rating; final double? discountedPrice; final String pricingType,currency; final int totalRatings,totalBookings,estimatedDurationMin; final bool isEmergency,isAvailable; final List<TechnicianModel> technicians; final List<ServiceFeature> features; final List<ServiceReview> reviews; final List<ServiceFaq> faqs; final List<String> whatToExpect;
  const ServiceDetailModel({required this.id,required this.slug,required this.nameAr,required this.nameEn,this.descriptionAr,this.descriptionEn,required this.basePrice,this.discountedPrice,this.pricingType='FIXED',this.currency='SAR',this.imageUrl,this.galleryUrls=const[],this.rating=0,this.totalRatings=0,this.totalBookings=0,this.isEmergency=false,this.isAvailable=true,this.categoryNameAr,this.categorySlug,this.estimatedDurationMin=60,this.technicians=const[],this.features=const[],this.reviews=const[],this.faqs=const[],this.whatToExpect=const[]});
  bool get hasDiscount=>discountedPrice!=null&&discountedPrice!<basePrice; double get finalPrice=>discountedPrice??basePrice; }

class TimeSlot { final String id; final DateTime startTime,endTime; final bool isAvailable;
  const TimeSlot({required this.id,required this.startTime,required this.endTime,this.isAvailable=true});
  String get label{final h=startTime.hour;final m=startTime.minute.toString().padLeft(2,'0');final p=h<12?'ص':'م';final dh=h>12?h-12:(h==0?12:h);return'$dh:$m $p';} }

class BookingModel { final String id,bookingNumber,serviceNameAr,serviceNameEn,serviceId,status,addressLine; final double price; final String currency; final DateTime scheduledAt; final TechnicianModel? technician; final String? notes;
  const BookingModel({required this.id,required this.bookingNumber,required this.serviceNameAr,required this.serviceNameEn,required this.serviceId,required this.price,this.currency='SAR',required this.scheduledAt,this.status='CONFIRMED',this.technician,required this.addressLine,this.notes});
  String statusAr()=>switch(status){'PENDING'=>'قيد الانتظار','CONFIRMED'=>'مؤكد','IN_PROGRESS'=>'جاري التنفيذ','COMPLETED'=>'مكتمل','CANCELLED'=>'ملغي',_=>status}; }

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

ServiceDetailModel mockServiceDetail(String slug)=>ServiceDetailModel(id:'svc-1',slug:slug,nameAr:'تركيب وصيانة تكييف سبليت',nameEn:'Split AC Installation & Service',descriptionAr:'خدمة تركيب وصيانة أجهزة التكييف السبليت بجميع أحجامها وماركاتها. فنيون معتمدون بخبرة 10+ سنوات. ضمان سنة كاملة على الخدمة.',descriptionEn:'Professional split AC installation and maintenance for all brands. Certified technicians with 10+ years experience. 1-year warranty.',basePrice:150,discountedPrice:120,imageUrl:'https://picsum.photos/600/400?random=90',galleryUrls:['https://picsum.photos/600/400?random=90','https://picsum.photos/600/400?random=91','https://picsum.photos/600/400?random=92'],rating:4.8,totalRatings:312,totalBookings:1840,categoryNameAr:'تكييف',categorySlug:'ac',estimatedDurationMin:120,
features:const[ServiceFeature(icon:'✅',textAr:'فنيون معتمدون',textEn:'Certified technicians'),ServiceFeature(icon:'🛡️',textAr:'ضمان سنة',textEn:'1-year warranty'),ServiceFeature(icon:'🔧',textAr:'أدوات مشمولة',textEn:'Tools included'),ServiceFeature(icon:'🏷️',textAr:'سعر ثابت',textEn:'Fixed price'),ServiceFeature(icon:'⏱️',textAr:'يصل خلال ساعتين',textEn:'Arrives in 2 hrs'),ServiceFeature(icon:'📞',textAr:'دعم ما بعد الخدمة',textEn:'Post-service support')],
whatToExpect:const['سيتواصل الفني معك قبل الوصول بـ 30 دقيقة','فحص موقع التركيب وتحديد المكان المناسب','تركيب الوحدة الداخلية والخارجية','اختبار الجهاز والتأكد من عمله','شرح طريقة الاستخدام والصيانة'],
technicians:const[TechnicianModel(id:'t1',name:'محمد الغامدي',rating:4.9,reviewCount:128,completedJobs:340,specializations:['تكييف سبليت']),TechnicianModel(id:'t2',name:'علي الشمري',rating:4.7,reviewCount:89,completedJobs:210)],
reviews:[ServiceReview(id:'r1',userName:'فهد',rating:5,isVerified:true,comment:'خدمة ممتازة، الفني محترف وسريع.',createdAt:DateTime.now().subtract(const Duration(days:2))),ServiceReview(id:'r2',userName:'سارة',rating:5,isVerified:true,comment:'تم التركيب بشكل احترافي والضمان مريح.',createdAt:DateTime.now().subtract(const Duration(days:7))),ServiceReview(id:'r3',userName:'خالد',rating:4,comment:'جيد جداً.',createdAt:DateTime.now().subtract(const Duration(days:14)))],
faqs:const[ServiceFaq(questionAr:'هل السعر شامل جميع التكاليف؟',questionEn:'Does price include all costs?',answerAr:'نعم، السعر شامل العمالة والأدوات.',answerEn:'Yes, includes labor and materials.'),ServiceFaq(questionAr:'ما مدة الضمان؟',questionEn:'What is the warranty?',answerAr:'ضمان سنة كاملة.',answerEn:'Full 1-year warranty.')]);

List<TimeSlot> generateSlots(DateTime date){final rng=math.Random(date.day);final hours=[8,9,10,11,12,13,14,15,16,17,18];return hours.map((h){final s=DateTime(date.year,date.month,date.day,h);return TimeSlot(id:'${date.day}-$h',startTime:s,endTime:s.add(const Duration(hours:2)),isAvailable:rng.nextBool()||h%3!=0);}).toList();}

final mockBookings=[
  BookingModel(id:'b1',bookingNumber:'BK-5829401',serviceNameAr:'تركيب تكييف سبليت',serviceNameEn:'AC Install',serviceId:'svc-1',price:120,scheduledAt:DateTime.now().add(const Duration(days:1,hours:9)),status:'CONFIRMED',technician:const TechnicianModel(id:'t1',name:'محمد الغامدي',rating:4.9,reviewCount:128,completedJobs:340),addressLine:'حي النخيل، الرياض',notes:'غرفة النوم'),
  BookingModel(id:'b2',bookingNumber:'BK-4718390',serviceNameAr:'تنظيف شامل',serviceNameEn:'Deep Cleaning',serviceId:'svc-4',price:280,scheduledAt:DateTime.now().subtract(const Duration(days:3)),status:'COMPLETED',technician:const TechnicianModel(id:'t3',name:'عبدالله القحطاني',rating:4.6,reviewCount:64,completedJobs:180),addressLine:'حي العليا، الرياض'),
  BookingModel(id:'b3',bookingNumber:'BK-3607289',serviceNameAr:'إصلاح تسرب مياه',serviceNameEn:'Water Leak Repair',serviceId:'svc-2',price:90,scheduledAt:DateTime.now().subtract(const Duration(hours:2)),status:'IN_PROGRESS',technician:const TechnicianModel(id:'t2',name:'علي الشمري',rating:4.7,reviewCount:89,completedJobs:210),addressLine:'حي الروضة، جدة'),
];
