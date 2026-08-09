import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { computeCouponDiscount, computeSummary } from '../common/pricing';

const cartInclude = {
  items: {
    include: {
      product: {
        include: {
          images: { orderBy: { sortOrder: 'asc' as const } },
        },
      },
    },
  },
};

@Injectable()
export class CartService {
  constructor(private readonly prisma: PrismaService) {}

  async getOrCreateCart(userId: string) {
    let cart = await this.prisma.cart.findUnique({
      where: { userId },
      include: cartInclude,
    });
    if (!cart) {
      cart = await this.prisma.cart.create({
        data: { userId },
        include: cartInclude,
      });
    }
    return this.toResponse(cart);
  }

  async addItem(
    userId: string,
    body: {
      productId: string;
      quantity?: number;
      selectedColor?: string;
      selectedSize?: string;
    },
  ) {
    const qty = Math.max(1, body.quantity ?? 1);
    const product = await this.prisma.product.findUnique({
      where: { id: body.productId },
    });
    if (!product || product.status !== 'ACTIVE') {
      throw new NotFoundException('product_not_found');
    }
    if (product.stock < qty) {
      throw new BadRequestException('insufficient_stock');
    }

    const cart = await this.ensureCart(userId);
    const existing = await this.prisma.cartItem.findFirst({
      where: {
        cartId: cart.id,
        productId: body.productId,
        selectedColor: body.selectedColor ?? null,
        selectedSize: body.selectedSize ?? null,
      },
    });

    if (existing) {
      const nextQty = Math.min(existing.quantity + qty, product.stock);
      await this.prisma.cartItem.update({
        where: { id: existing.id },
        data: { quantity: nextQty },
      });
    } else {
      await this.prisma.cartItem.create({
        data: {
          cartId: cart.id,
          productId: body.productId,
          quantity: Math.min(qty, product.stock),
          selectedColor: body.selectedColor,
          selectedSize: body.selectedSize,
        },
      });
    }

    return this.getOrCreateCart(userId);
  }

  async updateItem(userId: string, cartItemId: string, quantity: number) {
    const cart = await this.ensureCart(userId);
    const item = await this.prisma.cartItem.findFirst({
      where: { id: cartItemId, cartId: cart.id },
      include: { product: true },
    });
    if (!item) throw new NotFoundException('cart_item_not_found');

    const qty = Math.max(1, Math.min(quantity, item.product.stock));
    await this.prisma.cartItem.update({
      where: { id: item.id },
      data: { quantity: qty },
    });
    return this.getOrCreateCart(userId);
  }

  async removeItem(userId: string, cartItemId: string) {
    const cart = await this.ensureCart(userId);
    await this.prisma.cartItem.deleteMany({
      where: { id: cartItemId, cartId: cart.id },
    });
    return this.getOrCreateCart(userId);
  }

  async clear(userId: string) {
    const cart = await this.ensureCart(userId);
    await this.prisma.cartItem.deleteMany({ where: { cartId: cart.id } });
    await this.prisma.cart.update({
      where: { id: cart.id },
      data: { couponCode: null, couponDiscount: 0 },
    });
    return this.getOrCreateCart(userId);
  }

  async applyCoupon(userId: string, code: string) {
    const cart = await this.prisma.cart.findUnique({
      where: { userId },
      include: cartInclude,
    });
    if (!cart) throw new NotFoundException('cart_not_found');

    const subtotal = cart.items.reduce(
      (s, i) => s + i.product.price * i.quantity,
      0,
    );
    const { couponCode, couponDiscount } = computeCouponDiscount(code, subtotal);
    if (!couponCode) {
      throw new BadRequestException('invalid_coupon');
    }

    await this.prisma.cart.update({
      where: { id: cart.id },
      data: { couponCode, couponDiscount },
    });
    return this.getOrCreateCart(userId);
  }

  async removeCoupon(userId: string) {
    const cart = await this.ensureCart(userId);
    await this.prisma.cart.update({
      where: { id: cart.id },
      data: { couponCode: null, couponDiscount: 0 },
    });
    return this.getOrCreateCart(userId);
  }

  /** Used by order placement — returns raw cart with products. */
  async getCartEntity(userId: string) {
    return this.prisma.cart.findUnique({
      where: { userId },
      include: cartInclude,
    });
  }

  private async ensureCart(userId: string) {
    return this.prisma.cart.upsert({
      where: { userId },
      create: { userId },
      update: {},
    });
  }

  private toResponse(cart: {
    couponCode: string | null;
    items: Array<{
      id: string;
      productId: string;
      quantity: number;
      selectedColor: string | null;
      selectedSize: string | null;
      product: {
        slug: string;
        nameAr: string;
        nameEn: string;
        price: number;
        stock: number;
        images: Array<{ url: string; isMain: boolean }>;
      };
    }>;
  }) {
    const items = cart.items.map((i) => {
      const main =
        i.product.images.find((img) => img.isMain) ?? i.product.images[0];
      return {
        cartItemId: i.id,
        productId: i.productId,
        slug: i.product.slug,
        nameAr: i.product.nameAr,
        nameEn: i.product.nameEn,
        imageUrl: main?.url ?? null,
        unitPrice: i.product.price,
        quantity: i.quantity,
        selectedColor: i.selectedColor,
        selectedSize: i.selectedSize,
        maxStock: i.product.stock,
      };
    });

    const subtotal = items.reduce((s, i) => s + i.unitPrice * i.quantity, 0);
    const itemCount = items.reduce((s, i) => s + i.quantity, 0);
    const recomputed = computeCouponDiscount(cart.couponCode, subtotal);
    const summary = computeSummary(
      subtotal,
      recomputed.couponDiscount,
      recomputed.couponCode,
      itemCount,
    );

    return { items, summary };
  }
}
