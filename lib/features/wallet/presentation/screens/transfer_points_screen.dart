import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// تحويل النقاط — light design
class TransferPointsScreen extends ConsumerStatefulWidget {
  const TransferPointsScreen({super.key});

  @override
  ConsumerState<TransferPointsScreen> createState() => _TransferPointsScreenState();
}

class _TransferPointsScreenState extends ConsumerState<TransferPointsScreen> {
  final _phone = TextEditingController();
  final _amount = TextEditingController(text: '100');

  @override
  void dispose() {
    _phone.dispose();
    _amount.dispose();
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
              KayanLightTopBar(title: ar ? 'تحويل النقاط' : 'Transfer points', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: KayanDesignTokens.gradGold,
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars_rounded, color: Color(0xFF402C00)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ar ? 'رصيدك' : 'Your balance', style: KayanDesignTokens.cairo(color: const Color(0xFF402C00))),
                              Text('1,840 ${ar ? 'نقطة' : 'pts'}', style: KayanDesignTokens.cairo(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF402C00))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    KayanDesignTextField(controller: _phone, label: ar ? 'جوال المستفيد' : 'Recipient phone', hint: '+966', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                    const SizedBox(height: 14),
                    KayanDesignTextField(controller: _amount, label: ar ? 'عدد النقاط' : 'Points amount', icon: Icons.swap_horiz_rounded, keyboardType: TextInputType.number),
                    const SizedBox(height: 8),
                    Text(ar ? 'الحد الأقصى 500 نقطة يومياً' : 'Max 500 points per day', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'تحويل' : 'Transfer',
                trailingIcon: Icons.send_rounded,
                variant: KayanCtaVariant.gold,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم التحويل' : 'Transfer completed')),
                  );
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
