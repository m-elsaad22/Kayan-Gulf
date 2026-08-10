import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  IsBoolean,
  IsOptional,
  IsString,
  IsIn,
} from 'class-validator';
import {
  AdminGuard,
  PrivilegedAdminGuard,
} from '../auth/admin.guard';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AuthUser, CurrentUser } from '../common/current-user.decorator';
import { AdminService } from './admin.service';

class StatusDto {
  @IsString()
  status!: string;
}

class UpdateUserDto {
  @IsOptional()
  @IsString()
  role?: string;

  @IsOptional()
  @IsString()
  status?: string;

  @IsOptional()
  @IsString()
  name?: string;
}

class UpdateAppControlDto {
  @IsOptional()
  @IsBoolean()
  enabled?: boolean;

  @IsOptional()
  @IsBoolean()
  maintenanceMode?: boolean;

  @IsOptional()
  @IsString()
  messageAr?: string;

  @IsOptional()
  @IsString()
  messageEn?: string;

  @IsOptional()
  @IsString()
  minVersion?: string;

  @IsOptional()
  @IsString()
  latestVersion?: string;

  @IsOptional()
  @IsBoolean()
  forceUpdate?: boolean;

  @IsOptional()
  @IsString()
  supportUrl?: string;

  @IsOptional()
  @IsString()
  websiteUrl?: string;

  @IsOptional()
  @IsString()
  apkUrl?: string | null;

  @IsOptional()
  @IsString()
  playStoreUrl?: string | null;
}

class DeviceStatusDto {
  @IsIn(['active', 'inactive'])
  status!: 'active' | 'inactive';
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
  users(
    @Query('q') q?: string,
    @Query('status') status?: string,
    @Query('role') role?: string,
  ) {
    return this.admin.listUsers({ q, status, role });
  }

  @Get('users/:id')
  user(@Param('id') id: string) {
    return this.admin.getUser(id);
  }

  @Patch('users/:id')
  @UseGuards(PrivilegedAdminGuard)
  updateUser(
    @Param('id') id: string,
    @Body() dto: UpdateUserDto,
    @CurrentUser() actor: AuthUser,
  ) {
    return this.admin.updateUser(id, dto, {
      userId: actor.userId,
      role: actor.role,
    });
  }

  @Patch('users/:userId/devices/:deviceId')
  @UseGuards(PrivilegedAdminGuard)
  deviceStatus(
    @Param('userId') userId: string,
    @Param('deviceId') deviceId: string,
    @Body() dto: DeviceStatusDto,
    @CurrentUser() actor: AuthUser,
  ) {
    return this.admin.setDeviceStatus(
      userId,
      deviceId,
      dto.status,
      actor.userId,
    );
  }

  @Get('app-control')
  appControl() {
    return this.admin.getAppControl();
  }

  @Patch('app-control')
  @UseGuards(PrivilegedAdminGuard)
  updateAppControl(
    @Body() dto: UpdateAppControlDto,
    @CurrentUser() actor: AuthUser,
  ) {
    return this.admin.updateAppControl(dto, actor.userId);
  }

  @Get('audit-logs')
  auditLogs(@Query('take') take?: string) {
    return this.admin.listAuditLogs(take ? Number(take) : 50);
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
