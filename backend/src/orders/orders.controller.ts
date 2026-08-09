import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import {
  IsBoolean,
  IsIn,
  IsOptional,
  IsString,
  MinLength,
} from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AuthUser, CurrentUser } from '../common/current-user.decorator';
import { OrdersService } from './orders.service';

const PAYMENT_METHODS = [
  'cod',
  'tabby',
  'tamara',
  'card',
  'applepay',
  'wallet',
] as const;

class CreateOrderDto {
  @IsString()
  @MinLength(1)
  addressId!: string;

  @IsIn(PAYMENT_METHODS as unknown as string[])
  paymentMethod!: (typeof PAYMENT_METHODS)[number];

  @IsOptional()
  @IsString()
  couponCode?: string;

  @IsOptional()
  @IsBoolean()
  agreeToTerms?: boolean;
}

@Controller('orders')
@UseGuards(JwtAuthGuard)
export class OrdersController {
  constructor(private readonly orders: OrdersService) {}

  @Post()
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateOrderDto) {
    return this.orders.create(user.userId, dto);
  }

  @Get()
  list(@CurrentUser() user: AuthUser) {
    return this.orders.list(user.userId);
  }

  @Get(':id')
  detail(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.orders.detail(user.userId, id);
  }

  @Get(':id/tracking')
  tracking(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.orders.tracking(user.userId, id);
  }
}
