// ============================================================
// KAYAN — Orders History Screen
// lib/features/orders/presentation/screens/orders_list_screen.dart
// ============================================================

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

// ── Order Status ──────────────────────────────────────────────
enum KOrderStatus { pending, processing, shipped, delivered, cancelled, refunded }

extension KOrderStatusX on KOrderStatus {
  String labelAr(bool ar) => ar ? switch (this) {
    KOrderStatus.pending    => 'قيد الانتظار',
    KOrderStatus.processing => 'جاري التجهيز',
    KOrderStatus.shipped    => 'في الطريق',
    KOrderStatus.delivered  => 'تم التوصيل',
    KOrderStatus.cancelled  => 'ملغي',
    KOrderStatus.refunded   => 'مسترجع',
  } : switch (this) {
    KOrderStatus.pending    => 'Pending',
    KOrderStatus.processing => 'Processing',
    KOrderStatus.shipped    => 'Shipped',
    KOrderStatus.delivered  => 'Delivered',
    KOrderStatus.cancelled  => 'Cancelled',
    KOrderStatus.refunded   => 'Refunded',
  };

  Color get color => switch (this) {
    KOrderStatus.pending    => AppColors.warning,
    KOrderStatus.processing => AppColors.royalBlue,
    KOrderStatus.shipped    => AppColors.categoryTeal,
    KOrderStatus.delivered  => AppColors.success,
    KOrderStatus.cancelled  => AppColors.error,
    KOrderStatus.refunded   => AppColors.textSecondary,
  };

  IconData get icon => switch (this) {
    KOrderStatus.pending    => Icons.access_time_rounded,
    KOrderStatus.processing => Icons.settings_rounded,
    KOrderStatus.shipped    => Icons.local_shipping_rounded,
    KOrderStatus.delivered  => Icons.check_circle_rounded,
    KOrderStatus.cancelled  => Icons.cancel_rounded,
    KOrderStatus.refunded   => Icons.replay_rounded,
  };

  bool get canTrack   => this == KOrderStatus.shipped || this == KOrderStatus.processing;
  bool get canReorder => this == KOrderStatus.delivered || this == KOrderStatus.cancelled;
  bool get canReview  => this == KOrderStatus.delivered;
}

// ── Order Model ───────────────────────────────────────────────
class KOrderModel {
  final String         id;
  final String         number;
  final KOrderStatus   status;
  final DateTime       createdAt;
  final double         total;
  final int            itemCount;
  final List<String>   thumbs;
  final String         payment;

  const KOrderModel({
    required this.id, required this.number,
    required this.status, required this.createdAt,
    required this.total, required this.itemCount,
    this.thumbs = const [], this.payment = 'COD',
  });

  String timeAgo(bool ar) {
    final d = DateTime.now().difference(createdAt);
    if (ar) {
      if (d.inDays > 30) return 'منذ ${d.inDays ~/ 30} شهر';
      if (d.inDays > 0)  return 'منذ ${d.inDays} يوم';
      if (d.inHours > 0) return 'منذ ${d.inHours} ساعة';
      return 'الآن';
    } else {
      if (d.inDays > 30) return '${d.inDays ~/ 30}mo ago';
      if (d.inDays > 0)  return '${d.inDays}d ago';
      if (d.inHours > 0) return '${d.inHours}h ago';
      return 'Just now';
    }
  }
}

final _mockOrders = [
  KOrderModel(id:'1', number:'KYN-8472936', status:KOrderStatus.shipped,
    createdAt:DateTime.now().subtract(const Duration(days:1)),
    total:1338, itemCount:2,
    thumbs:['https://picsum.photos/60?random=71','https://picsum.photos/60?random=72'],
    payment:'Tabby'),
  KOrderModel(id:'2', number:'KYN-7361825', status:KOrderStatus.delivered,
    createdAt:DateTime.now().subtract(const Duration(days:7)),
    total:2450, itemCount:3,
    thumbs:['https://picsum.photos/60?random=73','https://picsum.photos/60?random=74'],
    payment:'Card'),
  KOrderModel(id:'3', number:'KYN-6250714', status:KOrderStatus.processing,
    createdAt:DateTime.now().subtract(const Duration(hours:3)),
    total:599, itemCount:1,
    thumbs:['https://picsum.photos/60?random=75'],
    payment:'COD'),
  KOrderModel(id:'4', number:'KYN-5139603', status:KOrderStatus.delivered,
    createdAt:DateTime.now().subtract(const Duration(days:15)),
    total:890, itemCount:2,
    thumbs:['https://picsum.photos/60?random=76','https://picsum.photos/60?random=77'],
    payment:'Tamara'),
  KOrderModel(id:'5', number:'KYN-4028492', status:KOrderStatus.cancelled,
    createdAt:DateTime.now().subtract(const Duration(days:20)),
    total:150, itemCount:1,
    thumbs:['https://picsum.photos/60?random=78'],
    payment:'Wallet'),
  KOrderModel(id:'6', number:'KYN-3917381', status:KOrderStatus.delivered,
    createdAt:DateTime.now().subtract(const Duration(days:45)),
    total:3200, itemCount:4,
    thumbs:['https://picsum.photos/60?random=79','https://picsum.photos/60?random=80'],
    payment:'Apple Pay'),
];

