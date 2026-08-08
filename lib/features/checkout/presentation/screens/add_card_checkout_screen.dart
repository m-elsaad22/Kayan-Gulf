import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إضافة بطاقة للدفع — light design
class AddCardCheckoutScreen extends ConsumerStatefulWidget {
  const AddCardCheckoutScreen({super.key});

  @override
  ConsumerState<AddCardCheckoutScreen> createState() => _AddCardCheckoutScreenState();
}

class _AddCardCheckoutScreenState extends ConsumerState<AddCardCheckoutScreen> {
  final _number = TextEditingController();
  final _name = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();

  @override
  void dispose() {
    _number.dispose();
    _name.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'إضافة بطاقة' : 'Add card', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    KayanDesignTextField(controller: _number, label: ar ? 'رقم البطاقة' : 'Card number', hint: '4242 4242 4242 4242', icon: Icons.credit_card_rounded, keyboardType: TextInputType.number),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _name, label: ar ? 'اسم حامل البطاقة' : 'Cardholder name', icon: Icons.person_outline_rounded),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: KayanDesignTextField(controller: _expiry, label: ar ? 'الانتهاء' : 'Expiry', hint: 'MM/YY', icon: Icons.date_range_outlined)),
                        const SizedBox(width: 12),
                        Expanded(child: KayanDesignTextField(controller: _cvv, label: 'CVV', icon: Icons.lock_outline_rounded, obscureText: true, keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(ar ? 'لا يتم حفظ رمز CVV' : 'CVV is never stored', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'حفظ ومتابعة' : 'Save & continue',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () => context.push(AppRoutes.orderConfirmation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
