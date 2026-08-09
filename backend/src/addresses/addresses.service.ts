import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export type AddressInput = {
  label: string;
  recipientName: string;
  phone: string;
  country?: string;
  city: string;
  district: string;
  streetLine1: string;
  streetLine2?: string;
  isDefault?: boolean;
};

@Injectable()
export class AddressesService {
  constructor(private readonly prisma: PrismaService) {}

  list(userId: string) {
    return this.prisma.address
      .findMany({
        where: { userId },
        orderBy: [{ isDefault: 'desc' }, { label: 'asc' }],
      })
      .then((rows) => ({ items: rows.map(this.toJson) }));
  }

  async create(userId: string, input: AddressInput) {
    if (input.isDefault) {
      await this.prisma.address.updateMany({
        where: { userId },
        data: { isDefault: false },
      });
    }
    const count = await this.prisma.address.count({ where: { userId } });
    const address = await this.prisma.address.create({
      data: {
        userId,
        label: input.label,
        recipientName: input.recipientName,
        phone: input.phone,
        country: input.country ?? 'SA',
        city: input.city,
        district: input.district,
        streetLine1: input.streetLine1,
        streetLine2: input.streetLine2,
        isDefault: input.isDefault ?? count === 0,
      },
    });
    return this.toJson(address);
  }

  async update(userId: string, id: string, input: Partial<AddressInput>) {
    await this.requireOwned(userId, id);
    if (input.isDefault) {
      await this.prisma.address.updateMany({
        where: { userId },
        data: { isDefault: false },
      });
    }
    const address = await this.prisma.address.update({
      where: { id },
      data: {
        label: input.label,
        recipientName: input.recipientName,
        phone: input.phone,
        country: input.country,
        city: input.city,
        district: input.district,
        streetLine1: input.streetLine1,
        streetLine2: input.streetLine2,
        isDefault: input.isDefault,
      },
    });
    return this.toJson(address);
  }

  async remove(userId: string, id: string) {
    await this.requireOwned(userId, id);
    await this.prisma.address.delete({ where: { id } });
    return { ok: true };
  }

  async setDefault(userId: string, id: string) {
    await this.requireOwned(userId, id);
    await this.prisma.address.updateMany({
      where: { userId },
      data: { isDefault: false },
    });
    const address = await this.prisma.address.update({
      where: { id },
      data: { isDefault: true },
    });
    return this.toJson(address);
  }

  private async requireOwned(userId: string, id: string) {
    const address = await this.prisma.address.findFirst({
      where: { id, userId },
    });
    if (!address) throw new NotFoundException('address_not_found');
    return address;
  }

  private toJson(a: {
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
  }) {
    return {
      id: a.id,
      label: a.label,
      recipientName: a.recipientName,
      phone: a.phone,
      country: a.country,
      city: a.city,
      district: a.district,
      streetLine1: a.streetLine1,
      streetLine2: a.streetLine2,
      isDefault: a.isDefault,
    };
  }
}
