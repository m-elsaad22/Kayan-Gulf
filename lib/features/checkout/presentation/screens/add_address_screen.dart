import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// إضافة عنوان للمتجر — light design
class CheckoutAddAddressScreen extends ConsumerStatefulWidget {
  const CheckoutAddAddressScreen({super.key});

  @override
  ConsumerState<CheckoutAddAddressScreen> createState() => _CheckoutAddAddressScreenState();
}

class _CheckoutAddAddressScreenState extends ConsumerState<CheckoutAddAddressScreen> {
  final _district = TextEditingController();
  final _street = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _district.dispose();
    _street.dispose();
    _notes.dispose();
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
              KayanLightTopBar(title: ar ? 'إضافة عنوان' : 'Add address', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    KayanDesignTextField(controller: _district, label: ar ? 'الحي' : 'District', icon: Icons.location_city_outlined),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _street, label: ar ? 'الشارع' : 'Street', icon: Icons.signpost_outlined),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _notes, label: ar ? 'ملاحظات التوصيل' : 'Delivery notes', icon: Icons.notes_outlined),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'حفظ العنوان' : 'Save address',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ar ? 'تم حفظ العنوان' : 'Address saved')));
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
