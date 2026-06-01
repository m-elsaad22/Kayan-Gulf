// ============================================================
// KAYAN — Post Ad Screen
// lib/features/classifieds/post_ad/presentation/screens/post_ad_screen.dart
//
// Multi-step form (PageView — 4 steps):
//   Step 1: Category selection (grid)
//   Step 2: Ad details (title, description, condition)
//   Step 3: Photos (mock picker with grid)
//   Step 4: Pricing, location, publish
//
// Features:
//   • Animated step indicator (progress bar + labels)
//   • Validation per step before advancing
//   • Free / Paid / Negotiable toggle
//   • City picker
//   • Preview before posting
//   • Success animation on publish
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../classifieds/browse/data/models/ad_models.dart';

class PostAdScreen extends ConsumerStatefulWidget {
  const PostAdScreen({super.key});

  @override
  ConsumerState<PostAdScreen> createState() => _PostAdState();
}

class _PostAdState extends ConsumerState<PostAdScreen> {
  final _pageCtrl = PageController();
  int _step = 0;

  // Form state
  AdCategory? _selectedCat;
  final _titleCtrl    = TextEditingController();
  final _descCtrl     = TextEditingController();
  AdCondition _condition = AdCondition.good;
  List<String> _photos = []; // mock — would be real file paths
  bool   _isFree       = false;
  bool   _isNegotiable = false;
  final _priceCtrl     = TextEditingController();
  String _city         = 'الرياض';
  String _district     = '';
  bool   _publishing   = false;
  bool   _published    = false;

  final _steps = ['الفئة', 'التفاصيل', 'الصور', 'النشر'];
  final _stepsEn = ['Category', 'Details', 'Photos', 'Publish'];

  final _cities = ['الرياض', 'جدة', 'مكة المكرمة', 'المدينة المنورة', 'الدمام',
    'الخبر', 'أبوظبي', 'دبي', 'الشارقة', 'الدوحة', 'الكويت'];

  @override
  void dispose() {
    _pageCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  bool _canProceed() => switch (_step) {
    0 => _selectedCat != null,
    1 => _titleCtrl.text.trim().length >= 5 && _descCtrl.text.trim().length >= 10,
    2 => true, // photos optional
    3 => _isFree || (_priceCtrl.text.trim().isNotEmpty && double.tryParse(_priceCtrl.text) != null),
    _ => false,
  };

  void _next() {
    if (!_canProceed()) {
      _showValidation();
      return;
    }
    if (_step < 3) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
      setState(() => _step++);
    } else {
      _publish();
    }
  }

  void _back() {
    if (_step > 0) {
      _pageCtrl.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  void _showValidation() {
    final isArabic = ref.read(isArabicProvider);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isArabic ? 'يرجى إكمال جميع الحقول المطلوبة' : 'Please complete all required fields'),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
    ));
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _publishing = false; _published = true; });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);

    if (_published) return _SuccessScreen(isArabic: isArabic);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle: true,
        title: Text(isArabic ? 'نشر إعلان جديد' : 'Post New Ad',
            style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(
          icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: _back,
        ),
      ),
      body: Column(children: [
        // ── Step indicator ──────────────────────────────
        _StepIndicator(step: _step, steps: isArabic ? _steps : _stepsEn),

        // ── Page content ────────────────────────────────
        Expanded(child: PageView(
          controller:    _pageCtrl,
          physics:       const NeverScrollableScrollPhysics(),
          children: [
            _Step1Category(selected: _selectedCat, isArabic: isArabic, onSelect: (c) => setState(() => _selectedCat = c)),
            _Step2Details(titleCtrl: _titleCtrl, descCtrl: _descCtrl, condition: _condition, isArabic: isArabic, onCondition: (c) => setState(() => _condition = c)),
            _Step3Photos(photos: _photos, isArabic: isArabic, onAdd: () => setState(() => _photos.add('https://picsum.photos/300?random=${_photos.length + 200}')), onRemove: (i) => setState(() => _photos.removeAt(i))),
            _Step4Publish(priceCtrl: _priceCtrl, isFree: _isFree, isNegotiable: _isNegotiable, city: _city, district: _district, cities: _cities, category: _selectedCat, isArabic: isArabic,
              onFreeToggle:   (v) => setState(() { _isFree = v; if (v) { _priceCtrl.clear(); _isNegotiable = false; } }),
              onNegotiable:   (v) => setState(() => _isNegotiable = v),
              onCityChange:   (c) => setState(() => _city = c),
              onDistrictChange:(d) => setState(() => _district = d)),
          ],
        )),

        // ── Bottom nav bar ───────────────────────────────
        _BottomNav(
          step:       _step,
          isArabic:   isArabic,
          canProceed: _canProceed(),
          publishing: _publishing,
          onBack:     _back,
          onNext:     _next,
        ),
      ]),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// STEP INDICATOR
