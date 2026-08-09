import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { CartService } from '../cart/cart.service';
import {
  computeCouponDiscount,
  computeSummary,
  statusLabels,
} from '../common/pricing';
import { NotificationsService } from '../notifications/notifications.service';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class OrdersService {
  private readonly logger = new Logger(OrdersService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly cart: CartService,
    private readonly notifications: NotificationsService,
  ) {}

  async create(
    userId: string,
    body: {
      addressId: string;
      paymentMethod: string;
      couponCode?: string | null;
      agreeToTerms?: boolean;
    },
  ) {
    if (body.agreeToTerms === false) {
      throw new BadRequestException('terms_required');
    }

    const address = await this.prisma.address.findFirst({
      where: { id: body.addressId, userId },
    });
    if (!address) throw new NotFoundException('address_not_found');

    const cart = await this.cart.getCartEntity(userId);
    if (!cart || cart.items.length === 0) {
      throw new BadRequestException('cart_empty');
    }

    const subtotal = cart.items.reduce(
      (s, i) => s + i.product.price * i.quantity,
      0,
    );
    const couponSource = body.couponCode ?? cart.couponCode;
    const { couponCode, couponDiscount } = computeCouponDiscount(
      couponSource,
      subtotal,
    );
    const itemCount = cart.items.reduce((s, i) => s + i.quantity, 0);
    const summary = computeSummary(
      subtotal,
      couponDiscount,
      couponCode,
      itemCount,
    );

    const first = cart.items[0];
    const orderId = `KYN-${Date.now().toString().slice(-10)}`;
    const initialStatus =
      body.paymentMethod === 'cod' ? 'pending' : 'pending';

    const order = await this.prisma.$transaction(async (tx) => {
      const created = await tx.order.create({
        data: {
          id: orderId,
          userId,
          addressId: address.id,
          status: initialStatus,
          paymentMethod: body.paymentMethod,
          couponCode,
          subtotal: summary.subtotal,
          discount: summary.discount,
          shipping: summary.shipping,
          vat: summary.vat,
          total: summary.total,
          currency: 'SAR',
          titleAr: first.product.nameAr,
          titleEn: first.product.nameEn,
          items: {
            create: cart.items.map((i) => {
              const main =
                i.product.images.find((img) => img.isMain) ??
                i.product.images[0];
              return {
                productId: i.productId,
                slug: i.product.slug,
                nameAr: i.product.nameAr,
                nameEn: i.product.nameEn,
                imageUrl: main?.url,
                unitPrice: i.product.price,
                quantity: i.quantity,
                selectedColor: i.selectedColor,
                selectedSize: i.selectedSize,
              };
            }),
          },
        },
        include: { items: true, address: true },
      });

      await tx.cartItem.deleteMany({ where: { cartId: cart.id } });
      await tx.cart.update({
        where: { id: cart.id },
        data: { couponCode: null, couponDiscount: 0 },
      });

      return created;
    });

    void this.notifications
      .pushToUser(userId, {
        title: 'تم استلام طلبك',
        body: `طلب ${order.id} قيد المعالجة`,
        data: { orderId: order.id, type: 'order_created' },
      })
      .catch((err) =>
        this.logger.warn(`order push failed for ${order.id}: ${err}`),
      );

    return this.toJson(order);
  }

  async list(userId: string) {
    const orders = await this.prisma.order.findMany({
      where: { userId },
      include: { items: true, address: true },
      orderBy: { createdAt: 'desc' },
    });
    return { items: orders.map((o) => this.toJson(o)) };
  }

  async detail(userId: string, id: string) {
    const order = await this.prisma.order.findFirst({
      where: { id, userId },
      include: { items: true, address: true },
    });
    if (!order) throw new NotFoundException('order_not_found');
    return this.toJson(order);
  }

  async tracking(userId: string, id: string) {
    const order = await this.detail(userId, id);
    const steps = [
      { key: 'pending', labelAr: 'تم استلام الطلب', labelEn: 'Order received' },
      { key: 'paid', labelAr: 'تم الدفع', labelEn: 'Payment confirmed' },
      { key: 'shipping', labelAr: 'قيد الشحن', labelEn: 'Out for delivery' },
      { key: 'delivered', labelAr: 'تم التسليم', labelEn: 'Delivered' },
    ];
    const orderIndex = steps.findIndex((s) => s.key === order.status);
    return {
      orderId: order.id,
      status: order.status,
      ...statusLabels(order.status),
      steps: steps.map((s, i) => ({
        ...s,
        done: orderIndex >= 0 && i <= orderIndex,
        current: s.key === order.status,
      })),
    };
  }

  async markPaid(orderId: string) {
    return this.prisma.order.update({
      where: { id: orderId },
      data: { status: 'paid' },
      include: { items: true, address: true },
    });
  }

  private toJson(order: {
    id: string;
    status: string;
    paymentMethod: string;
    couponCode: string | null;
    subtotal: number;
    discount: number;
    shipping: number;
    vat: number;
    total: number;
    currency: string;
    titleAr: string | null;
    titleEn: string | null;
    createdAt: Date;
    items: Array<{
      id: string;
      productId: string;
      slug: string;
      nameAr: string;
      nameEn: string;
      imageUrl: string | null;
      unitPrice: number;
      quantity: number;
      selectedColor: string | null;
      selectedSize: string | null;
    }>;
    address: {
      id: string;
      label: string;
      recipientName: string;
      phone: string;
      country: string;
      city: string;
      district: string;
      streetLine1: string;
      streetLine2: string | null;
      isDefault: boolean;
    } | null;
  }) {
    const labels = statusLabels(order.status);
    const itemCount = order.items.reduce((s, i) => s + i.quantity, 0);
    return {
      id: order.id,
      titleAr: order.titleAr,
      titleEn: order.titleEn,
      status: order.status,
      statusAr: labels.statusAr,
      statusEn: labels.statusEn,
      items: order.items.map((i) => ({
        productId: i.productId,
        slug: i.slug,
        nameAr: i.nameAr,
        nameEn: i.nameEn,
        imageUrl: i.imageUrl,
        unitPrice: i.unitPrice,
        quantity: i.quantity,
        selectedColor: i.selectedColor,
        selectedSize: i.selectedSize,
      })),
      itemCount,
      subtotal: order.subtotal,
      discount: order.discount,
      shipping: order.shipping,
      vat: order.vat,
      total: order.total,
      currency: order.currency,
      paymentMethod: order.paymentMethod,
      couponCode: order.couponCode,
      address: order.address
        ? {
            id: order.address.id,
            label: order.address.label,
            recipientName: order.address.recipientName,
            phone: order.address.phone,
            country: order.address.country,
            city: order.address.city,
            district: order.address.district,
            streetLine1: order.address.streetLine1,
            streetLine2: order.address.streetLine2,
            isDefault: order.address.isDefault,
          }
        : null,
      createdAt: order.createdAt.toISOString(),
      date: order.createdAt.toISOString().slice(0, 10),
    };
  }
}
