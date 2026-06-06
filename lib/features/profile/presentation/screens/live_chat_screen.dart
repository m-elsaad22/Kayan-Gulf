// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class LiveChatScreen extends StatelessWidget {
  const LiveChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'المحادثة المباشرة',
      titleEn: 'Live Chat',
      subtitleAr: 'تواصل فورياً مع فريق كيان.',
      subtitleEn: 'Chat instantly with KAYAN support.',
      children: [
          Phase2InfoCard(
            icon: Icons.chat_bubble_rounded,
            titleAr: 'محادثة الدعم',
            titleEn: 'Support Chat',
            bodyAr: 'متاح يومياً لخدمتك.',
            bodyEn: 'Available daily to serve you.',
          ),
          Phase2InfoCard(
            icon: Icons.timer_rounded,
            titleAr: 'متوسط الرد',
            titleEn: 'Average Reply',
            bodyAr: 'أقل من 5 دقائق.',
            bodyEn: 'Under 5 minutes.',
          ),
      ],
    );
  }
}