// ──────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int          step;
  final List<String> steps;
  const _StepIndicator({required this.step, required this.steps});

  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.bgSurface,
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
    child: Column(children: [
      // Progress bar
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: (step + 1) / steps.length),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        builder: (_, v, __) => ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: v, minHeight: 4, backgroundColor: AppColors.bgCard2,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.royalBlue))),
      ),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(steps.length, (i) {
        final done    = i < step;
        final current = i == step;
        return Column(children: [
          AnimatedContainer(duration: const Duration(milliseconds: 300),
            width: current ? 28 : 22, height: current ? 28 : 22,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: (done || current) ? AppGradients.primaryButton : null,
              color:    (done || current) ? null : AppColors.bgCard2,
              border:   (done || current) ? null : Border.all(color: AppColors.borderDefault),
              boxShadow: current ? [BoxShadow(color: AppColors.royalBlue.withOpacity(0.4), blurRadius: 10)] : [],
            ),
            child: Center(child: done ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) :
              Text('${i + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: current ? Colors.white : AppColors.textMuted))),
          ),
          const SizedBox(height: 4),
          Text(steps[i], style: TextStyle(fontSize: 9, fontWeight: current ? FontWeight.w700 : FontWeight.w400, color: current ? AppColors.royalBlue : AppColors.textMuted)),
        ]);
      })),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// STEP 1 — CATEGORY
