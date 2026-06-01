// ============================================================
// KAYAN — Cart Screen
// lib/features/cart/presentation/screens/cart_screen.dart
//
// Sections:
//   1. Items list (swipe-to-delete, quantity stepper, image)
//   2. Coupon input with apply / remove
//   3. Order summary card (subtotal, discount, shipping, VAT, total)
//   4. Checkout CTA (gold gradient)
//   5. Empty cart state
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
import '../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../../../ecommerce/product/presentation/providers/product_providers.dart';
import '../../../ecommerce/product/data/models/product_models.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _couponCtrl = TextEditingController();
  final _couponFocus = FocusNode();

  @override
  void dispose() {
    _couponCtrl.dispose();
    _couponFocus.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    final code = _couponCtrl.text.trim();
    if (code.isEmpty) return;
    _couponFocus.unfocus();
    await ref.read(cartProvider.notifier).applyCoupon(code);
    if (ref.read(cartProvider).couponCode != null) {
      _couponCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final cart     = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    if (cart.items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bgScaffold,
        appBar: AppBar(
          title: Text(
            isArabic ? 'السلة' : 'Cart',
            style: isArabic
                ? AppTextStyles.arabicTitleMedium
                : AppTextStyles.titleMedium,
          ),
          leading: IconButton(
            icon: Icon(isArabic
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: _EmptyCart(isArabic: isArabic),
      );
    }

    final summary = cart.summary;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgScaffold,

        // ── App Bar ─────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: AppColors.bgSurface,
          centerTitle:     true,
          title: Text(
            isArabic
                ? 'السلة (${summary.itemCount})'
                : 'Cart (${summary.itemCount})',
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
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => _ClearCartDialog(
                    isArabic: isArabic,
                    onConfirm: notifier.clear,
                  ),
                );
              },
              child: Text(
                isArabic ? 'مسح الكل' : 'Clear All',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppColors.borderSubtle),
          ),
        ),

        body: Column(
          children: [
            // ── Cart items + coupon + summary ──────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  const SizedBox(height: 12),

                  // ── Items list ─────────────────────────
                  ...cart.items.map((item) => _CartItemTile(
                    item:      item,
                    isArabic:  isArabic,
                    onRemove:  () => notifier.removeItem(item.cartItemId),
                    onQtyChange: (q) =>
                        notifier.updateQuantity(item.cartItemId, q),
                  )),

                  const SizedBox(height: 16),

                  // ── Coupon ────────────────────────────
                  _CouponSection(
                    controller:   _couponCtrl,
                    focusNode:    _couponFocus,
                    isArabic:     isArabic,
                    cart:         cart,
                    onApply:      _applyCoupon,
                    onRemove:     notifier.removeCoupon,
                  ),

                  const SizedBox(height: 16),

                  // ── Order Summary ─────────────────────
                  _OrderSummaryCard(
                    summary:  summary,
                    isArabic: isArabic,
                  ),

                  const SizedBox(height: 12),

                  // ── Promo info ─────────────────────────
                  if (!summary.isFreeShipping)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.pagePadding),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:        AppColors.infoBg,
                          borderRadius: AppBorderRadius.sm,
                          border:       Border.all(
                              color: AppColors.info.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_shipping_outlined,
                                size: 16, color: AppColors.info),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isArabic
                                    ? 'أضف ${(200 - summary.subtotal + summary.discount).toInt()} ر.س للحصول على شحن مجاني'
                                    : 'Add ${(200 - summary.subtotal + summary.discount).toInt()} SAR for free shipping',
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.info),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Sticky Checkout Button ─────────────────────
            _CheckoutBar(
              summary:  summary,
              isArabic: isArabic,
              onCheckout: () => context.push(AppRoutes.checkout),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CART ITEM TILE  (swipe to delete)
// ──────────────────────────────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final CartItemModel     item;
  final bool              isArabic;
  final VoidCallback      onRemove;
  final ValueChanged<int> onQtyChange;

  const _CartItemTile({
    required this.item,
    required this.isArabic,
    required this.onRemove,
    required this.onQtyChange,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:       ValueKey(item.cartItemId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding:   const EdgeInsets.only(right: 24),
        color:     AppColors.error,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              isArabic ? 'حذف' : 'Remove',
              style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onRemove();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
          vertical:   4,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:        AppColors.bgCard,
          borderRadius: AppBorderRadius.card,
          border:       Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: AppBorderRadius.sm,
              child: SizedBox(
                width:  80, height: 80,
                child: item.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl:    item.imageUrl!,
                        fit:         BoxFit.cover,
                        placeholder: (_, __) => const ShimmerBox(
                          width: 80, height: 80,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.bgCard2,
                          child: const Icon(Icons.image_outlined,
                              color: AppColors.textMuted),
                        ),
                      )
                    : Container(color: AppColors.bgCard2,
                        child: const Icon(Icons.shopping_bag_outlined,
                            color: AppColors.textMuted)),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nameAr,
                    style: isArabic
                        ? AppTextStyles.arabicTitleSmall
                        : AppTextStyles.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.selectedColor != null || item.selectedSize != null) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: [
                        if (item.selectedColor != null)
                          _VariantTag(item.selectedColor!),
                        if (item.selectedSize != null)
                          _VariantTag(item.selectedSize!),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${item.unitPrice.toInt()} ر.س',
                        style: AppTextStyles.priceMedium,
                      ),
                      const Spacer(),
                      // Quantity stepper
                      _QuantityStepper(
                        quantity:   item.quantity,
                        maxStock:   item.maxStock,
                        onDecrease: () => onQtyChange(item.quantity - 1),
                        onIncrease: () => onQtyChange(item.quantity + 1),
                      ),
                    ],
                  ),
                  // Line total
                  if (item.quantity > 1)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${isArabic ? 'المجموع: ' : 'Total: '}'
                        '${item.totalPrice.toInt()} ر.س',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.skyBlue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VariantTag extends StatelessWidget {
  final String label;
  const _VariantTag(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color:        AppColors.bgCard2,
      borderRadius: BorderRadius.circular(4),
      border:       Border.all(color: AppColors.borderSubtle),
    ),
    child: Text(label, style: AppTextStyles.labelSmall),
  );
}

class _QuantityStepper extends StatelessWidget {
  final int          quantity;
  final int          maxStock;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  const _QuantityStepper({
    required this.quantity,
    required this.maxStock,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: 30,
    decoration: BoxDecoration(
      color:        AppColors.bgCard2,
      borderRadius: BorderRadius.circular(8),
      border:       Border.all(color: AppColors.borderDefault),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: quantity > 1 ? () {
            HapticFeedback.selectionClick();
            onDecrease();
          } : null,
          child: SizedBox(
            width: 30, height: 30,
            child: Icon(Icons.remove_rounded,
                size: 16,
                color: quantity > 1 ? AppColors.textPrimary : AppColors.textDisabled),
          ),
        ),
        SizedBox(
          width: 32,
          child: Center(
            child: Text('$quantity',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 13)),
          ),
        ),
        GestureDetector(
          onTap: quantity < maxStock ? () {
            HapticFeedback.selectionClick();
            onIncrease();
          } : null,
          child: SizedBox(
            width: 30, height: 30,
            child: Icon(Icons.add_rounded,
                size: 16,
                color: quantity < maxStock
                    ? AppColors.textPrimary
                    : AppColors.textDisabled),
          ),
        ),
      ],
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// COUPON SECTION
// ──────────────────────────────────────────────────────────────
class _CouponSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode             focusNode;
  final bool                  isArabic;
  final CartState             cart;
  final VoidCallback          onApply;
  final VoidCallback          onRemove;

  const _CouponSection({
    required this.controller,
    required this.focusNode,
    required this.isArabic,
    required this.cart,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasCoupon = cart.summary.hasCoupon;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_outlined,
                  size: 16, color: AppColors.metallicGold),
              const SizedBox(width: 6),
              Text(
                isArabic ? 'كود الخصم' : 'Coupon Code',
                style: isArabic
                    ? AppTextStyles.arabicTitleSmall
                    : AppTextStyles.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (hasCoupon)
            // Applied coupon chip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color:        AppColors.successBg,
                borderRadius: AppBorderRadius.sm,
                border:       Border.all(color: AppColors.borderSuccess),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 16, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    '${cart.summary.couponCode} — '
                    '-${cart.summary.couponDiscount.toInt()} ر.س',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onRemove,
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: AppColors.success),
                  ),
                ],
              ),
            )
          else
            // Input row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:   controller,
                    focusNode:    focusNode,
                    textCapitalization: TextCapitalization.characters,
                    textDirection: TextDirection.ltr,
                    style: AppTextStyles.bodyMedium
                        .copyWith(letterSpacing: 1),
                    decoration: InputDecoration(
                      hintText: isArabic
                          ? 'مثال: KAYAN10'
                          : 'e.g. KAYAN10',
                    ),
                    onSubmitted: (_) => onApply(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: cart.isApplyingCoupon ? null : onApply,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient:     AppGradients.goldButton,
                      borderRadius: AppBorderRadius.button,
                    ),
                    child: Center(
                      child: cart.isApplyingCoupon
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                color:       Colors.white,
                                strokeWidth: 2,
                              ))
                          : Text(
                              isArabic ? 'تطبيق' : 'Apply',
                              style: (isArabic
                                      ? AppTextStyles.arabicButton
                                      : AppTextStyles.buttonSmall)
                                  .copyWith(color: AppColors.bgPrimary),
                            ),
                    ),
                  ),
                ),
              ],
            ),

          // Error
          if (cart.couponError != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 13, color: AppColors.error),
                const SizedBox(width: 6),
                Text(
                  cart.couponError!,
                  style: (isArabic
                          ? AppTextStyles.arabicCaption
                          : AppTextStyles.caption)
                      .copyWith(color: AppColors.error),
                ),
              ],
            ),
          ],

          // Hint
          if (!hasCoupon && cart.couponError == null) ...[
            const SizedBox(height: 6),
            Text(
              isArabic
                  ? 'جرّب: KAYAN10 للحصول على خصم 10٪'
                  : 'Try: KAYAN10 for 10% off',
              style: (isArabic
                      ? AppTextStyles.arabicCaption
                      : AppTextStyles.caption)
                  .copyWith(color: AppColors.textDisabled),
            ),
          ],
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// ORDER SUMMARY CARD
// ──────────────────────────────────────────────────────────────
class _OrderSummaryCard extends StatelessWidget {
  final CartSummary summary;
  final bool        isArabic;
  const _OrderSummaryCard({required this.summary, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient:     AppGradients.card,
        borderRadius: AppBorderRadius.card,
        border:       Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(
            label:    isArabic ? 'المجموع الفرعي' : 'Subtotal',
            value:    '${summary.subtotal.toInt()} ${summary.currency}',
            isArabic: isArabic,
          ),
          if (summary.couponDiscount > 0) ...[
            const SizedBox(height: 8),
            _SummaryRow(
              label:    isArabic ? 'خصم الكوبون' : 'Coupon Discount',
              value:    '-${summary.couponDiscount.toInt()} ${summary.currency}',
              isArabic: isArabic,
              valueColor: AppColors.success,
            ),
          ],
          const SizedBox(height: 8),
          _SummaryRow(
            label: isArabic ? 'الشحن' : 'Shipping',
            value: summary.isFreeShipping
                ? (isArabic ? 'مجاني 🎉' : 'Free 🎉')
                : '${summary.shipping.toInt()} ${summary.currency}',
            isArabic: isArabic,
            valueColor: summary.isFreeShipping ? AppColors.success : null,
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label:    isArabic ? 'ضريبة القيمة المضافة (15%)' : 'VAT (15%)',
            value:    '${summary.vat.toInt()} ${summary.currency}',
            isArabic: isArabic,
            secondary: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child:   Divider(color: AppColors.borderVisible, height: 1),
          ),
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
                '${summary.total.toInt()} ${summary.currency}',
                style: AppTextStyles.priceLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String  label;
  final String  value;
  final bool    isArabic;
  final Color?  valueColor;
  final bool    secondary;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isArabic,
    this.valueColor,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: (isArabic
                ? AppTextStyles.arabicBodySmall
                : AppTextStyles.bodySmall)
            .copyWith(
          color: secondary ? AppColors.textMuted : AppColors.textSecondary,
        ),
      ),
      Text(
        value,
        style: AppTextStyles.labelMedium.copyWith(
          color: valueColor ?? AppColors.textPrimary,
        ),
      ),
    ],
  );
}

