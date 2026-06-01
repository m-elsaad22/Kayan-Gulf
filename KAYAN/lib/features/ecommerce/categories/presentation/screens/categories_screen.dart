// KAYAN — Categories Screen
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
import '../../../../home/data/models/home_models.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  static final _cats = [
    ('📱','إلكترونيات','Electronics','electronics',const Color(0xFF4169E1)),
    ('👗','أزياء','Fashion','fashion',const Color(0xFFEC4899)),
    ('🏠','المنزل','Home','home',const Color(0xFF10B981)),
    ('💄','جمال','Beauty','beauty',const Color(0xFFEF4444)),
    ('⚽','رياضة','Sports','sports',const Color(0xFF8B5CF6)),
    ('🧸','ألعاب','Toys','toys',const Color(0xFFF59E0B)),
    ('🍕','طعام','Food','food',const Color(0xFF14B8A6)),
    ('🚗','سيارات','Automotive','automotive',const Color(0xFF64748B)),
    ('📚','كتب','Books','books',const Color(0xFF92400E)),
    ('💊','صحة','Health','health',const Color(0xFF059669)),
    ('🎮','ألعاب إلكترونية','Gaming','gaming',const Color(0xFF7C3AED)),
    ('✈️','سفر','Travel','travel',const Color(0xFF0891B2)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface, centerTitle: true,
        title: Text(ar ? 'الفئات' : 'Categories', style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3, crossAxisSpacing:12, mainAxisSpacing:12, childAspectRatio:0.95),
        itemCount: _cats.length,
        itemBuilder: (_, i) {
          final c = _cats[i];
          return GestureDetector(
            onTap: () { HapticFeedback.selectionClick(); context.push(AppRoutes.productListPath(c.$4)); },
            child: Container(
              decoration: BoxDecoration(color:AppColors.bgCard, borderRadius:AppBorderRadius.card, border:Border.all(color:AppColors.borderSubtle)),
              child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[
                Container(width:60,height:60,decoration:BoxDecoration(color:c.$5.withOpacity(0.12),borderRadius:BorderRadius.circular(16),border:Border.all(color:c.$5.withOpacity(0.25))),
                    child:Center(child:Text(c.$1,style:const TextStyle(fontSize:28)))),
                const SizedBox(height:8),
                Text(ar?c.$2:c.$3,style:(ar?AppTextStyles.arabicBodySmall:AppTextStyles.bodySmall).copyWith(fontWeight:FontWeight.w600),textAlign:TextAlign.center,maxLines:1,overflow:TextOverflow.ellipsis),
              ]),
            ),
          );
        },
      ),
    );
  }
}