// ──────────────────────────────────────────────────────────────
class _Step1Category extends StatelessWidget {
  final AdCategory? selected;
  final bool        isArabic;
  final ValueChanged<AdCategory> onSelect;
  const _Step1Category({required this.selected, required this.isArabic, required this.onSelect});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.pagePadding),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(isArabic ? 'اختر فئة إعلانك *' : 'Select Ad Category *',
          style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
      const SizedBox(height: 6),
      Text(isArabic ? 'اختيار الفئة الصحيحة يزيد فرص البيع' : 'The right category gets you more views',
          style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary)),
      const SizedBox(height: 18),

      GridView.count(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
        children: mockAdCategories.map((cat) {
          final isSelected = selected?.id == cat.id;
          return GestureDetector(
            onTap: () { HapticFeedback.selectionClick(); onSelect(cat); },
            child: AnimatedContainer(duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient:     isSelected ? AppGradients.primaryButton : null,
                color:        isSelected ? null : AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border:       Border.all(color: isSelected ? Colors.transparent : AppColors.borderSubtle),
                boxShadow:    isSelected ? [BoxShadow(color: AppColors.royalBlue.withOpacity(0.3), blurRadius: 10)] : [],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(cat.emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 5),
                Text(isArabic ? cat.nameAr : cat.nameEn,
                    style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected ? Colors.white : AppColors.textSecondary),
                    textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
          );
        }).toList(),
      ),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// STEP 2 — DETAILS
// ──────────────────────────────────────────────────────────────
class _Step2Details extends StatelessWidget {
  final TextEditingController titleCtrl, descCtrl;
  final AdCondition            condition;
  final bool                   isArabic;
  final ValueChanged<AdCondition> onCondition;
  const _Step2Details({required this.titleCtrl, required this.descCtrl,
    required this.condition, required this.isArabic, required this.onCondition});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.pagePadding),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(isArabic ? 'تفاصيل إعلانك' : 'Ad Details',
          style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
      const SizedBox(height: 18),

      // Title
      _FieldLabel(isArabic ? 'عنوان الإعلان *' : 'Ad Title *', isArabic),
      const SizedBox(height: 8),
      TextField(
        controller: titleCtrl,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        maxLength:  60,
        style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: isArabic ? 'مثال: آيفون 15 برو ماكس 256GB...' : 'e.g. iPhone 15 Pro Max 256GB...',
          counterStyle: AppTextStyles.caption,
        ),
      ),
      const SizedBox(height: 16),

      // Description
      _FieldLabel(isArabic ? 'وصف الإعلان *' : 'Description *', isArabic),
      const SizedBox(height: 8),
      TextField(
        controller: descCtrl,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        maxLines:  5, maxLength: 1000,
        style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: isArabic ? 'اكتب وصفاً تفصيلياً للإعلان...' : 'Write a detailed description...',
          counterStyle: AppTextStyles.caption,
        ),
      ),
      const SizedBox(height: 18),

      // Condition
      _FieldLabel(isArabic ? 'حالة المنتج *' : 'Condition *', isArabic),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: AdCondition.values.map((c) {
        final isSelected = condition == c;
        return GestureDetector(
          onTap: () { HapticFeedback.selectionClick(); onCondition(c); },
          child: AnimatedContainer(duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient:     isSelected ? AppGradients.primaryButton : null,
              color:        isSelected ? null : AppColors.bgCard,
              borderRadius: AppBorderRadius.pill,
              border:       Border.all(color: isSelected ? Colors.transparent : AppColors.borderDefault),
              boxShadow:    isSelected ? [BoxShadow(color: AppColors.royalBlue.withOpacity(0.3), blurRadius: 8)] : [],
            ),
            child: Text(isArabic ? c.labelAr() : c.labelEn(),
                style: AppTextStyles.labelMedium.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary))),
        );
      }).toList()),

      const SizedBox(height: 24),
      // Tips
      Container(padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.royalBlue.withOpacity(0.07), borderRadius: AppBorderRadius.sm, border: Border.all(color: AppColors.borderActive)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.lightbulb_outline_rounded, size: 14, color: AppColors.royalBlue), SizedBox(width: 6), Text('نصيحة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.royalBlue))]),
          const SizedBox(height: 6),
          Text(isArabic ? 'الإعلانات ذات الوصف التفصيلي تُباع أسرع بـ 3 مرات!' : 'Ads with detailed descriptions sell 3x faster!',
              style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary)),
        ])),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// STEP 3 — PHOTOS
