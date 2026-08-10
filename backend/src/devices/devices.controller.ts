import { Body, Controller, Delete, Post, UseGuards } from '@nestjs/common';
import { IsIn, IsOptional, IsString, MinLength } from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AuthUser, CurrentUser } from '../common/current-user.decorator';
import { DevicesService } from './devices.service';

class RegisterDeviceDto {
  @IsString()
  @MinLength(10)
  token!: string;

  @IsOptional()
  @IsIn(['android', 'ios', 'web'])
  platform?: string;

  @IsOptional()
  @IsString()
  locale?: string;

  @IsOptional()
  @IsString()
  appVersion?: string;

  @IsOptional()
  @IsString()
  deviceName?: string;
}

class UnregisterDeviceDto {
  @IsString()
  @MinLength(10)
  token!: string;
}

@Controller('devices')
@UseGuards(JwtAuthGuard)
export class DevicesController {
  constructor(private readonly devices: DevicesService) {}

  @Post('fcm')
  register(@CurrentUser() user: AuthUser, @Body() dto: RegisterDeviceDto) {
    return this.devices.register(user.userId, dto);
  }

  @Delete('fcm')
  unregister(@CurrentUser() user: AuthUser, @Body() dto: UnregisterDeviceDto) {
    return this.devices.unregister(user.userId, dto.token);
  }
}
