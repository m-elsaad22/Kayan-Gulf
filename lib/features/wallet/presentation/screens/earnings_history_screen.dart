// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_wallet_widgets.dart';

class EarningsHistoryScreen extends StatelessWidget {
  const EarningsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2WalletScaffold(
      titleAr: 'سجل الأرباح',
      titleEn: 'Earnings History',
      subtitleAr: 'تابع عمليات الأرباح والسحوبات.',
      subtitleEn: 'Track earnings and withdrawals.',
      children: [
          Phase2WalletCard(
            icon: Icons.trending_up_rounded,
            titleAr: 'أرباح هذا الشهر',
            titleEn: 'This Month',
            value: '2,480 ر.س',
            captionAr: 'من خدمات وإعلانات نشطة.',
            captionEn: 'From active services and listings.',
          ),
          Phase2WalletCard(
            icon: Icons.history_rounded,
            titleAr: 'آخر عملية',
            titleEn: 'Latest Transaction',
            value: '+320 ر.س',
            captionAr: 'تمت إضافتها إلى محفظتك.',
            captionEn: 'Added to your wallet.',
          ),
      ],
    );
  }
}
