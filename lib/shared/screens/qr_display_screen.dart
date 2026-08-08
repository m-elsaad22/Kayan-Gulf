import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/widgets/design/kayan_design_widgets.dart';
import '../../shared/widgets/design/kayan_entry_widgets.dart';

/// عرض رمز QR — light design
class QrDisplayScreen extends ConsumerWidget {
  const QrDisplayScreen({super.key, this.code});

  final String? code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);
    final displayCode = code ?? 'KAYAN-SVC-847293';

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'رمز QR' : 'QR code', onBack: () => context.pop()),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: KayanDesignTokens.border),
                  boxShadow: KayanDesignTokens.shadowM,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: KayanDesignTokens.bg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: KayanDesignTokens.border),
                      ),
                      child: const Icon(Icons.qr_code_2_rounded, size: 120, color: KayanDesignTokens.kBlueDeep),
                    ),
                    const SizedBox(height: 16),
                    Text(displayCode, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep)),
                    const SizedBox(height: 6),
                    Text(
                      ar ? 'اعرض هذا الرمز للفني لتأكيد الخدمة' : 'Show this code to confirm the service',
                      textAlign: TextAlign.center,
                      style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              KayanCtaButton(
                label: ar ? 'مشاركة الرمز' : 'Share code',
                variant: KayanCtaVariant.blue,
                trailingIcon: Icons.share_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم نسخ الرمز' : 'Code copied')),
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
