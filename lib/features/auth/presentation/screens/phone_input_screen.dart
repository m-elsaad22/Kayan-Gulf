import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../providers/auth_providers.dart';

class _Country {
  const _Country({
    required this.code,
    required this.flag,
    required this.name,
    required this.nameAr,
    required this.maxLength,
  });

  final String code;
  final String flag;
  final String name;
  final String nameAr;
  final int maxLength;
}

const _countries = [
  _Country(code: '+966', flag: '🇸🇦', name: 'Saudi Arabia', nameAr: 'السعودية', maxLength: 9),
  _Country(code: '+971', flag: '🇦🇪', name: 'UAE', nameAr: 'الإمارات', maxLength: 9),
  _Country(code: '+974', flag: '🇶🇦', name: 'Qatar', nameAr: 'قطر', maxLength: 8),
  _Country(code: '+965', flag: '🇰🇼', name: 'Kuwait', nameAr: 'الكويت', maxLength: 8),
  _Country(code: '+973', flag: '🇧🇭', name: 'Bahrain', nameAr: 'البحرين', maxLength: 8),
  _Country(code: '+968', flag: '🇴🇲', name: 'Oman', nameAr: 'عُمان', maxLength: 8),
];

/// إدخال رقم الجوال — light design
class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _phoneCtrl = TextEditingController();
  _Country _selected = _countries.first;
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool get _isValid {
    final digits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 8 && digits.length <= _selected.maxLength;
  }

  Future<void> _sendOtp() async {
    if (!_isValid) return;
    HapticFeedback.selectionClick();
    setState(() => _loading = true);
    final phone = '${_selected.code}${_phoneCtrl.text.trim()}';
    final ok = await ref.read(sendOtpProvider.notifier).sendOtp(phone);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) context.push(AppRoutes.otpVerify, extra: phone);
  }

  void _pickCountry() {
    final ar = ref.read(isArabicProvider);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                ar ? 'اختر الدولة' : 'Select country',
                style: KayanDesignTokens.cairo(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            for (final c in _countries)
              ListTile(
                leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                title: Text(ar ? c.nameAr : c.name, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700)),
                trailing: Text(c.code, style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted)),
                onTap: () {
                  setState(() => _selected = c);
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final otpState = ref.watch(sendOtpProvider);

    return KayanEntryScaffold(
      smallHero: true,
      heroHeight: 200,
      hero: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              ),
            ),
            const KayanBrandLogo(size: 52),
            const SizedBox(height: 12),
            KayanEntryTitle(before: ar ? 'أدخل ' : 'Enter your ', highlight: ar ? 'رقم الجوال' : 'phone'),
            const SizedBox(height: 6),
            KayanEntrySubtitle(ar ? 'سنرسل لك رمز تحقق عبر SMS' : 'We will send you a verification code via SMS'),
          ],
        ),
      ),
      sheet: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(ar ? 'رقم الجوال' : 'Phone number', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlueDeep)),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: _pickCountry,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: KayanDesignTokens.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: KayanDesignTokens.border),
                  ),
                  child: Row(
                    children: [
                      Text(_selected.flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(_selected.code, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800)),
                      Icon(Icons.keyboard_arrow_down_rounded, color: KayanDesignTokens.muted, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: KayanDesignTokens.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: KayanDesignTokens.border),
                  ),
                  child: TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                    style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: ar ? '5XXXXXXXX' : '5XXXXXXXX',
                      border: InputBorder.none,
                      hintStyle: KayanDesignTokens.cairo(color: KayanDesignTokens.muted),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (otpState.error != null) ...[
            const SizedBox(height: 10),
            Text(otpState.error!, style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.danger)),
          ],
          const SizedBox(height: 20),
          KayanCtaButton(
            label: ar ? 'إرسال الرمز' : 'Send code',
            loading: _loading,
            variant: KayanCtaVariant.blue,
            trailingIcon: Icons.sms_outlined,
            onPressed: _isValid && !_loading ? _sendOtp : null,
          ),
        ],
      ),
    );
  }
}
