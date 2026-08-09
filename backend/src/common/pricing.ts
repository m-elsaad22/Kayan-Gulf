/** KSA VAT + shipping rules used by cart and order placement. */
export const VAT_RATE = 0.15;
export const FREE_SHIPPING_THRESHOLD = 200;
export const SHIPPING_FLAT = 25;

export type MoneySummary = {
  subtotal: number;
  discount: number;
  shipping: number;
  vat: number;
  total: number;
  currency: 'SAR';
  couponCode: string | null;
  couponDiscount: number;
  itemCount: number;
};

export function computeCouponDiscount(
  code: string | null | undefined,
  subtotal: number,
): { couponCode: string | null; couponDiscount: number } {
  if (!code) return { couponCode: null, couponDiscount: 0 };
  const normalized = code.trim().toUpperCase();
  if (normalized === 'KAYAN10') {
    return { couponCode: normalized, couponDiscount: round2(subtotal * 0.1) };
  }
  if (normalized === 'KAYAN50') {
    return { couponCode: normalized, couponDiscount: Math.min(50, subtotal) };
  }
  return { couponCode: null, couponDiscount: 0 };
}

export function computeSummary(
  subtotal: number,
  couponDiscount: number,
  couponCode: string | null,
  itemCount: number,
): MoneySummary {
  const discount = Math.min(couponDiscount, subtotal);
  const afterCoupon = Math.max(0, subtotal - discount);
  const shipping = afterCoupon >= FREE_SHIPPING_THRESHOLD ? 0 : SHIPPING_FLAT;
  const vat = round2(afterCoupon * VAT_RATE);
  const total = round2(afterCoupon + shipping + vat);
  return {
    subtotal: round2(subtotal),
    discount: round2(discount),
    shipping,
    vat,
    total,
    currency: 'SAR',
    couponCode,
    couponDiscount: round2(discount),
    itemCount,
  };
}

export function round2(n: number): number {
  return Math.round(n * 100) / 100;
}

export function statusLabels(status: string): {
  statusAr: string;
  statusEn: string;
} {
  switch (status) {
    case 'paid':
      return { statusAr: 'تم الدفع', statusEn: 'Paid' };
    case 'shipping':
      return { statusAr: 'قيد الشحن', statusEn: 'Shipping' };
    case 'delivered':
      return { statusAr: 'تم التسليم', statusEn: 'Delivered' };
    case 'cancelled':
      return { statusAr: 'ملغي', statusEn: 'Cancelled' };
    case 'pending':
    default:
      return { statusAr: 'قيد الانتظار', statusEn: 'Pending' };
  }
}
