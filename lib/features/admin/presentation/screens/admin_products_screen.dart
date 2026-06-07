import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/mock/mock_products.dart';
import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/delete_confirm_dialog.dart';
import '../widgets/admin_scaffold.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  late List<MockProduct> _products;

  @override
  void initState() {
    super.initState();
    _products = AdminDataService.instance.getProducts();
  }

  Future<void> _openForm([MockProduct? product]) async {
    final categories = AdminDataService.instance.getCategories();
    final nameCtrl = TextEditingController(text: product?.titleAr ?? '');
    final descCtrl = TextEditingController(text: product?.descriptionAr ?? '');
    final priceCtrl = TextEditingController(
      text: product?.salePrice.toString() ?? '',
    );
    final origCtrl = TextEditingController(
      text: product?.originalPrice.toString() ?? '',
    );
    final imgCtrl = TextEditingController(text: product?.imageUrl ?? '');
    final ratingCtrl = TextEditingController(
      text: product?.rating.toString() ?? '4.5',
    );
    var categoryId = product?.categoryId ?? categories.first.id;
    var featured = product?.isFeatured ?? false;
    var active = product?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(product == null ? 'إضافة منتج' : 'تعديل منتج'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'اسم المنتج'),
                ),
                DropdownButtonFormField<String>(
                  value: categoryId,
                  items: categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.nameAr),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setLocal(() => categoryId = v!),
                  decoration: const InputDecoration(labelText: 'الفئة'),
                ),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'السعر (ر.س)'),
                ),
                TextField(
                  controller: origCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'السعر الأصلي'),
                ),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'الوصف'),
                ),
                TextField(
                  controller: imgCtrl,
                  decoration: const InputDecoration(labelText: 'رابط الصورة'),
                ),
                TextField(
                  controller: ratingCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'التقييم'),
                ),
                SwitchListTile(
                  title: const Text('مميز'),
                  value: featured,
                  onChanged: (v) => setLocal(() => featured = v),
                ),
                SwitchListTile(
                  title: const Text('نشط'),
                  value: active,
                  onChanged: (v) => setLocal(() => active = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );

    if (saved != true) return;

    final item = MockProduct(
      id: product?.id ?? 'prod-${DateTime.now().millisecondsSinceEpoch}',
      titleAr: nameCtrl.text,
      titleEn: product?.titleEn ?? nameCtrl.text,
      categoryId: categoryId,
      imageUrl: imgCtrl.text,
      salePrice: double.tryParse(priceCtrl.text) ?? 0,
      originalPrice: double.tryParse(origCtrl.text) ?? 0,
      descriptionAr: descCtrl.text,
      rating: double.tryParse(ratingCtrl.text) ?? 4.5,
      isFeatured: featured,
      isActive: active,
    );
    await AdminDataService.instance.upsertProduct(item);
    setState(() => _products = AdminDataService.instance.getProducts());
  }

  Future<void> _delete(MockProduct p) async {
    final ok = await DeleteConfirmDialog.show(
      context,
      title: 'حذف المنتج',
      message: 'هل تريد حذف "${p.titleAr}"؟',
      confirmLabel: 'حذف',
      cancelLabel: 'إلغاء',
    );
    if (ok == true) {
      await AdminDataService.instance.deleteProduct(p.id);
      setState(() => _products = AdminDataService.instance.getProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إدارة المنتجات',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final p = _products[i];
          final cat = AdminDataService.instance
              .getCategories()
              .where((c) => c.id == p.categoryId)
              .map((c) => c.nameAr)
              .firstOrNull;
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: p.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(p.titleAr, style: AppTextStyles.arabicBodyMedium),
              subtitle: Text('${cat ?? p.categoryId} • ${p.salePrice.toInt()} ر.س'),
              trailing: PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') _openForm(p);
                  if (v == 'delete') _delete(p);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('تعديل')),
                  PopupMenuItem(value: 'delete', child: Text('حذف')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
