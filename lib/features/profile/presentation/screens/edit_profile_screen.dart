// Edit profile — light design (13-profile edit)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameCtrl  = TextEditingController(text: LocalStorageService.userName  ?? '');
  late final TextEditingController _emailCtrl = TextEditingController(text: LocalStorageService.userEmail ?? '');
  late final TextEditingController _phoneCtrl = TextEditingController(text: LocalStorageService.userPhone ?? '');
  final _bioCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    // Persist the edits to local storage
    final uid   = LocalStorageService.userId ?? '';
    final token = LocalStorageService.accessToken ?? '';
    await LocalStorageService.saveAuth(
      userId:          uid,
      accessToken:     token,
      refreshToken:    LocalStorageService.refreshToken ?? '',
      profileComplete: true,
      userName:        _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : null,
      userEmail:       _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null,
      userPhone:       _phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : null,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ref.read(isArabicProvider) ? 'تم حفظ التغييرات' : 'Changes saved'), behavior: SnackBarBehavior.floating),
    );
    context.pop();
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
              KayanLightTopBar(title: ar ? 'تعديل الملف' : 'Edit profile', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(
                              (LocalStorageService.userName ?? 'ك').trim().isNotEmpty
                                  ? (LocalStorageService.userName ?? 'ك').trim()[0]
                                  : 'ك',
                              style: KayanDesignTokens.cairo(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(gradient: KayanDesignTokens.gradGold, shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    KayanDesignTextField(label: ar ? 'الاسم' : 'Name', hint: ar ? 'الاسم الكامل' : 'Full name', icon: Icons.person_outline_rounded, controller: _nameCtrl),
                    const SizedBox(height: 14),
                    KayanDesignTextField(label: ar ? 'البريد' : 'Email', hint: 'email@example.com', icon: Icons.email_outlined, controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 14),
                    KayanDesignTextField(label: ar ? 'الجوال' : 'Phone', hint: '+966', icon: Icons.phone_outlined, controller: _phoneCtrl, keyboardType: TextInputType.phone),
                    const SizedBox(height: 14),
                    KayanDesignTextField(label: ar ? 'نبذة' : 'Bio', hint: ar ? 'اكتب نبذة قصيرة' : 'Short bio', icon: Icons.notes_rounded, controller: _bioCtrl),
                  ],
                ),
              ),
              KayanCtaButton(
                label: ar ? 'حفظ التغييرات' : 'Save changes',
                trailingIcon: Icons.check_rounded,
                variant: KayanCtaVariant.blue,
                loading: _saving,
                onPressed: _saving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
