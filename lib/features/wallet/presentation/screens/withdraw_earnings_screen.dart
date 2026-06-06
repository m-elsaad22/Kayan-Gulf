// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../widgets/phase2_wallet_widgets.dart';

class WithdrawEarningsScreen extends StatelessWidget {
  const WithdrawEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase2WalletScaffold(
      titleAr: 'سحب الأرباح',
      titleEn: 'Withdraw Earnings',
      subtitleAr: 'اسحب أرباح الإعلانات والخدمات بأمان.',
      subtitleEn: 'Withdraw ad and service earnings securely.',
      children: [
          Phase2WalletCard(
            icon: Icons.account_balance_rounded,
            titleAr: 'الحساب البنكي',
            titleEn: 'Bank Account',
            value: 'IBAN **** 2048',
            captionAr: 'يتم التحويل خلال أيام العمل.',
            captionEn: 'Transfers are processed on business days.',
          ),
          Phase2WalletCard(
            icon: Icons.payments_rounded,
            titleAr: 'المبلغ المتاح',
            titleEn: 'Available Amount',
            value: '1,250 ر.س',
            captionAr: 'الحد الأدنى للسحب 100 ر.س.',
            captionEn: 'Minimum withdrawal is 100 SAR.',
          ),
      ],
    );
  }
}
