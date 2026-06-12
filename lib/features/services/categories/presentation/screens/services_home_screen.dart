// KAYAN — Services Home Screen
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
import '../../../../services/browse/data/models/service_models.dart';

final _catsProv=FutureProvider.autoDispose<List<ServiceCategory>>((ref)async{await Future.delayed(const Duration(milliseconds:300));return mockServiceCategories;});

class ServicesHomeScreen extends ConsumerWidget{
  const ServicesHomeScreen({super.key});
  @override
  Widget build(BuildContext context,WidgetRef ref){
    final ar=ref.watch(isArabicProvider);
    final cats=ref.watch(_catsProv);
    return Scaffold(backgroundColor:Theme.of(context).scaffoldBackgroundColor,body:CustomScrollView(physics:const BouncingScrollPhysics(parent:AlwaysScrollableScrollPhysics()),slivers:[
      SliverAppBar(pinned:true,expandedHeight:130,backgroundColor:AppColors.bgSurface,
        flexibleSpace:FlexibleSpaceBar(collapseMode:CollapseMode.pin,background:Container(decoration:const BoxDecoration(gradient:AppGradients.hero),child:SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(20,8,20,0),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.end,children:[
          Text(ar?'الخدمات المنزلية':'Home Services',style:ar?AppTextStyles.arabicHeadlineSmall:AppTextStyles.headlineSmall),
          Text(ar?'فنيون معتمدون يصلون إليك':'Certified technicians at your door',style:(ar?AppTextStyles.arabicBodySmall:AppTextStyles.bodySmall).copyWith(color:AppColors.textSecondary)),
          const SizedBox(height:10),
        ]))))),
        bottom:PreferredSize(preferredSize:const Size.fromHeight(50),child:Container(color:AppColors.bgSurface,padding:const EdgeInsets.fromLTRB(16,0,16,8),child:GestureDetector(onTap:()=>context.push('${AppRoutes.services}/browse'),child:Container(height:40,decoration:BoxDecoration(color:AppColors.bgInput,borderRadius:AppBorderRadius.pill,border:Border.all(color:AppColors.borderDefault)),child:Row(children:[const SizedBox(width:14),const Icon(Icons.search_rounded,size:18,color:AppColors.textMuted),const SizedBox(width:8),Text(ar?'ابحث عن خدمة...':'Search services...',style:(ar?AppTextStyles.arabicBodySmall:AppTextStyles.bodySmall).copyWith(color:AppColors.textMuted))]))))),
      ),
      SliverToBoxAdapter(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const SizedBox(height:16),
        // Emergency
        GestureDetector(onTap:()=>HapticFeedback.heavyImpact(),child:Container(margin:const EdgeInsets.symmetric(horizontal:AppSpacing.pagePadding),padding:const EdgeInsets.symmetric(horizontal:AppSpacing.lg,vertical:14),
          decoration:BoxDecoration(gradient:AppGradients.emergency,borderRadius:AppBorderRadius.card,boxShadow:[BoxShadow(color:AppColors.error.withOpacity(0.3),blurRadius:16,offset:const Offset(0,4))]),
          child:Row(children:[const Text('🚨',style:TextStyle(fontSize:28)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(ar?'خدمة طوارئ ٢٤/٧':'24/7 Emergency',style:ar?AppTextStyles.arabicTitleSmall:AppTextStyles.titleSmall),
            Text(ar?'فنيون يصلون خلال 30-60 دقيقة':'Technicians arrive in 30-60 min',style:(ar?AppTextStyles.arabicBodySmall:AppTextStyles.bodySmall).copyWith(color:Colors.white70)),
          ])),Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5),decoration:BoxDecoration(color:Colors.white.withOpacity(0.2),borderRadius:BorderRadius.circular(8)),child:Text(ar?'اطلب':'Call',style:AppTextStyles.labelSmall.copyWith(color:Colors.white,fontWeight:FontWeight.w700)))])),
        ),
        const SizedBox(height:20),
        _SH(ar?'الفئات':'Categories',ar),const SizedBox(height:12),
        // Categories 2 rows
        cats.when(loading:()=>const SizedBox(height:170),error:(_,__)=>const SizedBox.shrink(),data:(list)=>Column(children:[_CRow(list.take(5).toList(),ar),const SizedBox(height:12),_CRow(list.skip(5).take(5).toList(),ar)])),
        const SizedBox(height:24),
        _SH(ar?'الأكثر طلباً':'Most Popular',ar,seeAll:'${AppRoutes.services}/browse'),const SizedBox(height:12),
        _PopRow(ar),const SizedBox(height:24),
        // My bookings
        GestureDetector(onTap:()=>context.push(AppRoutes.myBookings),child:Padding(padding:const EdgeInsets.symmetric(horizontal:AppSpacing.pagePadding),child:Container(padding:const EdgeInsets.all(14),
          decoration:BoxDecoration(gradient:AppGradients.primaryButton,borderRadius:AppBorderRadius.card,boxShadow:[BoxShadow(color:AppColors.royalBlue.withOpacity(0.3),blurRadius:16,offset:const Offset(0,4))]),
          child:Row(children:[Container(width:44,height:44,decoration:BoxDecoration(color:Colors.white.withOpacity(0.15),borderRadius:BorderRadius.circular(12)),child:const Icon(Icons.calendar_today_rounded,color:Colors.white,size:22)),const SizedBox(width:14),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(ar?'حجوزاتي':'My Bookings',style:ar?AppTextStyles.arabicTitleSmall:AppTextStyles.titleSmall),Text(ar?'لديك حجز غداً الساعة 9 صباحاً':'You have a booking tomorrow at 9 AM',style:AppTextStyles.bodySmall.copyWith(color:Colors.white70),maxLines:1,overflow:TextOverflow.ellipsis)])),
            const Icon(Icons.arrow_forward_ios_rounded,size:14,color:Colors.white70)])))),
        const SizedBox(height:24),
        // How it works
        Padding(padding:const EdgeInsets.symmetric(horizontal:AppSpacing.pagePadding),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(ar?'كيف يعمل كيان؟':'How KAYAN Works',style:ar?AppTextStyles.arabicTitleMedium:AppTextStyles.titleMedium),const SizedBox(height:14),
          Row(children:[_HS('🔍',ar?'اختر':'Choose',AppGradients.primaryButton,true),_Conn(),_HS('📅',ar?'احجز':'Book',AppGradients.card,false),_Conn(),_HS('✅',ar?'استمتع':'Enjoy',AppGradients.goldButton,false)]),
        ])),
        const SizedBox(height:24),
        // Quality
        Padding(padding:const EdgeInsets.symmetric(horizontal:AppSpacing.pagePadding),child:Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(gradient:AppGradients.card,borderRadius:AppBorderRadius.card,border:Border.all(color:AppColors.borderGold)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[const Text('🏆',style:TextStyle(fontSize:18)),const SizedBox(width:8),Text(ar?'معايير الجودة':'Quality Standards',style:ar?AppTextStyles.arabicTitleSmall:AppTextStyles.titleSmall)]),const SizedBox(height:10),
          Wrap(spacing:6,runSpacing:6,children:['✅ ${ar?"فنيون معتمدون":"Certified"}','🛡️ ${ar?"ضمان سنة":"1yr Warranty"}','💰 ${ar?"أسعار ثابتة":"Fixed Prices"}','⭐ 4.8 ${ar?"متوسط":"Rating"}']
              .map((t)=>Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),decoration:BoxDecoration(color:AppColors.metallicGold.withOpacity(0.08),borderRadius:BorderRadius.circular(16),border:Border.all(color:AppColors.metallicGold.withOpacity(0.25))),child:Text(t,style:AppTextStyles.labelSmall.copyWith(color:AppColors.metallicGold)))).toList()),
        ]))),
        const SizedBox(height:100),
      ])),
    ]));
  }
}

