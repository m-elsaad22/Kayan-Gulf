// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class CheckoutAddAddressScreen extends StatelessWidget {
  const CheckoutAddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'إضافة عنوان',
      titleEn: 'Add Address',
      subtitleAr: 'أضف عنوان توصيل جديد للمتجر.',
      subtitleEn: 'Add a new shopping delivery address.',
      children: [
          Phase4CommerceCard(
            icon: Icons.location_on_rounded,
            titleAr: 'تفاصيل الموقع',
            titleEn: 'Location Details',
            bodyAr: 'المدينة والحي والشارع ورقم المبنى.',
            bodyEn: 'City, district, street, and building.',
          ),
          Phase4CommerceCard(
            icon: Icons.note_alt_rounded,
            titleAr: 'ملاحظات التوصيل',
            titleEn: 'Delivery Notes',
            bodyAr: 'أضف تعليمات للمندوب.',
            bodyEn: 'Add courier instructions.',
          ),
      ],
    );
  }
}
