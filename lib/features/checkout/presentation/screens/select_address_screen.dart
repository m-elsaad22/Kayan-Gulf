// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'اختيار العنوان',
      titleEn: 'Select Address',
      subtitleAr: 'اختر عنوان التوصيل المناسب لطلبك.',
      subtitleEn: 'Choose the delivery address for your order.',
      children: [
          Phase4CommerceCard(
            icon: Icons.home_rounded,
            titleAr: 'المنزل',
            titleEn: 'Home',
            bodyAr: 'حي النخيل، الرياض.',
            bodyEn: 'Al Nakheel, Riyadh.',
          ),
          Phase4CommerceCard(
            icon: Icons.business_rounded,
            titleAr: 'العمل',
            titleEn: 'Work',
            bodyAr: 'حي العليا، الرياض.',
            bodyEn: 'Olaya, Riyadh.',
          ),
      ],
    );
  }
}
