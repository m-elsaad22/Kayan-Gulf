// My bookings — light design (35-hs-my-bookings.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/kayan_design_tokens.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../../../shared/widgets/design/kayan_entry_widgets.dart';
import '../../../browse/data/models/service_models.dart';

class ServicesBookingsLightScreen extends ConsumerStatefulWidget {
  const ServicesBookingsLightScreen({super.key});

  @override
  ConsumerState<ServicesBookingsLightScreen> createState() => _ServicesBookingsLightScreenState();
}

class _ServicesBookingsLightScreenState extends ConsumerState<ServicesBookingsLightScreen> {
  int _tab = 0;

  List<BookingModel> get _filtered {
    return switch (_tab) {
      1 => mockBookings.where((b) => b.status == 'CONFIRMED').toList(),
      2 => mockBookings.where((b) => b.status == 'IN_PROGRESS').toList(),
      3 => mockBookings.where((b) => b.status == 'COMPLETED').toList(),
      _ => mockBookings,
    };
  }

  Color _color(String status) => switch (status) {
        'CONFIRMED' => KayanDesignTokens.kBlue,
        'IN_PROGRESS' => KayanDesignTokens.kOrange,
        'COMPLETED' => KayanDesignTokens.kGreen,
        _ => KayanDesignTokens.muted,
      };

  String _label(String status, bool ar) {
    if (ar) {
      return switch (status) {
        'CONFIRMED' => 'مؤكد',
        'IN_PROGRESS' => 'جاري',
        'COMPLETED' => 'مكتمل',
        _ => status,
      };
    }
    return switch (status) {
      'CONFIRMED' => 'Confirmed',
      'IN_PROGRESS' => 'In progress',
      'COMPLETED' => 'Done',
      _ => status,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final tabs = ar ? ['الكل', 'قادمة', 'جارية', 'مكتملة'] : ['All', 'Upcoming', 'Active', 'Done'];
    final bookings = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'حجوزاتي' : 'My bookings', onBack: () => context.pop()),
              const SizedBox(height: 10),
              KayanFilterSlotRow(labels: tabs, selectedIndex: _tab, onSelected: (i) => setState(() => _tab = i)),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: bookings.map((b) {
                    final color = _color(b.status);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: KayanDesignTokens.border),
                        boxShadow: KayanDesignTokens.shadowS,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(ar ? b.serviceNameAr : b.serviceNameEn, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800, color: KayanDesignTokens.kBlueDeep))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(99)),
                                child: Text(_label(b.status, ar), style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('${b.price.toStringAsFixed(0)} ${ar ? 'ر.س' : 'SAR'} · ${b.addressLine}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
                          if (b.status == 'IN_PROGRESS') ...[
                            const SizedBox(height: 10),
                            KayanCtaButton(
                              label: ar ? 'تتبع الفني' : 'Track technician',
                              trailingIcon: Icons.location_on_rounded,
                              variant: KayanCtaVariant.green,
                              onPressed: () => context.push(AppRoutes.trackingPath(b.id)),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