// ──────────────────────────────────────────────────────────────
// CHECKOUT BAR
// ──────────────────────────────────────────────────────────────
class _CheckoutBar extends StatelessWidget {
  final CartSummary  summary;
  final bool         isArabic;
  final VoidCallback onCheckout;

  const _CheckoutBar({
    required this.summary,
    required this.isArabic,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding, 12,
        AppSpacing.pagePadding, 28,
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
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          onCheckout();
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient:     AppGradients.goldButton,
            borderRadius: AppBorderRadius.button,
            boxShadow: [
              BoxShadow(
                color:      AppColors.metallicGold.withOpacity(0.4),
                blurRadius: 20,
                offset:     const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_rounded,
                  color: AppColors.bgPrimary, size: 20),
              const SizedBox(width: 10),
              Text(
                isArabic
                    ? 'إتمام الطلب • ${summary.total.toInt()} ر.س'
                    : 'Checkout • ${summary.total.toInt()} SAR',
                style: (isArabic
                        ? AppTextStyles.arabicButton
                        : AppTextStyles.buttonLarge)
                    .copyWith(color: AppColors.bgPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// EMPTY CART
// ──────────────────────────────────────────────────────────────
class _EmptyCart extends StatelessWidget {
  final bool isArabic;
  const _EmptyCart({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                color:        AppColors.bgCard,
                shape:        BoxShape.circle,
                border:       Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size:  56,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isArabic ? 'السلة فارغة' : 'Your cart is empty',
              style: isArabic
                  ? AppTextStyles.arabicHeadlineSmall
                  : AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isArabic
                  ? 'أضف منتجات إلى سلتك وابدأ التسوق!'
                  : 'Add items to your cart and start shopping!',
              style: (isArabic
                      ? AppTextStyles.arabicBodyMedium
                      : AppTextStyles.bodyMedium)
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => context.go(AppRoutes.shop),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  gradient:     AppGradients.primaryButton,
                  borderRadius: AppBorderRadius.button,
                  boxShadow: [
                    BoxShadow(
                      color:      AppColors.royalBlue.withOpacity(0.35),
                      blurRadius: 16,
                      offset:     const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isArabic ? 'تصفح المنتجات' : 'Browse Products',
                    style: isArabic
                        ? AppTextStyles.arabicButton
                        : AppTextStyles.buttonMedium,
                  ),
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
// CLEAR CART DIALOG
// ──────────────────────────────────────────────────────────────
class _ClearCartDialog extends StatelessWidget {
  final bool         isArabic;
  final VoidCallback onConfirm;
  const _ClearCartDialog({required this.isArabic, required this.onConfirm});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      isArabic ? 'مسح السلة؟' : 'Clear Cart?',
      style: isArabic
          ? AppTextStyles.arabicTitleMedium
          : AppTextStyles.titleMedium,
    ),
    content: Text(
      isArabic
          ? 'هل أنت متأكد من حذف جميع العناصر من السلة؟'
          : 'Are you sure you want to remove all items from your cart?',
      style: isArabic
          ? AppTextStyles.arabicBodyMedium
          : AppTextStyles.bodyMedium,
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          isArabic ? 'إلغاء' : 'Cancel',
          style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary),
        ),
      ),
      TextButton(
        onPressed: () {
          onConfirm();
          Navigator.pop(context);
        },
        child: Text(
          isArabic ? 'حذف' : 'Clear',
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
        ),
      ),
    ],
  );
}
