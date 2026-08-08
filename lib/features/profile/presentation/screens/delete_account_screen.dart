import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

/// حذف الحساب — light design
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _confirm = TextEditingController();
  bool _understood = false;

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

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
              KayanLightTopBar(title: ar ? 'حذف الحساب' : 'Delete account', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: KayanDesignTokens.danger.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
                        border: Border.all(color: KayanDesignTokens.danger.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: KayanDesignTokens.danger),
                              const SizedBox(width: 8),
                              Text(ar ? 'تحذير' : 'Warning', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.danger)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ar
                                ? 'حذف الحساب نهائي. ستفقد طلباتك، محفظتك، وإعلاناتك.'
                                : 'Account deletion is permanent. You will lose orders, wallet balance, and listings.',
                            style: KayanDesignTokens.cairo(color: KayanDesignTokens.text2, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    KayanDesignTextField(
                      controller: _confirm,
                      label: ar ? 'اكتب «حذف» للتأكيد' : 'Type DELETE to confirm',
                      hint: ar ? 'حذف' : 'DELETE',
                      icon: Icons.edit_outlined,
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _understood,
                      onChanged: (v) => setState(() => _understood = v ?? false),
                      title: Text(
                        ar ? 'أفهم أن هذا الإجراء لا يمكن التراجع عنه' : 'I understand this cannot be undone',
                        style: KayanDesignTokens.cairo(fontSize: 13),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'حذف حسابي نهائياً' : 'Delete my account',
                trailingIcon: Icons.delete_forever_rounded,
                variant: KayanCtaVariant.blue,
                onPressed: () {
                  final ok = ar ? _confirm.text.trim() == 'حذف' : _confirm.text.trim().toUpperCase() == 'DELETE';
                  if (!ok || !_understood) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ar ? 'أكمل التأكيد أولاً' : 'Complete confirmation first')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم إرسال طلب الحذف' : 'Deletion request submitted')),
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
