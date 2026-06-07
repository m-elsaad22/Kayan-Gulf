// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../ecommerce/shared/presentation/widgets/phase4_commerce_widgets.dart';

class PaymentMethodCheckoutScreen extends StatelessWidget {
  const PaymentMethodCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase4CommerceScaffold(
      titleAr: 'طريقة دفع الطلب',
      titleEn: 'Checkout Payment Method',
      subtitleAr: 'اختر طريقة الدفع لطلب المتجر.',
      subtitleEn: 'Choose payment method for store order.',
      children: [
          Phase4CommerceCard(
            icon: Icons.credit_card_rounded,
            titleAr: 'بطاقة بنكية',
            titleEn: 'Card',
            bodyAr: 'Visa / Mastercard / Mada.',
            bodyEn: 'Visa / Mastercard / Mada.',
          ),
          Phase4CommerceCard(
            icon: Icons.account_balance_wallet_rounded,
            titleAr: 'محفظة رقمية',
            titleEn: 'Digital Wallet',
            bodyAr: 'Apple Pay أو محفظة كيان.',
            bodyEn: 'Apple Pay or KAYAN Wallet.',
          ),
      ],
    );
  }
}
