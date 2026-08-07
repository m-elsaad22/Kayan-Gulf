// Post ad — matches design/html/116-cl-add-ad.html
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/ad_models.dart';

class PostAdScreen extends ConsumerStatefulWidget {
  const PostAdScreen({super.key, this.editAdId});

  final String? editAdId;

  @override
  ConsumerState<PostAdScreen> createState() => _PostAdScreenState();
}

class _PostAdScreenState extends ConsumerState<PostAdScreen> {
  final _titleCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  String? _categorySlug;
  bool _publishing = false;
  int _photoCount = 0;

  @override
  void initState() {
    super.initState();
    final editId = widget.editAdId;
    if (editId == null) return;

    AdModel? ad;
    for (final item in mockAds) {
      if (item.id == editId) {
        ad = item;
        break;
      }
    }
    ad ??= mockMyAds.where((m) => m.ad.id == editId).map((m) => m.ad).firstOrNull;
    ad ??= mockAds.first;

    _categorySlug = ad.categorySlug;
    _titleCtrl.text = ad.title;
    if (ad.price != null) _priceCtrl.text = ad.price!.toStringAsFixed(0);
    _descCtrl.text = ad.description ?? '';
    _locationCtrl.text = ad.district.isNotEmpty ? '${ad.city}، ${ad.district}' : ad.city;
    _photoCount = ad.imageUrls.isEmpty ? 0 : ad.imageUrls.length.clamp(1, 8);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    setState(() => _photoCount = (_photoCount + 1).clamp(0, 8));
  }

  Future<void> _publish() async {
    final ar = ref.read(isArabicProvider);
    if (_categorySlug == null || _titleCtrl.text.trim().length < 3) {
      _snack(ar ? 'اختر القسم وأدخل عنواناً' : 'Select category and enter a title');
      return;
    }
    setState(() => _publishing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _publishing = false);
    if (widget.editAdId != null) {
      context.pop();
      _snack(ar ? 'تم حفظ التعديلات' : 'Changes saved');
      return;
    }
    context.push(AppRoutes.postAdSuccess);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final categories = mockAdCategories.take(6).toList();

    final isEdit = widget.editAdId != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(
                title: isEdit ? (ar ? 'تعديل الإعلان' : 'Edit ad') : (ar ? 'أضف إعلانك' : 'Post your ad'),
                onBack: () => context.pop(),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: _pickPhotos,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: KayanDesignTokens.border, width: 2, strokeAlign: BorderSide.strokeAlignInside),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.photo_camera_outlined, size: 30, color: KayanDesignTokens.kBlue),
                            const SizedBox(height: 10),
                            Text(
                              ar ? 'أضف صور المنتج (حتى 8 صور)' : 'Add product photos (up to 8)',
                              style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.text2),
                            ),
                            if (_photoCount > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  ar ? '$_photoCount صور مُضافة' : '$_photoCount photos added',
                                  style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: KayanDesignTokens.kBlue),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      ar ? 'القسم' : 'Category',
                      style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showCategoryPicker(ar, categories),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: KayanDesignTokens.bg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: KayanDesignTokens.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.list_rounded, size: 16, color: KayanDesignTokens.kBlue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _categorySlug == null
                                    ? (ar ? 'اختر القسم — سيارات' : 'Choose category — Cars')
                                    : (ar
                                        ? categories.firstWhere((c) => c.slug == _categorySlug).nameAr
                                        : categories.firstWhere((c) => c.slug == _categorySlug).nameEn),
                                style: KayanDesignTokens.cairo(fontSize: 15, color: KayanDesignTokens.text),
                              ),
                            ),
                            const Icon(Icons.expand_more_rounded, color: KayanDesignTokens.muted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    KayanDesignTextField(
                      label: ar ? 'عنوان الإعلان' : 'Ad title',
                      hint: ar ? 'مثال: تويوتا كامري 2023' : 'e.g. Toyota Camry 2023',
                      icon: Icons.title_rounded,
                      controller: _titleCtrl,
                    ),
                    const SizedBox(height: 16),
                    KayanDesignTextField(
                      label: ar ? 'السعر' : 'Price',
                      hint: ar ? 'السعر بالريال' : 'Price in SAR',
                      icon: Icons.sell_outlined,
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _DescriptionField(ar: ar, controller: _descCtrl),
                    const SizedBox(height: 16),
                    KayanDesignTextField(
                      label: ar ? 'الموقع' : 'Location',
                      hint: ar ? 'المدينة والحي' : 'City and district',
                      icon: Icons.location_on_outlined,
                      controller: _locationCtrl,
                    ),
                  ],
                ),
              ),
              KayanCtaButton(
                label: isEdit ? (ar ? 'حفظ التعديلات' : 'Save changes') : (ar ? 'نشر الإعلان' : 'Publish ad'),
                trailingIcon: Icons.arrow_back_rounded,
                variant: KayanCtaVariant.blue,
                loading: _publishing,
                onPressed: _publishing ? null : _publish,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker(bool ar, List<AdCategory> categories) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: categories
              .map(
                (c) => ListTile(
                  title: Text(ar ? c.nameAr : c.nameEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w700)),
                  trailing: Text(c.emoji, style: const TextStyle(fontSize: 20)),
                  onTap: () {
                    setState(() => _categorySlug = c.slug);
                    Navigator.pop(ctx);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.ar, required this.controller});

  final bool ar;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          ar ? 'الوصف' : 'Description',
          style: KayanDesignTokens.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: KayanDesignTokens.text2),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          height: 120,
          decoration: BoxDecoration(
            color: KayanDesignTokens.bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KayanDesignTokens.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.format_align_right_rounded, size: 16, color: KayanDesignTokens.kBlue),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 5,
                  style: KayanDesignTokens.cairo(fontSize: 15, color: KayanDesignTokens.text),
                  decoration: InputDecoration(
                    hintText: ar ? 'اكتب تفاصيل الإعلان...' : 'Write ad details...',
                    hintStyle: KayanDesignTokens.cairo(fontSize: 15, color: const Color(0xFFA9B7CC)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