// ──────────────────────────────────────────────────────────────
class _Step3Photos extends StatelessWidget {
  final List<String> photos;
  final bool         isArabic;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  const _Step3Photos({required this.photos, required this.isArabic, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.pagePadding),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(isArabic ? 'صور الإعلان (اختياري)' : 'Ad Photos (Optional)',
          style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
      const SizedBox(height: 6),
      Text(isArabic ? 'الإعلانات بالصور تحصل على 10× مشاهدات أكثر' : 'Ads with photos get 10× more views',
          style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary)),
      const SizedBox(height: 18),

      // Photo grid
      GridView.count(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1,
        children: [
          // Add button
          GestureDetector(
            onTap: photos.length < 8 ? () { HapticFeedback.lightImpact(); onAdd(); } : null,
            child: Container(
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderActive, style: BorderStyle.solid)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_photo_alternate_outlined, size: 28, color: photos.length < 8 ? AppColors.royalBlue : AppColors.textDisabled),
                const SizedBox(height: 4),
                Text(isArabic ? 'إضافة صورة' : 'Add Photo',
                    style: AppTextStyles.labelSmall.copyWith(color: photos.length < 8 ? AppColors.royalBlue : AppColors.textDisabled),
                    textAlign: TextAlign.center),
              ]),
            ),
          ),
          // Existing photos
          ...photos.asMap().entries.map((e) => Stack(children: [
            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Image.network(e.value, fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.bgCard2, child: const Icon(Icons.image_outlined, color: AppColors.textMuted)))),
            if (e.key == 0)
              Positioned(bottom: 4, left: 4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(color: AppColors.royalBlue, borderRadius: BorderRadius.circular(5)),
                child: Text(isArabic ? 'رئيسية' : 'Main', style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w700)))),
            Positioned(top: 4, right: 4, child: GestureDetector(
              onTap: () => onRemove(e.key),
              child: Container(width: 22, height: 22, decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, size: 14, color: Colors.white)))),
          ])),
        ],
      ),

      if (photos.isNotEmpty) ...[
        const SizedBox(height: 12),
        Text(isArabic ? '${photos.length}/8 صور — اسحب لإعادة الترتيب' : '${photos.length}/8 photos — drag to reorder',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
      ],

      const SizedBox(height: 20),
      // Tip
      Container(padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.metallicGold.withOpacity(0.06), borderRadius: AppBorderRadius.sm, border: Border.all(color: AppColors.borderGold)),
        child: Row(children: [
          const Text('📸', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(isArabic ? 'الصورة الأولى ستظهر كالصورة الرئيسية في نتائج البحث.' : 'The first photo will be the thumbnail in search results.',
              style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall).copyWith(color: AppColors.textSecondary))),
        ])),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// STEP 4 — PUBLISH
// ──────────────────────────────────────────────────────────────
class _Step4Publish extends StatelessWidget {
  final TextEditingController priceCtrl;
  final bool         isFree, isNegotiable;
  final String       city, district;
  final List<String> cities;
  final AdCategory?  category;
  final bool         isArabic;
  final ValueChanged<bool>   onFreeToggle;
  final ValueChanged<bool>   onNegotiable;
  final ValueChanged<String> onCityChange;
  final ValueChanged<String> onDistrictChange;

  const _Step4Publish({
    required this.priceCtrl, required this.isFree, required this.isNegotiable,
    required this.city, required this.district, required this.cities,
    required this.category, required this.isArabic,
    required this.onFreeToggle, required this.onNegotiable,
    required this.onCityChange, required this.onDistrictChange,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.pagePadding),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(isArabic ? 'السعر والموقع' : 'Price & Location',
          style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
      const SizedBox(height: 18),

      // Free toggle
      Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.sm, border: Border.all(color: AppColors.borderSubtle)),
        child: Row(children: [
          Text(isArabic ? 'الإعلان مجاني (هدية)' : 'Give Away for Free', style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium),
          const Spacer(),
          Switch(value: isFree, onChanged: onFreeToggle),
        ])),
      const SizedBox(height: 12),

