import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/widgets/design/kayan_design_widgets.dart';
import '../../shared/widgets/design/kayan_entry_widgets.dart';

class _Permission {
  const _Permission(this.icon, this.titleAr, this.titleEn, this.descAr, this.descEn);

  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
}

/// أذونات التطبيق — light design
class AppPermissionsScreen extends ConsumerStatefulWidget {
  const AppPermissionsScreen({super.key});

  @override
  ConsumerState<AppPermissionsScreen> createState() => _AppPermissionsScreenState();
}

class _AppPermissionsScreenState extends ConsumerState<AppPermissionsScreen> {
  final _enabled = <int, bool>{0: true, 1: true, 2: false, 3: false};

  static const _perms = [
    _Permission(Icons.notifications_outlined, 'الإشعارات', 'Notifications', 'تنبيهات الطلبات والعروض', 'Order and offer alerts'),
    _Permission(Icons.location_on_outlined, 'الموقع', 'Location', 'تحديد عنوان التوصيل', 'Delivery address detection'),
    _Permission(Icons.camera_alt_outlined, 'الكاميرا', 'Camera', 'رفع صور الإعلانات', 'Upload ad photos'),
    _Permission(Icons.mic_outlined, 'الميكروفون', 'Microphone', 'المكالمات داخل التطبيق', 'In-app calls'),
  ];

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: KayanDesignTokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'أذونات التطبيق' : 'App permissions', onBack: () => context.pop()),
              const SizedBox(height: 8),
              Text(ar ? 'تحكم في ما يمكن لكيان الوصول إليه' : 'Control what KAYAN can access', style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < _perms.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                            border: Border.all(color: KayanDesignTokens.border),
                          ),
                          child: Row(
                            children: [
                              Icon(_perms[i].icon, color: KayanDesignTokens.kBlue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ar ? _perms[i].titleAr : _perms[i].titleEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                                    Text(ar ? _perms[i].descAr : _perms[i].descEn, style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted)),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _enabled[i] ?? false,
                                activeThumbColor: KayanDesignTokens.kBlue,
                                onChanged: (v) => setState(() => _enabled[i] = v),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'حفظ الإعدادات' : 'Save settings',
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم حفظ الأذونات' : 'Permissions saved')),
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
