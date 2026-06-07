// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/phase3_service_widgets.dart';

class ServiceSubcategoriesScreen extends StatelessWidget {
  const ServiceSubcategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Phase3ServiceScaffold(
      titleAr: 'الفئات الفرعية',
      titleEn: 'Service Subcategories',
      subtitleAr: 'استكشف الخدمات الدقيقة داخل كل فئة رئيسية.',
      subtitleEn: 'Explore detailed services within each main category.',
      children: [
          Phase3ServiceCard(
            icon: Icons.ac_unit_rounded,
            titleAr: 'تكييف سبليت',
            titleEn: 'Split AC',
            bodyAr: 'تركيب وصيانة وتنظيف وحدات التكييف.',
            bodyEn: 'Install, service, and clean AC units.',
          ),
          Phase3ServiceCard(
            icon: Icons.plumbing_rounded,
            titleAr: 'إصلاحات سباكة',
            titleEn: 'Plumbing Repairs',
            bodyAr: 'تسربات، خلاطات، وتمديدات منزلية.',
            bodyEn: 'Leaks, mixers, and home piping.',
          ),
          Phase3ServiceCard(
            icon: Icons.cleaning_services_rounded,
            titleAr: 'تنظيف عميق',
            titleEn: 'Deep Cleaning',
            bodyAr: 'باقات تنظيف للمنازل والشقق.',
            bodyEn: 'Cleaning packages for homes and apartments.',
          ),
      ],
    );
  }
}
