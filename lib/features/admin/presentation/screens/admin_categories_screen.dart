import 'package:flutter/material.dart';

import '../../../../core/data/mock/mock_products.dart';
import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/admin_scaffold.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  late List<MockProductCategory> _categories;

  @override
  void initState() {
    super.initState();
    _categories = AdminDataService.instance.getCategories();
  }

  Future<void> _openForm([MockProductCategory? cat]) async {
    final nameAr = TextEditingController(text: cat?.nameAr ?? '');
    final nameEn = TextEditingController(text: cat?.nameEn ?? '');
    final img = TextEditingController(text: cat?.imageUrl ?? '');
    final subs = TextEditingController(
      text: cat?.subcategories.join(', ') ?? '',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(cat == null ? 'إضافة فئة' : 'تعديل فئة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameAr,
              decoration: const InputDecoration(labelText: 'الاسم بالعربية'),
            ),
            TextField(
              controller: nameEn,
              decoration: const InputDecoration(labelText: 'الاسم بالإنجليزية'),
            ),
            TextField(
              controller: img,
              decoration: const InputDecoration(labelText: 'رابط الصورة'),
            ),
            TextField(
              controller: subs,
              decoration: const InputDecoration(
                labelText: 'الفئات الفرعية (مفصولة بفاصلة)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (saved != true) return;

    final item = MockProductCategory(
      id: cat?.id ?? 'cat-${DateTime.now().millisecondsSinceEpoch}',
      nameAr: nameAr.text,
      nameEn: nameEn.text,
      imageUrl: img.text,
      subcategories: subs.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
    );
    final list = List<MockProductCategory>.from(_categories);
    final i = list.indexWhere((c) => c.id == item.id);
    if (i >= 0) {
      list[i] = item;
    } else {
      list.add(item);
    }
    await AdminDataService.instance.saveCategories(list);
    setState(() => _categories = AdminDataService.instance.getCategories());
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إدارة الفئات',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final c = _categories[i];
          return Card(
            child: ListTile(
              title: Text(c.nameAr, style: AppTextStyles.arabicTitleSmall),
              subtitle: Text('${c.nameEn}\n${c.subcategories.join(' • ')}'),
              isThreeLine: c.subcategories.isNotEmpty,
              onTap: () => _openForm(c),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final list = List<MockProductCategory>.from(_categories)
                    ..removeAt(i);
                  await AdminDataService.instance.saveCategories(list);
                  setState(
                    () => _categories = AdminDataService.instance.getCategories(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