// ── Screen ────────────────────────────────────────────────────
class OrdersListScreen extends ConsumerStatefulWidget {
  const OrdersListScreen({super.key});
  @override
  ConsumerState<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends ConsumerState<OrdersListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final List<KOrderStatus?> _filters = [
    null,
    KOrderStatus.processing,
    KOrderStatus.shipped,
    KOrderStatus.delivered,
    KOrderStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _filters.length, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor:          AppColors.bgSurface,
        centerTitle:              true,
        title: Text(
          isArabic ? 'طلباتي' : 'My Orders',
          style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, size:20),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller:           _tab,
          isScrollable:         true,
          tabAlignment:         TabAlignment.start,
          indicatorColor:       AppColors.royalBlue,
          indicatorWeight:      2,
          labelColor:           AppColors.royalBlue,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle:    AppTextStyles.labelMedium.copyWith(fontWeight:FontWeight.w600),
          unselectedLabelStyle: AppTextStyles.labelMedium,
          tabs: [
            Tab(text: isArabic ? 'الكل'         : 'All'),
            Tab(text: isArabic ? 'جاري التجهيز' : 'Processing'),
            Tab(text: isArabic ? 'في الطريق'    : 'Shipped'),
            Tab(text: isArabic ? 'تم التوصيل'   : 'Delivered'),
            Tab(text: isArabic ? 'ملغي'         : 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: _filters.map((f) {
          final list = f == null
              ? _mockOrders
              : _mockOrders.where((o) => o.status == f).toList();
          if (list.isEmpty) return _EmptyOrders(isArabic: isArabic);
          return ListView.separated(
            padding:  const EdgeInsets.all(AppSpacing.pagePadding),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _OrderCard(order: list[i], isArabic: isArabic),
          );
        }).toList(),
      ),
    );
  }
}