      // Price field
      AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: isFree ? 0.4 : 1,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _FieldLabel(isArabic ? 'السعر (ر.س) *' : 'Price (SAR) *', isArabic),
          const SizedBox(height: 8),
          TextField(
            controller: priceCtrl,
            enabled:    !isFree,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.metallicGold),
            decoration: InputDecoration(
              hintText: '0',
              prefixText: 'ر.س  ',
              prefixStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ),
          const SizedBox(height: 12),
          // Negotiable
          GestureDetector(
            onTap: isFree ? null : () => onNegotiable(!isNegotiable),
            child: Row(children: [
              AnimatedContainer(duration: const Duration(milliseconds: 200), width: 20, height: 20,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                  color: isNegotiable && !isFree ? AppColors.royalBlue : Colors.transparent,
                  border: Border.all(color: isNegotiable && !isFree ? AppColors.royalBlue : AppColors.borderDefault, width: 1.5)),
                child: isNegotiable && !isFree ? const Icon(Icons.check_rounded, color: Colors.white, size: 12) : null),
              const SizedBox(width: 8),
              Text(isArabic ? 'السعر قابل للتفاوض' : 'Price is negotiable',
                  style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall)
                      .copyWith(color: isFree ? AppColors.textDisabled : AppColors.textSecondary)),
            ]),
          ),
        ])),

      const SizedBox(height: 20),
      const Divider(color: AppColors.borderSubtle),
      const SizedBox(height: 16),

      // City selector
      _FieldLabel(isArabic ? 'المدينة *' : 'City *', isArabic),
      const SizedBox(height: 8),
      Container(padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: AppBorderRadius.sm, border: Border.all(color: AppColors.borderDefault)),
        child: DropdownButtonHideUnderline(child: DropdownButton<String>(
          value: city, isExpanded: true,
          dropdownColor: AppColors.bgCard,
          style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
          items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (c) { if (c != null) onCityChange(c); },
        ))),
      const SizedBox(height: 12),

      // District
      _FieldLabel(isArabic ? 'الحي (اختياري)' : 'District (Optional)', isArabic),
      const SizedBox(height: 8),
      TextField(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        onChanged: onDistrictChange,
        style: isArabic ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: isArabic ? 'مثال: حي النخيل' : 'e.g. Al-Nakhil district',
        ),
      ),

      const SizedBox(height: 20),
      const Divider(color: AppColors.borderSubtle),
      const SizedBox(height: 16),

      // Ad summary preview
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card, border: Border.all(color: AppColors.borderGold)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.preview_rounded, size: 16, color: AppColors.metallicGold),
            const SizedBox(width: 8),
            Text(isArabic ? 'معاينة إعلانك' : 'Ad Preview', style: AppTextStyles.titleSmall.copyWith(color: AppColors.metallicGold)),
          ]),
          const SizedBox(height: 10),
          const Divider(color: AppColors.borderSubtle),
          const SizedBox(height: 10),
          if (category != null) Row(children: [
            Text(category!.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(isArabic ? category!.nameAr : category!.nameEn, style: AppTextStyles.labelMedium.copyWith(color: AppColors.royalBlue)),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.location_on_rounded, size: 13, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(city, style: AppTextStyles.caption),
          ]),
          const SizedBox(height: 6),
          Text(
            isFree ? (isArabic ? 'مجاني 🎁' : 'Free 🎁') :
              priceCtrl.text.isNotEmpty ? '${priceCtrl.text} ر.س ${isNegotiable ? "(قابل للتفاوض)" : ""}' : '--',
            style: AppTextStyles.priceLarge,
          ),
        ])),

      const SizedBox(height: 16),

      // Boost upsell
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppGradients.goldPremium,
          borderRadius: AppBorderRadius.card,
          boxShadow: [BoxShadow(color: AppColors.metallicGold.withOpacity(0.2), blurRadius: 12)],
        ),
        child: Row(children: [
          const Text('⭐', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isArabic ? 'بوّس إعلانك!' : 'Boost Your Ad!', style: AppTextStyles.titleSmall.copyWith(color: AppColors.bgPrimary)),
            Text(isArabic ? 'احصل على 5× مشاهدات أكثر مقابل 25 ر.س فقط' : 'Get 5× more views for only 25 SAR',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.bgPrimary.withOpacity(0.7))),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.bgPrimary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Text(isArabic ? 'تمييز' : 'Boost', style: AppTextStyles.labelMedium.copyWith(color: AppColors.bgPrimary, fontWeight: FontWeight.w700))),
        ])),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// BOTTOM NAV
