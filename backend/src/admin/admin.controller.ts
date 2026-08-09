import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  UseGuards,
} from '@nestjs/common';
import { IsString } from 'class-validator';
import { AdminGuard } from '../auth/admin.guard';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AdminService } from './admin.service';

class StatusDto {
  @IsString()
  status!: string;
}

@Controller('admin')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AdminController {
  constructor(private readonly admin: AdminService) {}

  @Get('stats')
  stats() {
    return this.admin.stats();
  }

  @Get('users')
  users() {
    return this.admin.listUsers();
  }

  @Get('products')
  products() {
    return this.admin.listProducts();
  }

  @Patch('products/:id/status')
  productStatus(@Param('id') id: string, @Body() dto: StatusDto) {
    return this.admin.updateProductStatus(id, dto.status);
  }

  @Get('orders')
  orders() {
    return this.admin.listOrders();
  }

  @Patch('orders/:id/status')
  orderStatus(@Param('id') id: string, @Body() dto: StatusDto) {
    return this.admin.updateOrderStatus(id, dto.status);
  }

  @Get('services')
  services() {
    return this.admin.listServices();
  }

  @Get('bookings')
  bookings() {
    return this.admin.listBookings();
  }

  @Get('ads')
  ads() {
    return this.admin.listAds();
  }

  @Patch('ads/:id/status')
  adStatus(@Param('id') id: string, @Body() dto: StatusDto) {
    return this.admin.updateAdStatus(id, dto.status);
  }

  @Get('banners')
  banners() {
    return this.admin.listBanners();
  }
}
