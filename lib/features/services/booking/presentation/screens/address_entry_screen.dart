// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class AddressEntryScreen extends StatelessWidget {
  const AddressEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'إدخال العنوان',
      titleEn: 'Address Entry',
      subtitleAr: 'أضف عنوان الخدمة بدقة لتسهيل وصول الفني.',
      subtitleEn: 'Add a precise service address for technician arrival.',
      children: [
          Phase3ServiceCard(
            icon: Icons.map_rounded,
            titleAr: 'الموقع على الخريطة',
            titleEn: 'Map Location',
            bodyAr: 'حدد الحي والشارع ورقم المبنى.',
            bodyEn: 'Select district, street, and building number.',
          ),
          Phase3ServiceCard(
            icon: Icons.notes_rounded,
            titleAr: 'تعليمات الوصول',
            titleEn: 'Access Notes',
            bodyAr: 'أضف ملاحظات مثل رقم الشقة أو البوابة.',
            bodyEn: 'Add apartment or gate instructions.',
          ),
      ],
    );
  }
}
