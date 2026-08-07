// Rate order — matches design/html/103-or-rate-order.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../data/mock/delivery_mock_data.dart';

class DeliveryRateOrderScreen extends ConsumerStatefulWidget {
  const DeliveryRateOrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<DeliveryRateOrderScreen> createState() => _DeliveryRateOrderScreenState();
}

class _DeliveryRateOrderScreenState extends ConsumerState<DeliveryRateOrderScreen> {
  int _rating = 0;
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final order = mockDeliveryOrders.where((o) => o.id == widget.orderId).firstOrNull ?? mockDeliveryOrders[1];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'قيّم الطلب' : 'Rate order', onBack: () => context.pop()),
              const SizedBox(height: 20),
              Text(order.vendor.name(ar), textAlign: TextAlign.center, style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: KayanDesignTokens.kBlueDeep)),
              const SizedBox(height: 8),
              Text(ar ? 'كيف كانت تجربتك؟' : 'How was your experience?', textAlign: TextAlign.center, style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return IconButton(
                    onPressed: () => setState(() => _rating = star),
                    icon: Icon(
                      star <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: KayanDesignTokens.gold,
                      size: 36,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              KayanDesignTextField(
                label: ar ? 'تعليق (اختياري)' : 'Comment (optional)',
                hint: ar ? 'شاركنا رأيك...' : 'Share your feedback...',
                icon: Icons.rate_review_outlined,
                controller: _commentCtrl,
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'إرسال التقييم' : 'Submit rating',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.orange,
                onPressed: _rating == 0
                    ? null
                    : () {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(ar ? 'شكراً على تقييمك!' : 'Thanks for your rating!'), behavior: SnackBarBehavior.floating),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
