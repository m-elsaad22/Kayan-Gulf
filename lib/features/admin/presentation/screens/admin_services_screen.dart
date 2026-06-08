import 'package:flutter/material.dart';

import '../../../../core/services/admin_data_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/admin_scaffold.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  late List<AdminServiceItem> _services;

  @override
  void initState() {
    super.initState();
    _services = AdminDataService.instance.getServices();
  }

  Future<void> _openForm([AdminServiceItem? s]) async {
    final nameAr = TextEditingController(text: s?.nameAr ?? '');
    final cat = TextEditingController(text: s?.categorySlug ?? 'ac');
    final price = TextEditingController(text: s?.price.toString() ?? '');
    final desc = TextEditingController(text: s?.descriptionAr ?? '');
    final img = TextEditingController(text: s?.imageUrl ?? '');
    final dur = TextEditingController(text: '${s?.durationMin ?? 60}');
    final rating = TextEditingController(text: '${s?.rating ?? 4.5}');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s == null ? 'إضافة خدمة' : 'تعديل خدمة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameAr, decoration: const InputDecoration(labelText: 'اسم الخدمة')),
              TextField(controller: cat, decoration: const InputDecoration(labelText: 'الفئة')),
              TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السعر')),
              TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(labelText: 'الوصف')),
              TextField(controller: img, decoration: const InputDecoration(labelText: 'رابط الصورة')),
              TextField(controller: dur, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المدة (دقيقة)')),
              TextField(controller: rating, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'التقييم')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (saved != true) return;

    final item = AdminServiceItem(
      id: s?.id ?? 'svc-${DateTime.now().millisecondsSinceEpoch}',
      nameAr: nameAr.text,
      nameEn: s?.nameEn ?? nameAr.text,
      categorySlug: cat.text,
      price: double.tryParse(price.text) ?? 0,
      descriptionAr: desc.text,
      imageUrl: img.text,
      durationMin: int.tryParse(dur.text) ?? 60,
      rating: double.tryParse(rating.text) ?? 4.5,
    );
    final list = List<AdminServiceItem>.from(_services);
    final i = list.indexWhere((x) => x.id == item.id);
    if (i >= 0) {
      list[i] = item;
    } else {
      list.add(item);
    }
    await AdminDataService.instance.saveServices(list);
    setState(() => _services = AdminDataService.instance.getServices());
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'إدارة الخدمات',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _services.length,
        itemBuilder: (_, i) {
          final s = _services[i];
          return Card(
            child: ListTile(
              title: Text(s.nameAr, style: AppTextStyles.arabicTitleSmall),
              subtitle: Text('${s.categorySlug} • ${s.price.toInt()} ر.س • ${s.durationMin} د'),
              onTap: () => _openForm(s),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final list = List<AdminServiceItem>.from(_services)..removeAt(i);
                  await AdminDataService.instance.saveServices(list);
                  setState(() => _services = AdminDataService.instance.getServices());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
