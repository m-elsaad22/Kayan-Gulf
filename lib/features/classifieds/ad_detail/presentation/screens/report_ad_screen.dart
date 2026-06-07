// TODO: connect to real backend
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/providers/locale_provider.dart';
import '../../../shared/presentation/widgets/phase5_classifieds_widgets.dart';

class ReportAdScreen extends ConsumerStatefulWidget {
  final String adSlug;
  const ReportAdScreen({super.key, required this.adSlug});

  @override
  ConsumerState<ReportAdScreen> createState() => _ReportAdScreenState();
}

class _ReportAdScreenState extends ConsumerState<ReportAdScreen> {
  String? _reason;
  final _detailsCtrl = TextEditingController();

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final reasons = ar
        ? ['احتيال', 'محتوى غير لائق', 'إعلان مكرر', 'سعر مضلل', 'أخرى']
        : ['Fraud', 'Inappropriate', 'Duplicate', 'Misleading price', 'Other'];

    return Phase5ClassifiedsScaffold(
      titleAr: 'الإبلاغ عن إعلان',
      titleEn: 'Report Ad',
      subtitleAr: 'ساعدنا في الحفاظ على مجتمع آمن.',
      subtitleEn: 'Help us keep the community safe.',
      children: [
        ...reasons.map(
          (r) => RadioListTile<String>(
            title: Text(r),
            value: r,
            groupValue: _reason,
            onChanged: (v) => setState(() => _reason = v),
          ),
        ),
        TextField(
          controller: _detailsCtrl,
          maxLines: 4,
          textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
          decoration: InputDecoration(
            hintText: ar ? 'تفاصيل إضافية...' : 'Additional details...',
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _reason == null
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ar ? 'تم إرسال البلاغ' : 'Report submitted',
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                },
          child: Text(ar ? 'إرسال البلاغ' : 'Submit Report'),
        ),
      ],
    );
  }
}
