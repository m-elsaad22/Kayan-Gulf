// ============================================================
// KAYAN — Checkout Screen
// lib/features/checkout/presentation/screens/checkout_screen.dart
//
// 3-Step Checkout (all on one scrollable page):
//   1. Delivery Address (select saved / add new)
//   2. Payment Method (COD, Tabby, Tamara, Card, Apple Pay, Wallet)
//   3. Order Review + Terms
//   → Place Order (gold gradient) → Success screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../ecommerce/product/presentation/providers/product_providers.dart';
import '../providers/checkout_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    HapticFeedback.heavyImpact();
    final notifier = ref.read(checkoutProvider.notifier);
    final success  = await notifier.placeOrder();

    if (!mounted) return;

    if (success) {
      final orderId = ref.read(checkoutProvider).orderId!;
      // Clear cart
      ref.read(cartProvider.notifier).clear();
      // Navigate to success
      context.go(AppRoutes.orderSuccessPath(orderId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic  = ref.watch(isArabicProvider);
    final checkout  = ref.watch(checkoutProvider);
    final cart      = ref.watch(cartProvider);
    final summary   = cart.summary;
    final isPlacing = checkout.orderStatus == OrderStatus.placing;

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,

      // ── App Bar ────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Text(
          isArabic ? 'إتمام الطلب' : 'Checkout',
          style: isArabic
              ? AppTextStyles.arabicTitleMedium
              : AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(
            isArabic
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.borderSubtle),
        ),
      ),

      body: Column(
        children: [
          // ── Progress indicator ────────────────────────────
          _CheckoutProgress(isArabic: isArabic),

          // ── Scrollable content ────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              padding:    const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  // ── Step 1: Address ──────────────────────
                  _SectionCard(
                    step:     '1',
                    titleAr:  'عنوان التوصيل',
                    titleEn:  'Delivery Address',
                    isArabic: isArabic,
                    child: _AddressSection(isArabic: isArabic),
                  ),

                  const SizedBox(height: 12),

                  // ── Step 2: Payment ──────────────────────
                  _SectionCard(
                    step:     '2',
                    titleAr:  'طريقة الدفع',
                    titleEn:  'Payment Method',
                    isArabic: isArabic,
                    child: _PaymentSection(
                      isArabic:  isArabic,
                      orderTotal: summary.total,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Step 3: Order Review ─────────────────
                  _SectionCard(
                    step:     '3',
                    titleAr:  'مراجعة الطلب',
                    titleEn:  'Order Review',
                    isArabic: isArabic,
                    child: _OrderReview(
                      isArabic: isArabic,
                      summary:  summary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Terms ────────────────────────────────
                  _TermsRow(isArabic: isArabic),

                  const SizedBox(height: 8),

                  // ── Error ────────────────────────────────
                  if (checkout.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pagePadding,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:        AppColors.errorBg,
                          borderRadius: AppBorderRadius.sm,
                          border:       Border.all(
                              color: AppColors.borderError),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                size: 16, color: AppColors.error),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(checkout.errorMessage!,
                                  style: (isArabic
                                          ? AppTextStyles.arabicBodySmall
                                          : AppTextStyles.bodySmall)
                                      .copyWith(color: AppColors.error)),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Place Order Bar ───────────────────────────────
          _PlaceOrderBar(
            summary:    summary,
            isArabic:   isArabic,
            isPlacing:  isPlacing,
            canPlace:   checkout.selectedAddress != null && checkout.agreeToTerms,
            onPlace:    _placeOrder,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CHECKOUT PROGRESS STRIP
// ──────────────────────────────────────────────────────────────
class _CheckoutProgress extends StatelessWidget {
  final bool isArabic;
  const _CheckoutProgress({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final steps = isArabic
        ? ['العنوان', 'الدفع', 'المراجعة']
        : ['Address', 'Payment', 'Review'];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding,
        vertical: 12,
      ),
      color: AppColors.bgSurface,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Connector line
            return Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: i < 3
                      ? AppGradients.primaryButton
                      : null,
                  color: i >= 3 ? AppColors.borderDefault : null,
                ),
              ),
            );
          }
          final idx       = i ~/ 2;
          final isActive  = idx <= 1; // First two always active in demo
          final isDone    = idx == 0;

          return Column(
            children: [
              Container(
                width:  28, height: 28,
                decoration: BoxDecoration(
                  shape:    BoxShape.circle,
                  gradient: isActive
                      ? AppGradients.primaryButton
                      : null,
                  color: isActive ? null : AppColors.bgCard2,
                  border: isActive ? null : Border.all(
                    color: AppColors.borderDefault,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : Text(
                          '${idx + 1}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isActive
                                ? Colors.white
                                : AppColors.textMuted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[idx],
                style: AppTextStyles.labelSmall.copyWith(
                  color: isActive
                      ? AppColors.royalBlue
                      : AppColors.textMuted,
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// SECTION CARD WRAPPER
// ──────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String   step;
  final String   titleAr;
  final String   titleEn;
  final bool     isArabic;
  final Widget   child;

  const _SectionCard({
    required this.step,
    required this.titleAr,
    required this.titleEn,
    required this.isArabic,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Container(
        decoration: BoxDecoration(
          color:        AppColors.bgCard,
          borderRadius: AppBorderRadius.card,
          border:       Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Container(
                    width:  28, height: 28,
                    decoration: BoxDecoration(
                      gradient:     AppGradients.primaryButton,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(step,
                          style: AppTextStyles.labelSmall.copyWith(
                            color:      Colors.white,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isArabic ? titleAr : titleEn,
                    style: isArabic
                        ? AppTextStyles.arabicTitleMedium
                        : AppTextStyles.titleMedium,
                  ),
                ],
              ),
            ),
            Container(height: 1, color: AppColors.borderSubtle),
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// ADDRESS SECTION
// ──────────────────────────────────────────────────────────────
class _AddressSection extends ConsumerWidget {
  final bool isArabic;
  const _AddressSection({required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(savedAddressesProvider);
    final selected  = ref.watch(checkoutProvider).selectedAddress;
    final notifier  = ref.read(checkoutProvider.notifier);

    return Column(
      children: [
        ...addresses.map((addr) => _AddressCard(
          address:    addr,
          isSelected: selected?.id == addr.id,
          isArabic:   isArabic,
          onSelect:   () => notifier.selectAddress(addr),
        )),

        const SizedBox(height: 8),

        // Add new address
        GestureDetector(
          onTap: () => HapticFeedback.lightImpact(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color:        AppColors.royalBlue.withOpacity(0.06),
              borderRadius: AppBorderRadius.sm,
              border:       Border.all(
                color:      AppColors.borderActive,
                style:      BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_location_alt_rounded,
                    size: 18, color: AppColors.royalBlue),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'إضافة عنوان جديد' : 'Add New Address',
                  style: (isArabic
                          ? AppTextStyles.arabicBodyMedium
                          : AppTextStyles.bodyMedium)
                      .copyWith(color: AppColors.royalBlue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final DeliveryAddress address;
  final bool            isSelected;
  final bool            isArabic;
  final VoidCallback    onSelect;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.isArabic,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelect();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin:   const EdgeInsets.only(bottom: 10),
        padding:  const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:        isSelected
              ? AppColors.royalBlue.withOpacity(0.07)
              : AppColors.bgCard2,
          borderRadius: AppBorderRadius.sm,
          border:       Border.all(
            color: isSelected
                ? AppColors.borderActiveBold
                : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio-like indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width:  20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.royalBlue
                      : AppColors.borderDefault,
                  width: isSelected ? 2 : 1.5,
                ),
                color: isSelected
                    ? AppColors.royalBlue
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 12)
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(address.label,
                          style: (isArabic
                                  ? AppTextStyles.arabicTitleSmall
                                  : AppTextStyles.titleSmall)
                              .copyWith(
                            color: isSelected
                                ? AppColors.royalBlue
                                : AppColors.textPrimary,
                          )),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color:        AppColors.successBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isArabic ? 'افتراضي' : 'Default',
                            style: AppTextStyles.badge.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    address.recipientName,
                    style: (isArabic
                            ? AppTextStyles.arabicBodySmall
                            : AppTextStyles.bodySmall)
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  Text(
                    address.fullAddress,
                    style: (isArabic
                            ? AppTextStyles.arabicCaption
                            : AppTextStyles.caption)
                        .copyWith(color: AppColors.textMuted),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.phone,
                    style: AppTextStyles.caption.copyWith(
                      color:        AppColors.textMuted,
                      letterSpacing: 0.5,
                      fontFamily:   'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Edit icon
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  size: 16, color: AppColors.textMuted),
              onPressed: () => HapticFeedback.lightImpact(),
              padding:   EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PAYMENT SECTION
// ──────────────────────────────────────────────────────────────
class _PaymentSection extends ConsumerWidget {
  final bool   isArabic;
  final double orderTotal;

  const _PaymentSection({
    required this.isArabic,
    required this.orderTotal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(checkoutProvider).paymentMethod;
    final notifier = ref.read(checkoutProvider.notifier);

    // Available payment methods
    final methods = [
      PaymentMethod.cod,
      PaymentMethod.tabby,
      PaymentMethod.tamara,
      PaymentMethod.card,
      PaymentMethod.applepay,
      PaymentMethod.wallet,
    ];

    return Column(
      children: methods.map((method) => _PaymentCard(
        method:     method,
        isSelected: selected == method,
        isArabic:   isArabic,
        orderTotal: orderTotal,
        onSelect:   () {
          HapticFeedback.selectionClick();
          notifier.selectPayment(method);
        },
      )).toList(),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final PaymentMethod method;
  final bool          isSelected;
  final bool          isArabic;
  final double        orderTotal;
  final VoidCallback  onSelect;

  const _PaymentCard({
    required this.method,
    required this.isSelected,
    required this.isArabic,
    required this.orderTotal,
    required this.onSelect,
  });

  // BNPL installment amounts
  String _bnplLabel(bool isArabic) {
    if (method == PaymentMethod.tabby) {
      final installment = (orderTotal / 4).toInt();
      return isArabic
          ? '4 × $installment ر.س — بدون فوائد'
          : '4 × $installment SAR — 0% interest';
    }
    if (method == PaymentMethod.tamara) {
      final installment = (orderTotal / 3).toInt();
      return isArabic
          ? '3 × $installment ر.س'
          : '3 × $installment SAR';
    }
    return '';
  }

  Color get _methodColor => switch (method) {
    PaymentMethod.tabby    => AppColors.tabbyColor,
    PaymentMethod.tamara   => AppColors.tamaraColor,
    PaymentMethod.card     => AppColors.royalBlue,
    PaymentMethod.applepay => AppColors.textPrimary,
    PaymentMethod.wallet   => AppColors.metallicGold,
    _                      => AppColors.success,
  };

  @override
  Widget build(BuildContext context) {
    final isBnpl = method.isBnpl;

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? _methodColor.withOpacity(0.07)
              : AppColors.bgCard2,
          borderRadius: AppBorderRadius.sm,
          border: Border.all(
            color: isSelected
                ? _methodColor.withOpacity(0.5)
                : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width:  20, height: 20,
              decoration: BoxDecoration(
                shape:  BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _methodColor : AppColors.borderDefault,
                  width: isSelected ? 2 : 1.5,
                ),
                color: isSelected ? _methodColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 12)
                  : null,
            ),

            const SizedBox(width: 12),

            // Logo circle
            Container(
              width:  40, height: 40,
              decoration: BoxDecoration(
                color:        _methodColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border:       Border.all(
                  color: _methodColor.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Text(
                  method.iconEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? method.labelAr : method.labelEn,
                    style: (isArabic
                            ? AppTextStyles.arabicBodyMedium
                            : AppTextStyles.bodyMedium)
                        .copyWith(
                      color: isSelected ? _methodColor : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (isBnpl) ...[
                    const SizedBox(height: 2),
                    Text(
                      _bnplLabel(isArabic),
                      style: AppTextStyles.caption.copyWith(
                        color: _methodColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (method == PaymentMethod.wallet) ...[
                    const SizedBox(height: 2),
                    Text(
                      isArabic ? 'الرصيد: 250 ر.س' : 'Balance: 250 SAR',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.metallicGold),
                    ),
                  ],
                ],
              ),
            ),

            // BNPL badge
            if (isBnpl)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color:        _methodColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border:       Border.all(
                    color: _methodColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  isArabic ? 'الآن لاحقاً' : 'Buy Now\nPay Later',
                  style: AppTextStyles.badge.copyWith(
                    color: _methodColor, fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// ORDER REVIEW SECTION
// ──────────────────────────────────────────────────────────────
class _OrderReview extends ConsumerWidget {
  final bool        isArabic;
  final dynamic     summary; // CartSummary

  const _OrderReview({required this.isArabic, required this.summary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Items mini list
        ...cart.items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 52, height: 52,
                  child: item.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl!,
                          fit:      BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.bgCard2,
                          child: const Icon(Icons.shopping_bag_outlined,
                              color: AppColors.textMuted, size: 20),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.nameAr,
                        style: isArabic
                            ? AppTextStyles.arabicBodySmall
                                .copyWith(fontWeight: FontWeight.w600)
                            : AppTextStyles.bodySmall
                                .copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2),
                    Text(
                      '${isArabic ? 'الكمية: ' : 'Qty: '}${item.quantity}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Text(
                '${item.totalPrice.toInt()} ر.س',
                style: AppTextStyles.priceMedium,
              ),
            ],
          ),
        )),

        const Divider(color: AppColors.borderSubtle, height: 20),

        // Summary rows
        _ReviewRow(
          label:    isArabic ? 'المجموع' : 'Subtotal',
          value:    '${summary.subtotal.toInt()} ر.س',
          isArabic: isArabic,
        ),
        if (summary.couponDiscount > 0)
          _ReviewRow(
            label:    isArabic ? 'الخصم' : 'Discount',
            value:    '-${summary.couponDiscount.toInt()} ر.س',
            isArabic: isArabic,
            color:    AppColors.success,
          ),
        _ReviewRow(
          label:    isArabic ? 'الشحن' : 'Shipping',
          value:    summary.isFreeShipping
              ? (isArabic ? 'مجاني' : 'Free')
              : '${summary.shipping.toInt()} ر.س',
          isArabic: isArabic,
          color:    summary.isFreeShipping ? AppColors.success : null,
        ),
        _ReviewRow(
          label:    isArabic ? 'ضريبة القيمة المضافة (15%)' : 'VAT (15%)',
          value:    '${summary.vat.toInt()} ر.س',
          isArabic: isArabic,
          secondary: true,
        ),

        const Divider(color: AppColors.borderVisible, height: 16),

        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isArabic ? 'الإجمالي' : 'Total',
              style: isArabic
                  ? AppTextStyles.arabicTitleMedium
                  : AppTextStyles.titleMedium,
            ),
            Text(
              '${summary.total.toInt()} ر.س',
              style: AppTextStyles.priceLarge,
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String  label;
  final String  value;
  final bool    isArabic;
  final Color?  color;
  final bool    secondary;

  const _ReviewRow({
    required this.label,
    required this.value,
    required this.isArabic,
    this.color,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: (isArabic
                    ? AppTextStyles.arabicBodySmall
                    : AppTextStyles.bodySmall)
                .copyWith(
                  color: secondary
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                )),
        Text(value,
            style: AppTextStyles.labelMedium.copyWith(
              color: color ?? AppColors.textPrimary,
            )),
      ],
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// TERMS ROW
// ──────────────────────────────────────────────────────────────
class _TermsRow extends ConsumerWidget {
  final bool isArabic;
  const _TermsRow({required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreed   = ref.watch(checkoutProvider).agreeToTerms;
    final notifier = ref.read(checkoutProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          notifier.toggleTerms();
        },
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width:  22, height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color:        agreed
                    ? AppColors.royalBlue
                    : Colors.transparent,
                border:       Border.all(
                  color: agreed
                      ? AppColors.royalBlue
                      : AppColors.borderDefault,
                  width: 1.5,
                ),
              ),
              child: agreed
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: isArabic
                      ? AppTextStyles.arabicBodySmall.copyWith(
                          color: AppColors.textSecondary)
                      : AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: isArabic
                          ? 'أوافق على '
                          : 'I agree to the ',
                    ),
                    TextSpan(
                      text: isArabic
                          ? 'الشروط والأحكام'
                          : 'Terms & Conditions',
                      style: const TextStyle(
                        color:      AppColors.skyBlue,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.skyBlue,
                      ),
                    ),
                    TextSpan(
                      text: isArabic
                          ? ' وسياسة الخصوصية'
                          : ' and Privacy Policy',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PLACE ORDER BAR
// ──────────────────────────────────────────────────────────────
class _PlaceOrderBar extends StatelessWidget {
  final dynamic      summary;
  final bool         isArabic;
  final bool         isPlacing;
  final bool         canPlace;
  final VoidCallback onPlace;

  const _PlaceOrderBar({
    required this.summary,
    required this.isArabic,
    required this.isPlacing,
    required this.canPlace,
    required this.onPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding, 12,
        AppSpacing.pagePadding,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: const Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1)),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset:     const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Security badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_rounded,
                  size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                isArabic
                    ? 'دفع آمن ومشفر بـ SSL'
                    : 'Secured by SSL Encryption',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Place order button
          GestureDetector(
            onTap: canPlace && !isPlacing ? onPlace : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 56,
              decoration: BoxDecoration(
                gradient: canPlace
                    ? AppGradients.goldButton
                    : const LinearGradient(
                        colors: [AppColors.bgCard2, AppColors.bgCard2]),
                borderRadius: AppBorderRadius.button,
                boxShadow: canPlace ? [
                  BoxShadow(
                    color:      AppColors.metallicGold.withOpacity(0.4),
                    blurRadius: 20,
                    offset:     const Offset(0, 6),
                  ),
                ] : [],
              ),
              child: Center(
                child: isPlacing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width:  20, height: 20,
                            child: CircularProgressIndicator(
                              color:       AppColors.bgPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isArabic ? 'جارٍ معالجة الطلب...' : 'Processing...',
                            style: (isArabic
                                    ? AppTextStyles.arabicButton
                                    : AppTextStyles.buttonMedium)
                                .copyWith(color: AppColors.bgPrimary),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_rounded,
                              color: AppColors.bgPrimary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isArabic
                                ? 'تأكيد الطلب • ${summary.total.toInt()} ر.س'
                                : 'Place Order • ${summary.total.toInt()} SAR',
                            style: (isArabic
                                    ? AppTextStyles.arabicButton
                                    : AppTextStyles.buttonLarge)
                                .copyWith(
                              color: canPlace
                                  ? AppColors.bgPrimary
                                  : AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // Terms warning if not agreed
          if (!canPlace)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                isArabic
                    ? 'يرجى الموافقة على الشروط والأحكام للمتابعة'
                    : 'Please agree to terms to continue',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
