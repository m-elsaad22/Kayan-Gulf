// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_profile_widgets.dart';

class ManageSubscriptionScreen extends StatelessWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2ProfileScaffold(
      titleAr: 'إدارة الاشتراك',
      titleEn: 'Manage Subscription',
      subtitleAr: 'راجع خطتك الحالية وطريقة الدفع.',
      subtitleEn: 'Review your current plan and payment method.',
      children: [
          Phase2InfoCard(
            icon: Icons.event_repeat_rounded,
            titleAr: 'التجديد القادم',
            titleEn: 'Next Renewal',
            bodyAr: 'يتم التجديد في نهاية الشهر.',
            bodyEn: 'Renews at the end of the month.',
          ),
          Phase2InfoCard(
            icon: Icons.payment_rounded,
            titleAr: 'طريقة الدفع',
            titleEn: 'Payment Method',
            bodyAr: 'بطاقة محفوظة بأمان.',
            bodyEn: 'Card stored securely.',
          ),
      ],
    );
  }
}
