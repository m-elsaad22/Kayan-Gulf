// Help & support — light design (18-help-support.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../widgets/kayan_profile_widgets.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'المساعدة والدعم' : 'Help & support', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 14),
                    KayanProfileMenuTile(icon: Icons.quiz_outlined, title: ar ? 'الأسئلة الشائعة' : 'FAQ', subtitle: ar ? 'إجابات سريعة' : 'Quick answers', onTap: () => context.push(AppRoutes.faqGeneral)),
                    KayanProfileMenuTile(icon: Icons.chat_rounded, title: ar ? 'دردشة مباشرة' : 'Live chat', subtitle: ar ? 'متاح 24/7' : 'Available 24/7', onTap: () => context.push(AppRoutes.liveChat)),
                    KayanProfileMenuTile(icon: Icons.support_agent_rounded, title: ar ? 'تواصل مع الدعم' : 'Contact support', onTap: () => context.push(AppRoutes.contactSupport)),
                    KayanProfileMenuTile(icon: Icons.phone_in_talk_outlined, title: ar ? 'اتصل بنا' : 'Call us', subtitle: '920000000', onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
