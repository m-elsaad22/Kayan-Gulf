import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { IsInt, IsOptional, IsString, Min, MinLength } from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser, AuthUser } from '../common/current-user.decorator';
import { CartService } from './cart.service';

class AddCartItemDto {
  @IsString()
  productId!: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  quantity?: number;

  @IsOptional()
  @IsString()
  selectedColor?: string;

  @IsOptional()
  @IsString()
  selectedSize?: string;
}

class UpdateCartItemDto {
  @IsInt()
  @Min(1)
  quantity!: number;
}

class CouponDto {
  @IsString()
  @MinLength(2)
  code!: string;
}

@Controller('cart')
@UseGuards(JwtAuthGuard)
export class CartController {
  constructor(private readonly cart: CartService) {}

  @Get()
  get(@CurrentUser() user: AuthUser) {
    return this.cart.getOrCreateCart(user.userId);
  }

  @Post('items')
  add(@CurrentUser() user: AuthUser, @Body() dto: AddCartItemDto) {
    return this.cart.addItem(user.userId, dto);
  }

  @Patch('items/:cartItemId')
  update(
    @CurrentUser() user: AuthUser,
    @Param('cartItemId') cartItemId: string,
    @Body() dto: UpdateCartItemDto,
  ) {
    return this.cart.updateItem(user.userId, cartItemId, dto.quantity);
  }

  @Delete('items/:cartItemId')
  remove(
    @CurrentUser() user: AuthUser,
    @Param('cartItemId') cartItemId: string,
  ) {
    return this.cart.removeItem(user.userId, cartItemId);
  }

  @Delete()
  clear(@CurrentUser() user: AuthUser) {
    return this.cart.clear(user.userId);
  }

  @Post('coupon')
  applyCoupon(@CurrentUser() user: AuthUser, @Body() dto: CouponDto) {
    return this.cart.applyCoupon(user.userId, dto.code);
  }

  @Delete('coupon')
  removeCoupon(@CurrentUser() user: AuthUser) {
    return this.cart.removeCoupon(user.userId);
  }
}
