// KAYAN — Addresses Screen
// lib/features/profile/presentation/screens/addresses_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';

class _Address {
  final String id, label, name, phone, city, street;
  final bool isDefault;
  const _Address({required this.id, required this.label, required this.name,
    required this.phone, required this.city, required this.street, this.isDefault = false});
}

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});
  @override ConsumerState<AddressesScreen> createState() => _AS();
}

class _AS extends ConsumerState<AddressesScreen> {
  late List<_Address> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = [
      const _Address(id:'1', label:'🏠 المنزل', name:'محمود السعد', phone:'+966 50 123 4567', city:'الرياض', street:'شارع الملك فهد، حي النخيل', isDefault:true),
      const _Address(id:'2', label:'🏢 العمل', name:'محمود السعد', phone:'+966 50 123 4567', city:'الرياض', street:'برج المملكة، حي العليا'),
    ];
  }

  void _setDefault(String id) => setState(() {
    _addresses = _addresses.map((a) => _Address(id:a.id, label:a.label, name:a.name, phone:a.phone, city:a.city, street:a.street, isDefault:a.id==id)).toList();
  });

  void _delete(String id) => setState(() => _addresses = _addresses.where((a) => a.id != id).toList());

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface, centerTitle: true,
        title: Text(ar ? 'عناويني' : 'My Addresses', style: ar ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        leading: IconButton(icon: Icon(ar ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => context.pop()),
      ),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(AppSpacing.pagePadding), children: [
          ..._addresses.map((addr) => Dismissible(
            key: ValueKey(addr.id),
            direction: DismissDirection.endToStart,
            background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: AppColors.error, borderRadius: AppBorderRadius.card),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
                Text(ar ? 'حذف' : 'Delete', style: const TextStyle(color: Colors.white, fontSize: 10)),
              ])),
            onDismissed: (_) { HapticFeedback.mediumImpact(); _delete(addr.id); },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card,
                  border: Border.all(color: addr.isDefault ? AppColors.borderGold : AppColors.borderSubtle, width: addr.isDefault ? 1.5 : 1)),
              child: Column(children: [
                Padding(padding: const EdgeInsets.all(14), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.royalBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(addr.label.split(' ').first, style: const TextStyle(fontSize: 22)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(addr.label.substring(addr.label.indexOf(' ')+1), style: isArabicStyle(ar)),
                      if (addr.isDefault) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(5), border: Border.all(color: AppColors.borderSuccess)),
                        child: Text(ar?'افتراضي':'Default', style: const TextStyle(fontSize: 8, color: AppColors.success, fontWeight: FontWeight.w600)))],
                    ]),
                    const SizedBox(height: 3),
                    Text(addr.name, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    Text('${addr.street}، ${addr.city}', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
                    Text(addr.phone, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, letterSpacing: 0.5)),
                  ])),
                  IconButton(icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textMuted), onPressed: () => HapticFeedback.lightImpact(), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                ])),
                if (!addr.isDefault) Container(
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderSubtle))),
                  child: TextButton(
                    onPressed: () { HapticFeedback.selectionClick(); _setDefault(addr.id); },
                    child: Text(ar ? 'تعيين كافتراضي' : 'Set as Default', style: AppTextStyles.labelMedium.copyWith(color: AppColors.royalBlue))),
                ),
              ]),
            ),
          )),

          // Add button
          GestureDetector(
            onTap: () { HapticFeedback.lightImpact(); context.push(AppRoutes.addAddress); },
            child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: AppBorderRadius.card,
                  border: Border.all(color: AppColors.borderActive, style: BorderStyle.solid)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.add_location_alt_outlined, size: 20, color: AppColors.royalBlue),
                const SizedBox(width: 10),
                Text(ar ? 'إضافة عنوان جديد' : 'Add New Address', style: AppTextStyles.titleSmall.copyWith(color: AppColors.royalBlue)),
              ])),
          ),
        ])),
      ]),
    );
  }

  TextStyle isArabicStyle(bool ar) => ar ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall;
}
