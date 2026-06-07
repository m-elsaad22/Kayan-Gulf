// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';

class ClassifiedsNotificationsScreen extends ConsumerWidget {
  const ClassifiedsNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final items = ar
        ? [
            ('تمت الموافقة على إعلانك', 'منذ ساعتين'),
            ('رسالة جديدة على إعلان السيارة', 'منذ 5 ساعات'),
            ('انتهى ترويج إعلانك', 'أمس'),
          ]
        : [
            ('Your ad was approved', '2 hours ago'),
            ('New message on car listing', '5 hours ago'),
            ('Your boost expired', 'Yesterday'),
          ];

    return Phase5ClassifiedsScaffold(
      titleAr: 'إشعارات الإعلانات',
      titleEn: 'Classifieds Alerts',
      subtitleAr: 'تحديثات إعلاناتك ورسائلك.',
      subtitleEn: 'Updates on your ads and messages.',
      children: items
          .map(
            (e) => Phase5ClassifiedsCard(
              icon: Icons.notifications_active_outlined,
              titleAr: e.$1,
              titleEn: e.$1,
              bodyAr: e.$2,
              bodyEn: e.$2,
            ),
          )
          .toList(),
    );
  }
}