Widget _SH(String t,bool ar,{String? seeAll})=>Builder(builder:(ctx)=>Padding(padding:const EdgeInsets.symmetric(horizontal:AppSpacing.pagePadding),child:Row(children:[Container(width:3,height:16,decoration:BoxDecoration(gradient:AppGradients.goldButton,borderRadius:BorderRadius.circular(2))),const SizedBox(width:8),Text(t,style:ar?AppTextStyles.arabicTitleMedium:AppTextStyles.titleMedium),const Spacer(),if(seeAll!=null)GestureDetector(onTap:()=>ctx.push(seeAll),child:Text(ar?'عرض الكل':'See All',style:AppTextStyles.seeAll))])));

Widget _CRow(List<ServiceCategory> cats,bool ar)=>SizedBox(height:79,child:ListView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:AppSpacing.pagePadding),children:cats.map((cat){Color c;try{c=Color(int.parse('FF${cat.colorHex.replaceFirst('#','')}',radix:16));}catch(_){c=AppColors.royalBlue;}return Builder(builder:(ctx)=>GestureDetector(onTap:(){HapticFeedback.selectionClick();ctx.push('${AppRoutes.services}/browse?catId=${cat.id}');},child:Container(width:68,margin:const EdgeInsets.only(right:10),child:Column(mainAxisSize:MainAxisSize.min,children:[Stack(children:[Container(width:54,height:54,decoration:BoxDecoration(color:c.withOpacity(0.12),borderRadius:BorderRadius.circular(14),border:Border.all(color:c.withOpacity(0.25))),child:Center(child:Text(cat.emoji,style:const TextStyle(fontSize:24)))),if(cat.isEmergency)Positioned(top:-2,right:-2,child:Container(width:14,height:14,decoration:const BoxDecoration(color:AppColors.error,shape:BoxShape.circle),child:const Center(child:Text('!',style:TextStyle(fontSize:8,color:Colors.white,fontWeight:FontWeight.w900)))))]),const SizedBox(height:5),Text(ar?cat.nameAr:cat.nameEn,style:(ar?AppTextStyles.arabicCaption:AppTextStyles.caption).copyWith(color:AppColors.textSecondary),textAlign:TextAlign.center,maxLines:2,overflow:TextOverflow.ellipsis)]))));}).toList()));

Widget _PopRow(bool ar){final s=[('تركيب تكييف','AC Install','❄️','120','4.8',AppColors.categoryTeal),('تسليك مجاري','Drain Clean','🔧','80','4.7',AppColors.categoryBlue),('تنظيف شامل','Deep Clean','🧹','200','4.9',AppColors.categoryGreen),('دهان غرفة','Room Paint','🎨','350','4.6',AppColors.categoryPurple)];
return SizedBox(height:155,child:ListView.builder(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:AppSpacing.pagePadding),itemCount:s.length,itemBuilder:(ctx,i){final e=s[i];return GestureDetector(onTap:()=>ctx.push(AppRoutes.servicePath('service-$i')),child:Container(width:136,margin:const EdgeInsets.only(right:12),decoration:BoxDecoration(color:AppColors.bgCard,borderRadius:AppBorderRadius.card,border:Border.all(color:AppColors.borderSubtle)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(height:78,decoration:BoxDecoration(color:e.$6.withOpacity(0.12),borderRadius:const BorderRadius.vertical(top:Radius.circular(16))),child:Center(child:Text(e.$3,style:const TextStyle(fontSize:34)))),Padding(padding:const EdgeInsets.all(8),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(ar?e.$1:e.$2,style:(ar?AppTextStyles.arabicTitleSmall:AppTextStyles.titleSmall).copyWith(fontSize:11),maxLines:1),const SizedBox(height:4),Row(children:[Text('${e.$4} ر.س',style:AppTextStyles.priceSmall),const Spacer(),const Icon(Icons.star_rounded,size:10,color:AppColors.starFilled),Text(' ${e.$5}',style:AppTextStyles.caption)])]))])));},));}

Widget _HS(String e,String l,LinearGradient g,bool main)=>Expanded(child:Column(children:[Container(width:46,height:46,decoration:BoxDecoration(gradient:g,shape:BoxShape.circle),child:Center(child:Text(e,style:const TextStyle(fontSize:20)))),const SizedBox(height:6),Text(l,style:AppTextStyles.labelSmall.copyWith(color:main?AppColors.royalBlue:AppColors.textSecondary),textAlign:TextAlign.center)]));
Widget _Conn()=>Container(width:16,height:2,color:AppColors.borderSubtle);
