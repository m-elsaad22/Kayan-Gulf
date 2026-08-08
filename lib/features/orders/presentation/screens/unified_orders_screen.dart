// Orders & bookings hub — light design (16-orders-bookings.html)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/kayan_design_tokens.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/widgets/design/kayan_design_widgets.dart';
import '../../../profile/presentation/widgets/kayan_profile_widgets.dart';

class UnifiedOrdersScreen extends ConsumerWidget {
  const UnifiedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ar = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KayanLightTopBar(title: ar ? 'طلباتي وحجوزاتي' : 'Orders & bookings', onBack: () => context.pop()),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 14),
                    KayanProfileMenuTile(icon: Icons.delivery_dining_rounded, title: ar ? 'طلبات التوصيل' : 'Delivery orders', onTap: () => context.push(AppRoutes.deliveryMyOrders)),
                    KayanProfileMenuTile(icon: Icons.shopping_bag_outlined, title: ar ? 'طلبات المتجر' : 'Shop orders', onTap: () => context.push(AppRoutes.shopMyOrders)),
                    KayanProfileMenuTile(icon: Icons.home_repair_service_outlined, title: ar ? 'حجوزات الخدمات' : 'Service bookings', onTap: () => context.push(AppRoutes.myBookings)),
                    const SizedBox(height: 16),
                    KayanOfferBanner(
                      title: ar ? 'كل طلباتك في مكان واحد' : 'All orders in one place',
                      subtitle: ar ? 'تابع حالة كل قسم بسهولة' : 'Track each section easily',
                      gradient: KayanDesignTokens.gradBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
