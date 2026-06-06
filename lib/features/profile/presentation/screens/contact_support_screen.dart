// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'تواصل مع الدعم',
      titleEn: 'Contact Support',
      subtitleAr: 'فريقنا جاهز لمساعدتك.',
      subtitleEn: 'Our team is ready to help.',
      children: [
          Phase2InfoCard(
            icon: Icons.email_rounded,
            titleAr: 'البريد الإلكتروني',
            titleEn: 'Email',
            bodyAr: 'support@kayan.sa',
            bodyEn: 'support@kayan.sa',
          ),
          Phase2InfoCard(
            icon: Icons.phone_in_talk_rounded,
            titleAr: 'مركز الاتصال',
            titleEn: 'Call Center',
            bodyAr: '920000000',
            bodyEn: '920000000',
          ),
      ],
    );
  }
}
