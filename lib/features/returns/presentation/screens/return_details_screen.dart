// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class ReturnDetailsScreen extends StatelessWidget {
  const ReturnDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'تفاصيل الإرجاع',
      titleEn: 'Return Details',
      subtitleAr: 'أضف سبب الإرجاع والصور والملاحظات.',
      subtitleEn: 'Add return reason, photos, and notes.',
      children: [
          Phase4CommerceCard(
            icon: Icons.description_rounded,
            titleAr: 'السبب',
            titleEn: 'Reason',
            bodyAr: 'حدد المشكلة أو سبب عدم الرضا.',
            bodyEn: 'Select issue or dissatisfaction reason.',
          ),
          Phase4CommerceCard(
            icon: Icons.image_rounded,
            titleAr: 'صور داعمة',
            titleEn: 'Supporting Photos',
            bodyAr: 'أرفق صوراً لتسريع مراجعة الطلب.',
            bodyEn: 'Attach photos to speed review.',
          ),
      ],
    );
  }
}