// ── Order Card ────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final KOrderModel order;
  final bool        isArabic;
  const _OrderCard({required this.order, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final st = order.status;
    return GestureDetector(
      onTap: () => context.push(AppRoutes.orderPath(order.id)),
      child: Container(
        decoration: BoxDecoration(
          color:        AppColors.bgCard,
          borderRadius: AppBorderRadius.card,
          border: Border.all(
            color:  st == KOrderStatus.shipped ? AppColors.borderActive : AppColors.borderSubtle,
            width:  st == KOrderStatus.shipped ? 1.5 : 1,
          ),
          boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.15), blurRadius:8, offset:const Offset(0,2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.number, style: AppTextStyles.orderNumber),
                        const SizedBox(height:2),
                        Text(order.timeAgo(isArabic), style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
                    decoration: BoxDecoration(
                      color:        st.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border:       Border.all(color: st.color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(st.icon, size:12, color:st.color),
                        const SizedBox(width:4),
                        Text(st.labelAr(isArabic),
                            style: AppTextStyles.badgeMedium.copyWith(color:st.color)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(height:1, color:AppColors.borderSubtle),

            // Body: thumbnails + info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Thumbnails stacked
                  SizedBox(
                    height: 52,
                    width:  _tw(order.thumbs.length),
                    child: Stack(
                      children: List.generate(
                        order.thumbs.length.clamp(0,3), (i) =>
                        Positioned(
                          left: i * 36.0,
                          child: Container(
                            width:52, height:52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:       Border.all(color:AppColors.bgScaffold, width:2),
                              color:        AppColors.bgCard2,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              order.thumbs[i], fit: BoxFit.cover,
                              errorBuilder: (_,__,___) => const Icon(
                                Icons.shopping_bag_outlined, color:AppColors.textMuted, size:22),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width:12),
                  // Info column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? '${order.itemCount} منتج' : '${order.itemCount} item${order.itemCount>1?'s':''}',
                          style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall)
                              .copyWith(color:AppColors.textSecondary),
                        ),
                        const SizedBox(height:2),
                        Text('${order.total.toInt()} ${isArabic?'ر.س':'SAR'}',
                            style: AppTextStyles.priceMedium),
                        const SizedBox(height:2),
                        Text(
                          '${isArabic?'الدفع: ':'via '}${_pay(order.payment, isArabic)}',
                          style: AppTextStyles.caption.copyWith(color:AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            if (st.canTrack || st.canReorder || st.canReview)
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color:AppColors.borderSubtle))),
                child: _ActionRow(order:order, isArabic:isArabic, status:st),
              ),
          ],
        ),
      ),
    );
  }

  double _tw(int n) => 52 + (n.clamp(1,3) - 1) * 36.0;

  String _pay(String m, bool ar) {
    if (!ar) return m;
    return switch (m) {
      'COD'       => 'عند الاستلام',
      'Card'      => 'بطاقة بنكية',
      'Wallet'    => 'محفظة كيان',
      'Apple Pay' => 'Apple Pay',
      _           => m,
    };
  }
}

class _ActionRow extends StatelessWidget {
  final KOrderModel  order;
  final bool         isArabic;
  final KOrderStatus status;
  const _ActionRow({required this.order, required this.isArabic, required this.status});

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];
    bool first = true;

    void addDivider() {
      if (!first) buttons.add(Container(width:1, height:32, color:AppColors.borderSubtle));
    }

    if (status.canTrack) {
      addDivider(); first = false;
      buttons.add(Expanded(child: TextButton.icon(
        onPressed: () => context.push(AppRoutes.orderTrackPath(order.id)),
        icon:  const Icon(Icons.location_on_rounded, size:14, color:AppColors.royalBlue),
        label: Text(isArabic?'تتبع الطلب':'Track Order',
            style: AppTextStyles.labelMedium.copyWith(color:AppColors.royalBlue)),
      )));
    }

    if (status.canReorder) {
      addDivider(); first = false;
      buttons.add(Expanded(child: TextButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(isArabic?'تم إضافة المنتجات للسلة!':'Items added to cart!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.sm),
          ));
        },
        icon:  const Icon(Icons.replay_rounded, size:14, color:AppColors.metallicGold),
        label: Text(isArabic?'إعادة الطلب':'Reorder',
            style: AppTextStyles.labelMedium.copyWith(color:AppColors.metallicGold)),
      )));
    }

    if (status.canReview) {
      addDivider();
      buttons.add(Expanded(child: TextButton.icon(
        onPressed: () {},
        icon:  const Icon(Icons.star_outline_rounded, size:14, color:AppColors.starFilled),
        label: Text(isArabic?'قيّم':'Review',
            style: AppTextStyles.labelMedium.copyWith(color:AppColors.starFilled)),
      )));
    }

    return Row(children: buttons);
  }
}

// ── Empty State ───────────────────────────────────────────────
class _EmptyOrders extends StatelessWidget {
  final bool isArabic;
  const _EmptyOrders({required this.isArabic});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width:100, height:100,
          decoration: BoxDecoration(
            color:AppColors.bgCard, shape:BoxShape.circle,
            border:Border.all(color:AppColors.borderSubtle)),
          child: const Icon(Icons.receipt_long_rounded, size:48, color:AppColors.textMuted),
        ),
        const SizedBox(height:20),
        Text(isArabic?'لا توجد طلبات':'No Orders Yet',
            style: isArabic ? AppTextStyles.arabicTitleMedium : AppTextStyles.titleMedium),
        const SizedBox(height:8),
        Text(isArabic?'ابدأ تسوقك الآن!':'Start shopping now!',
            style: (isArabic ? AppTextStyles.arabicBodySmall : AppTextStyles.bodySmall)
                .copyWith(color:AppColors.textSecondary)),
        const SizedBox(height:24),
        GestureDetector(
          onTap: () => context.go(AppRoutes.shop),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal:28, vertical:13),
            decoration: BoxDecoration(
              gradient:     AppGradients.primaryButton,
              borderRadius: AppBorderRadius.button,
              boxShadow: [BoxShadow(color:AppColors.royalBlue.withOpacity(0.35), blurRadius:16, offset:const Offset(0,4))],
            ),
            child: Text(isArabic?'تسوق الآن':'Shop Now',
                style: isArabic ? AppTextStyles.arabicButton : AppTextStyles.buttonMedium),
          ),
        ),
      ],
    ),
  );
}
