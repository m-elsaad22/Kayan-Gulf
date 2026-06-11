import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routing/app_routes.dart';
import '../services/design_engine_service.dart';
import '../widgets/super_admin_shell.dart';

class TypographyScreen extends StatefulWidget {
  const TypographyScreen({super.key});

  @override
  State<TypographyScreen> createState() => _TypographyScreenState();
}

class _TypographyScreenState extends State<TypographyScreen> {
  late TypographySettings _typo;

  @override
  void initState() {
    super.initState();
    _typo = DesignEngineService.instance.settings.typography;
  }

  TextStyle _ar(double size) {
    switch (_typo.arabicFont) {
      case 'Tajawal':
        return GoogleFonts.tajawal(fontSize: size);
      case 'Almarai':
        return GoogleFonts.almarai(fontSize: size);
      case 'Noto Kufi Arabic':
        return GoogleFonts.notoKufiArabic(fontSize: size);
      default:
        return GoogleFonts.cairo(fontSize: size);
    }
  }

  TextStyle _en(double size) {
    switch (_typo.englishFont) {
      case 'Inter':
        return GoogleFonts.inter(fontSize: size);
      case 'Roboto':
        return GoogleFonts.roboto(fontSize: size);
      case 'Lato':
        return GoogleFonts.lato(fontSize: size);
      default:
        return GoogleFonts.poppins(fontSize: size);
    }
  }

  Future<void> _apply() async {
    final next = DesignEngineService.instance.settings.copyWith(typography: _typo);
    await DesignEngineService.instance.applyNow(next, activity: 'تحديث نظام الخطوط');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تطبيق الخطوط')),
      );
    }
  }

  Widget _levelSlider(String title, TypographyLevel level, void Function(TypographyLevel) onChanged) {
    return Card(
      color: AppColors.bgCard.withValues(alpha: 0.75),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('فاتح: ${level.lightMin.round()}-${level.lightMax.round()} | داكن: ${level.darkMin.round()}-${level.darkMax.round()}'),
            Row(
              children: [
                const Text('فاتح', style: TextStyle(fontSize: 11)),
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(level.lightMin, level.lightMax),
                    min: 10,
                    max: 100,
                    onChanged: (r) => setState(() {
                      onChanged(level.copyWith(lightMin: r.start, lightMax: r.end));
                    }),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('داكن', style: TextStyle(fontSize: 11)),
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(level.darkMin, level.darkMax),
                    min: 10,
                    max: 100,
                    onChanged: (r) => setState(() {
                      onChanged(level.copyWith(darkMin: r.start, darkMax: r.end));
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supportsArabic =
        TypographySettings.arabicSupportedFonts.contains(_typo.arabicFont);

    return SuperAdminShell(
      title: 'نظام الخطوط الذكي',
      currentRoute: AppRoutes.superAdminTypography,
      actions: [
        IconButton(icon: const Icon(Icons.check), onPressed: _apply),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.bgCard.withValues(alpha: 0.75),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _typo.arabicFont,
                    decoration: const InputDecoration(labelText: 'خط عربي', filled: true),
                    items: TypographySettings.arabicFonts
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (v) => setState(() => _typo = _typo.copyWith(arabicFont: v)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _typo.englishFont,
                    decoration: const InputDecoration(labelText: 'خط إنجليزي', filled: true),
                    items: TypographySettings.englishFonts
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (v) => setState(() => _typo = _typo.copyWith(englishFont: v)),
                  ),
                  if (!supportsArabic)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '⚠️ هذا الخط قد لا يدعم العربية بشكل كامل',
                        style: TextStyle(color: AppColors.warning),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.bgCard.withValues(alpha: 0.8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('معاينة حية', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text('مرحباً بك في كيان', style: _ar(_typo.headlineLarge.sizeFor(false))),
                  Text('Welcome to KAYAN', style: _en(_typo.headlineMedium.sizeFor(false))),
                  const SizedBox(height: 8),
                  Text(
                    'كيان KAYAN السوبر أب الخليجي',
                    style: _ar(_typo.bodyLarge.sizeFor(false)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'معاينة جملة كاملة: كيان يجمع التسوق والخدمات والإعلانات في تجربة فاخرة واحدة.',
                    style: _ar(_typo.bodyMedium.sizeFor(false)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Hierarchy Typography', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          _levelSlider('Display Large', _typo.displayLarge, (l) => _typo = _typo.copyWith(displayLarge: l)),
          _levelSlider('Display Medium', _typo.displayMedium, (l) => _typo = _typo.copyWith(displayMedium: l)),
          _levelSlider('Headline Large', _typo.headlineLarge, (l) => _typo = _typo.copyWith(headlineLarge: l)),
          _levelSlider('Headline Medium', _typo.headlineMedium, (l) => _typo = _typo.copyWith(headlineMedium: l)),
          _levelSlider('Title Large', _typo.titleLarge, (l) => _typo = _typo.copyWith(titleLarge: l)),
          _levelSlider('Body Large', _typo.bodyLarge, (l) => _typo = _typo.copyWith(bodyLarge: l)),
          _levelSlider('Body Medium', _typo.bodyMedium, (l) => _typo = _typo.copyWith(bodyMedium: l)),
          _levelSlider('Label Large', _typo.labelLarge, (l) => _typo = _typo.copyWith(labelLarge: l)),
          const SizedBox(height: 8),
          Card(
            color: AppColors.bgCard.withValues(alpha: 0.7),
            child: ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('إحصائيات الخطوط'),
              subtitle: Text(
                'العربي: ${_typo.arabicFont} | الإنجليزي: ${_typo.englishFont}\n'
                'أكثر استخداماً في كيان: Cairo + Poppins',
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _apply, child: const Text('تطبيق الخطوط الآن')),
        ],
      ),
    );
  }
}
