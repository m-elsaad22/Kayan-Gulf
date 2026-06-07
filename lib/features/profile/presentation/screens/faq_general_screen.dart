// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class FaqGeneralScreen extends StatelessWidget {
  const FaqGeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'الأسئلة الشائعة',
      titleEn: 'FAQ',
      subtitleAr: 'إجابات سريعة لأكثر الأسئلة شيوعاً.',
      subtitleEn: 'Quick answers for common questions.',
      children: [
          Phase2InfoCard(
            icon: Icons.help_outline_rounded,
            titleAr: 'كيف أستخدم كيان؟',
            titleEn: 'How do I use KAYAN?',
            bodyAr: 'اختر خدمات أو متجر أو إعلانات من لوحة البداية.',
            bodyEn: 'Choose services, shop, or classifieds from the dashboard.',
          ),
          Phase2InfoCard(
            icon: Icons.account_circle_rounded,
            titleAr: 'هل أستطيع التصفح كضيف؟',
            titleEn: 'Can I browse as guest?',
            bodyAr: 'نعم، ويتم طلب التسجيل عند الشراء أو الحجز.',
            bodyEn: 'Yes, sign-in is requested at checkout or booking.',
          ),
      ],
    );
  }
}
