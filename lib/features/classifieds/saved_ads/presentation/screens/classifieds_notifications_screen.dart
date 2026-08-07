// Classifieds notifications — matches design/html/126-cl-notifications.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';

class ClassifiedsNotificationsScreen extends ConsumerWidget {
  const ClassifiedsNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    final items = ar
        ? [
            (
              'رد جديد على إعلانك',
              'خالد العتيبي أرسل رسالة عن تويوتا كامري',
              'منذ ساعة',
              Icons.chat_bubble_outline_rounded,
              KayanDesignTokens.gradBlue,
              true,
              'khalid',
            ),
            (
              'إعلانك يحقق مشاهدات',
              "إعلان 'شقة للإيجار' وصل 500 مشاهدة",
              'منذ يوم',
              Icons.visibility_outlined,
              KayanDesignTokens.gradBlue,
              false,
              null,
            ),
            (
              'إعلانك على وشك الانتهاء',
              "جدد إعلان 'آيفون 15 برو' قبل انتهائه",
              'منذ يومين',
              Icons.schedule_rounded,
              const LinearGradient(colors: [KayanDesignTokens.danger, Color(0xFFE86B4A)]),
              true,
              null,
            ),
          ]
        : [
            (
              'New reply on your ad',
              'Khalid sent a message about Toyota Camry',
              '1 hour ago',
              Icons.chat_bubble_outline_rounded,
              KayanDesignTokens.gradBlue,
              true,
              'khalid',
            ),
            (
              'Your ad is getting views',
              "Listing 'Apartment for rent' reached 500 views",
              '1 day ago',
              Icons.visibility_outlined,
              KayanDesignTokens.gradBlue,
              false,
              null,
            ),
            (
              'Your ad is expiring soon',
              "Renew 'iPhone 15 Pro' before it expires",
              '2 days ago',
              Icons.schedule_rounded,
              const LinearGradient(colors: [KayanDesignTokens.danger, Color(0xFFE86B4A)]),
              true,
              null,
            ),
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: ar ? 'إشعارات الإعلانات' : 'Classifieds alerts',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: items.map((item) {
                    return KayanNotificationItem(
                      title: item.$1,
                      body: item.$2,
                      time: item.$3,
                      icon: item.$4,
                      iconGradient: item.$5,
                      unread: item.$6,
                      onTap: item.$7 != null
                          ? () => context.push(AppRoutes.classifiedsChatPath(item.$7!))
                          : null,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
