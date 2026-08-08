import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';

/// 89-pr-faq — أسئلة شائعة عامة
class FaqGeneralScreen extends StatefulWidget {
  const FaqGeneralScreen({super.key});

  @override
  State<FaqGeneralScreen> createState() => _FaqGeneralScreenState();
}

class _FaqGeneralScreenState extends State<FaqGeneralScreen> {
  int? _expanded;

  static const _faqs = [
    ('كيف أطلب توصيل؟', 'من التطبيق اختر التوصيل، حدد العنوان والمتجر، ثم أكد الطلب.'),
    ('كيف أبيع في السوق؟', 'من السوق اضغط «أضف إعلان» واتبع الخطوات لرفع صور ووصف المنتج.'),
    ('طرق الدفع المتاحة؟', 'محفظة كيان، بطاقة بنكية، أو الدفع عند الاستلام حسب الخدمة.'),
    ('كيف أسترجع مبلغاً؟', 'من المحفظة أو تفاصيل الطلب يمكنك طلب استرجاع خلال 7 أيام.'),
    ('كيف أغير كلمة المرور؟', 'الملف الشخصي ← الإعدادات ← الأمان ← تغيير كلمة المرور.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: 'الأسئلة الشائعة', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < _faqs.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: KayanDesignTokens.surface,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            border: Border.all(color: KayanDesignTokens.border),
                            boxShadow: KayanDesignTokens.shadowS,
                          ),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              _faqs[i].$1,
                              style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                            initiallyExpanded: _expanded == i,
                            onExpansionChanged: (open) {
                              setState(() => _expanded = open ? i : null);
                            },
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Text(
                                  _faqs[i].$2,
                                  style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
