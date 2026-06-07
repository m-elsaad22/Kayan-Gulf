// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'المساعدة والدعم',
      titleEn: 'Help & Support',
      subtitleAr: 'كل قنوات الدعم في مكان واحد.',
      subtitleEn: 'All support channels in one place.',
      children: [
          Phase2InfoCard(
            icon: Icons.live_help_rounded,
            titleAr: 'الأسئلة الشائعة',
            titleEn: 'FAQ',
            bodyAr: 'اعثر على إجابات فورية.',
            bodyEn: 'Find instant answers.',
          ),
          Phase2InfoCard(
            icon: Icons.support_agent_rounded,
            titleAr: 'تواصل مع الدعم',
            titleEn: 'Contact Support',
            bodyAr: 'ارسل طلب دعم للفريق.',
            bodyEn: 'Send a support request to the team.',
          ),
      ],
    );
  }
}
