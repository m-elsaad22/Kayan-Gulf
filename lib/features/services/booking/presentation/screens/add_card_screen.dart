// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'إضافة بطاقة',
      titleEn: 'Add Card',
      subtitleAr: 'احفظ بطاقة دفع آمنة لاستخدامها لاحقاً.',
      subtitleEn: 'Save a secure payment card for later use.',
      children: [
          Phase3ServiceCard(
            icon: Icons.credit_card_rounded,
            titleAr: 'بيانات البطاقة',
            titleEn: 'Card Details',
            bodyAr: 'أدخل الرقم وتاريخ الانتهاء واسم حامل البطاقة.',
            bodyEn: 'Enter number, expiry, and cardholder name.',
          ),
          Phase3ServiceCard(
            icon: Icons.lock_rounded,
            titleAr: 'حماية الدفع',
            titleEn: 'Payment Security',
            bodyAr: 'لا يتم حفظ رمز CVV في كيان.',
            bodyEn: 'CVV is never stored by KAYAN.',
          ),
      ],
    );
  }
}
