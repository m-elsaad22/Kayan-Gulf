// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class AddCardCheckoutScreen extends StatelessWidget {
  const AddCardCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'إضافة بطاقة للدفع',
      titleEn: 'Add Payment Card',
      subtitleAr: 'احفظ بطاقة جديدة لاستخدامها في الطلبات.',
      subtitleEn: 'Save a new card for orders.',
      children: [
          Phase4CommerceCard(
            icon: Icons.credit_score_rounded,
            titleAr: 'بطاقة آمنة',
            titleEn: 'Secure Card',
            bodyAr: 'يتم التحقق من البطاقة قبل الحفظ.',
            bodyEn: 'Card is verified before saving.',
          ),
          Phase4CommerceCard(
            icon: Icons.lock_rounded,
            titleAr: 'تشفير',
            titleEn: 'Encryption',
            bodyAr: 'لا يتم حفظ رمز CVV.',
            bodyEn: 'CVV is never stored.',
          ),
      ],
    );
  }
}