// ──────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int          step;
  final bool         isArabic, canProceed, publishing;
  final VoidCallback onBack, onNext;
  const _BottomNav({required this.step, required this.isArabic, required this.canProceed,
    required this.publishing, required this.onBack, required this.onNext});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.paddingOf(context).bottom + 12),
    decoration: const BoxDecoration(color: AppColors.bgSurface, border: Border(top: BorderSide(color: AppColors.borderSubtle)),
        boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 16, offset: Offset(0, -4))]),
    child: Row(children: [
      // Back button
      GestureDetector(
        onTap: onBack,
        child: Container(height: 50, padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.button, border: Border.all(color: AppColors.borderDefault)),
          child: Row(children: [
            Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(isArabic ? 'رجوع' : 'Back', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
          ])),
      ),
      const SizedBox(width: 12),
      // Next / Publish button
      Expanded(child: AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: canProceed ? 1.0 : 0.45,
        child: GestureDetector(
          onTap: canProceed && !publishing ? onNext : null,
          child: Container(height: 50,
            decoration: BoxDecoration(
              gradient: step == 3 ? AppGradients.goldButton : AppGradients.primaryButton,
              borderRadius: AppBorderRadius.button,
              boxShadow: canProceed ? [BoxShadow(color: (step == 3 ? AppColors.metallicGold : AppColors.royalBlue).withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))] : [],
            ),
            child: Center(child: publishing
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(step == 3 ? Icons.publish_rounded : Icons.arrow_forward_rounded, size: 18,
                      color: step == 3 ? AppColors.bgPrimary : Colors.white),
                  const SizedBox(width: 8),
                  Text(step == 3 ? (isArabic ? 'نشر الإعلان' : 'Publish Ad') : (isArabic ? 'التالي' : 'Next'),
                      style: (isArabic ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium).copyWith(
                          color: step == 3 ? AppColors.bgPrimary : Colors.white)),
                ])),
          ),
        ),
      )),
    ]),
  );
}

// ──────────────────────────────────────────────────────────────
// SUCCESS SCREEN
// ──────────────────────────────────────────────────────────────
class _SuccessScreen extends StatefulWidget {
  final bool isArabic;
  const _SuccessScreen({required this.isArabic});
  @override
  State<_SuccessScreen> createState() => _SuccessState();
}

class _SuccessState extends State<_SuccessScreen> with TickerProviderStateMixin {
  late final AnimationController _chk = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  late final Animation<double> _cs    = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)).animate(_chk);
  @override void dispose() { _chk.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final ar = widget.isArabic;
    return Scaffold(backgroundColor: AppColors.bgScaffold, body: SafeArea(child: Center(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ScaleTransition(scale: _cs, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [AppColors.metallicGold, AppColors.goldDark]),
          boxShadow: [BoxShadow(color: AppColors.metallicGold.withOpacity(0.4), blurRadius: 30, spreadRadius: 4)]),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 52))),
        const SizedBox(height: 28),
        Text(ar ? '🎉 تم نشر إعلانك!' : '🎉 Ad Published!', style: ar ? AppTextStyles.arabicHeadlineMedium : AppTextStyles.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Text(ar ? 'سيظهر إعلانك للمستخدمين فور المراجعة وهو مجاني تماماً.' : 'Your ad will appear to users after review. It\'s completely free.',
            style: (ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium).copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        const SizedBox(height: 32),
        GestureDetector(onTap: () => context.go(AppRoutes.myAds),
          child: Container(height: 50, decoration: BoxDecoration(gradient: AppGradients.primaryButton, borderRadius: AppBorderRadius.button,
            boxShadow: [BoxShadow(color: AppColors.royalBlue.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]),
            child: Center(child: Text(ar ? 'عرض إعلاناتي' : 'View My Ads', style: ar ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium)))),
        const SizedBox(height: 12),
        TextButton(onPressed: () => context.go(AppRoutes.classifieds), child: Text(ar ? 'العودة للإعلانات' : 'Back to Classifieds',
            style: (ar ? AppTextStyles.arabicBodyMedium : AppTextStyles.bodyMedium).copyWith(color: AppColors.textSecondary))),
      ]),
    ))));
  }
}

// helpers
Widget _FieldLabel(String text, bool ar) => Text(text, style: (ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall).copyWith(fontSize: 13));
