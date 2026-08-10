import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/rukn_brand.dart';
import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// 90-pr-contact — تواصل مع الدعم
class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _subject = TextEditingController();
  final _message = TextEditingController();
  String _topic = 'عام';

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: 'تواصل مع الدعم', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ContactChip(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'محادثة',
                            onTap: () => context.push(AppRoutes.liveChat),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ContactChip(
                            icon: Icons.phone_outlined,
                            label: 'اتصال',
                            onTap: () async {
                              final tel = RuknBrand.phoneUri();
                              if (tel != null) {
                                await launchUrl(tel);
                                return;
                              }
                              final wa = RuknBrand.whatsappUri();
                              if (wa != null) {
                                await launchUrl(
                                  wa,
                                  mode: LaunchMode.externalApplication,
                                );
                                return;
                              }
                              await launchUrl(
                                RuknBrand.supportUri(),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('أرسل رسالة', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _topic,
                      decoration: InputDecoration(
                        labelText: 'نوع الاستفسار',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        ),
                      ),
                      items: ['عام', 'طلب', 'دفع', 'حساب']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => _topic = v ?? 'عام'),
                    ),
                    const SizedBox(height: 14),
                    KayanDesignTextField(
                      controller: _subject,
                      label: 'الموضوع',
                      hint: 'موضوع الرسالة',
                      icon: Icons.subject_rounded,
                    ),
                    const SizedBox(height: 14),
                    KayanDesignTextField(
                      controller: _message,
                      label: 'التفاصيل',
                      hint: 'اشرح مشكلتك بالتفصيل...',
                      icon: Icons.notes_rounded,
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: 'إرسال',
                trailingIcon: Icons.send_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال رسالتك — سنرد خلال 24 ساعة')),
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

class _ContactChip extends StatelessWidget {
  const _ContactChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: KayanDesignTokens.surface,
      borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
            border: Border.all(color: KayanDesignTokens.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: KayanDesignTokens.kBlue, size: 28),
              const SizedBox(height: 8),
              Text(label, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
