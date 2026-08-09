import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class BookingsService {
  constructor(private readonly prisma: PrismaService) {}

  async list(userId: string, status?: string) {
    const bookings = await this.prisma.booking.findMany({
      where: {
        userId,
        ...(status ? { status } : {}),
      },
      include: { service: true },
      orderBy: { scheduledAt: 'desc' },
    });
    return { items: bookings.map((b) => this.toJson(b)) };
  }

  async detail(userId: string, id: string) {
    const booking = await this.prisma.booking.findFirst({
      where: { id, userId },
      include: { service: true },
    });
    if (!booking) throw new NotFoundException('booking_not_found');
    return { booking: this.toJson(booking) };
  }

  async create(
    userId: string,
    body: {
      serviceId: string;
      scheduledAt: string;
      addressLine: string;
      notes?: string;
    },
  ) {
    const service = await this.prisma.service.findUnique({
      where: { id: body.serviceId },
    });
    if (!service || !service.isAvailable) {
      throw new NotFoundException('service_not_found');
    }

    const scheduledAt = new Date(body.scheduledAt);
    if (Number.isNaN(scheduledAt.getTime())) {
      throw new BadRequestException('invalid_scheduled_at');
    }

    const bookingNumber = `BK-${Date.now().toString().slice(-7)}`;
    const price = service.discountedPrice ?? service.basePrice;

    const booking = await this.prisma.$transaction(async (tx) => {
      const created = await tx.booking.create({
        data: {
          bookingNumber,
          userId,
          serviceId: service.id,
          price,
          currency: service.currency,
          scheduledAt,
          status: 'CONFIRMED',
          addressLine: body.addressLine,
          notes: body.notes,
        },
        include: { service: true },
      });
      await tx.service.update({
        where: { id: service.id },
        data: { totalBookings: { increment: 1 } },
      });
      return created;
    });

    return this.toJson(booking);
  }

  async updateStatus(
    userId: string,
    id: string,
    status: string,
  ) {
    const allowed = [
      'PENDING',
      'CONFIRMED',
      'IN_PROGRESS',
      'COMPLETED',
      'CANCELLED',
    ];
    if (!allowed.includes(status)) {
      throw new BadRequestException('invalid_status');
    }
    const existing = await this.prisma.booking.findFirst({
      where: { id, userId },
    });
    if (!existing) throw new NotFoundException('booking_not_found');

    const booking = await this.prisma.booking.update({
      where: { id },
      data: { status },
      include: { service: true },
    });
    return this.toJson(booking);
  }

  private toJson(b: {
    id: string;
    bookingNumber: string;
    serviceId: string;
    price: number;
    currency: string;
    scheduledAt: Date;
    status: string;
    addressLine: string;
    notes: string | null;
    service: { nameAr: string; nameEn: string };
  }) {
    return {
      id: b.id,
      bookingNumber: b.bookingNumber,
      serviceNameAr: b.service.nameAr,
      serviceNameEn: b.service.nameEn,
      serviceId: b.serviceId,
      price: b.price,
      currency: b.currency,
      scheduledAt: b.scheduledAt.toISOString(),
      status: b.status,
      addressLine: b.addressLine,
      notes: b.notes,
    };
  }
}
