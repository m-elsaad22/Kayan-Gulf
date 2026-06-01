// KAYAN — Edit Profile Screen
// lib/features/profile/presentation/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/providers/locale_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfileScreen> {
  final _firstCtrl  = TextEditingController(text: 'محمود');
  final _lastCtrl   = TextEditingController(text: 'السعد');
  final _emailCtrl  = TextEditingController(text: 'mahmoud@example.com');
  final _phoneCtrl  = TextEditingController(text: '+966 50 123 4567');
  final _bioCtrl    = TextEditingController(text: 'مطور WordPress ومهتم بالتقنية');
  bool  _saving     = false;
  String _gender    = 'male';

  @override
  void dispose() {
    _firstCtrl.dispose(); _lastCtrl.dispose();
    _emailCtrl.dispose(); _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ref.read(isArabicProvider) ? 'تم حفظ التغييرات ✓' : 'Changes saved ✓'),
        backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
      ));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,
        appBar: AppBar(
          backgroundColor: AppColors.bgSurface, centerTitle: true,
          title: Text(ar ? 'تعديل الملف الشخصي' : 'Edit Profile', style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
          leading: IconButton(icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
          actions: [TextButton(onPressed: _saving ? null : _save, child: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.royalBlue))
              : Text(ar ? 'حفظ' : 'Save', style: AppTextStyles.labelLarge.copyWith(color: AppColors.royalBlue)))],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // Avatar editor
            Center(child: Stack(children: [
              Container(width: 90, height: 90, decoration: BoxDecoration(gradient: AppGradients.primaryButton, shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderGold, width: 2)),
                child: const Center(child: Text('م', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: Colors.white)))),
              Positioned(bottom: 0, right: 0, child: GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(width: 28, height: 28, decoration: BoxDecoration(gradient: AppGradients.goldButton, shape: BoxShape.circle, border: Border.all(color: AppColors.bgScaffold, width: 2)),
                  child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white)))),
            ])),
            const SizedBox(height: 28),

            // First name
            _Label(ar ? 'الاسم الأول *' : 'First Name *', ar),
            const SizedBox(height: 8),
            TextField(controller: _firstCtrl, textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
                style: ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
                decoration: InputDecoration(hintText: ar ? 'مثال: محمود' : 'e.g. Ahmed')),
            const SizedBox(height: 16),

            // Last name
            _Label(ar ? 'اسم العائلة *' : 'Last Name *', ar),
            const SizedBox(height: 8),
            TextField(controller: _lastCtrl, textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
                style: ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium),
            const SizedBox(height: 16),

            // Email
            _Label(ar ? 'البريد الإلكتروني' : 'Email Address', ar),
            const SizedBox(height: 8),
            TextField(controller: _emailCtrl, textDirection: TextDirection.ltr, keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.bodyMedium, decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined, size: 18, color: AppColors.textMuted))),
            const SizedBox(height: 16),

            // Phone (read-only)
            _Label(ar ? 'رقم الهاتف' : 'Phone Number', ar),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(color: AppColors.bgCard2, borderRadius: AppBorderRadius.sm, border: Border.all(color: AppColors.borderSubtle)),
              child: Row(children: [
                const Icon(Icons.phone_outlined, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(_phoneCtrl.text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                const Spacer(),
                Text(ar ? 'محمي' : 'Protected', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
              ])),
            const SizedBox(height: 16),

            // Gender
            _Label(ar ? 'الجنس' : 'Gender', ar),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: GestureDetector(onTap: () => setState(() => _gender = 'male'),
                child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: _gender == 'male' ? AppColors.royalBlue.withOpacity(0.1) : AppColors.bgCard,
                    borderRadius: AppBorderRadius.sm, border: Border.all(color: _gender == 'male' ? AppColors.borderActive : AppColors.borderSubtle, width: _gender == 'male' ? 1.5 : 1)),
                  child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.male_rounded, size: 18, color: _gender == 'male' ? AppColors.royalBlue : AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(ar ? 'ذكر' : 'Male', style: TextStyle(fontSize: 13, color: _gender == 'male' ? AppColors.royalBlue : AppColors.textSecondary, fontWeight: _gender == 'male' ? FontWeight.w600 : FontWeight.w400)),
                  ])))),
              const SizedBox(width: 10),
              Expanded(child: GestureDetector(onTap: () => setState(() => _gender = 'female'),
                child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: _gender == 'female' ? AppColors.error.withOpacity(0.08) : AppColors.bgCard,
                    borderRadius: AppBorderRadius.sm, border: Border.all(color: _gender == 'female' ? AppColors.error : AppColors.borderSubtle, width: _gender == 'female' ? 1.5 : 1)),
                  child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.female_rounded, size: 18, color: _gender == 'female' ? AppColors.error : AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(ar ? 'أنثى' : 'Female', style: TextStyle(fontSize: 13, color: _gender == 'female' ? AppColors.error : AppColors.textSecondary, fontWeight: _gender == 'female' ? FontWeight.w600 : FontWeight.w400)),
                  ])))),
            ]),
            const SizedBox(height: 16),

            // Bio
            _Label(ar ? 'نبذة عنك (اختياري)' : 'Bio (Optional)', ar),
            const SizedBox(height: 8),
            TextField(controller: _bioCtrl, maxLines: 3, maxLength: 150,
                textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
                style: ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
                decoration: InputDecoration(hintText: ar ? 'اكتب نبذة مختصرة عنك...' : 'Write a short bio...')),
            const SizedBox(height: 28),

            // Save button
            GestureDetector(onTap: _saving ? null : _save,
              child: Container(height: 52, decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: AppBorderRadius.button,
                  boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]),
                child: Center(child: _saving ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(ar ? 'حفظ التغييرات' : 'Save Changes', style: ar ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium)))),
          ]),
        ),
      ),
    );
  }
}

Widget _Label(String text, bool ar) => Text(text, style: (ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall).copyWith(fontSize: 13));
