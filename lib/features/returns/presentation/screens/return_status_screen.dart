// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class ReturnStatusScreen extends StatelessWidget {
  const ReturnStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'حالة الإرجاع',
      titleEn: 'Return Status',
      subtitleAr: 'تابع مراحل معالجة طلب الإرجاع.',
      subtitleEn: 'Track return request progress.',
      children: [
          Phase4CommerceCard(
            icon: Icons.hourglass_top_rounded,
            titleAr: 'قيد المراجعة',
            titleEn: 'Under Review',
            bodyAr: 'فريق كيان يراجع طلبك.',
            bodyEn: 'KAYAN team is reviewing your request.',
          ),
          Phase4CommerceCard(
            icon: Icons.local_shipping_rounded,
            titleAr: 'استلام المنتج',
            titleEn: 'Pickup',
            bodyAr: 'سيتم تنسيق الاستلام عند الموافقة.',
            bodyEn: 'Pickup is scheduled after approval.',
          ),
      ],
    );
  }
}
