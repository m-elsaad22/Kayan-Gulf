import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// 87-pr-devices — الأجهزة المتصلة
class ConnectedDevicesScreen extends StatelessWidget {
  const ConnectedDevicesScreen({super.key});

  static const _devices = [
    ('iPhone 15 Pro', 'هذا الجهاز · الرياض', true),
    ('MacBook Pro', 'آخر نشاط: أمس', false),
    ('iPad Air', 'آخر نشاط: منذ 3 أيام', false),
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
              KayanLightTopBar(title: 'الأجهزة المتصلة', onBack: () => context.pop()),
              const SizedBox(height: 12),
              Text(
                'الأجهزة التي سجّلت الدخول منها إلى حسابك',
                style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final d in _devices)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: KayanDesignTokens.surface,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            border: Border.all(color: KayanDesignTokens.border),
                            boxShadow: KayanDesignTokens.shadowS,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: KayanDesignTokens.kBlue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  d.$1.contains('iPhone') || d.$1.contains('iPad')
                                      ? Icons.phone_iphone_rounded
                                      : Icons.laptop_mac_rounded,
                                  color: KayanDesignTokens.kBlue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(d.$1, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                        if (d.$3) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: KayanDesignTokens.success.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'الحالي',
                                              style: KayanDesignTokens.cairo(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                color: KayanDesignTokens.success,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      d.$2,
                                      style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted),
                                    ),
                                  ],
                                ),
                              ),
                              if (!d.$3)
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('تم إنهاء جلسة ${d.$1}')),
                                    );
                                  },
                                  child: Text(
                                    'إنهاء',
                                    style: KayanDesignTokens.cairo(color: KayanDesignTokens.danger),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: 'إنهاء جميع الجلسات الأخرى',
                trailingIcon: Icons.logout_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إنهاء جميع الجلسات الأخرى')),
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
