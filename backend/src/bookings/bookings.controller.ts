import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { IsOptional, IsString, MinLength } from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AuthUser, CurrentUser } from '../common/current-user.decorator';
import { BookingsService } from './bookings.service';

class CreateBookingDto {
  @IsString()
  serviceId!: string;

  @IsString()
  scheduledAt!: string;

  @IsString()
  @MinLength(3)
  addressLine!: string;

  @IsOptional()
  @IsString()
  notes?: string;
}

class StatusDto {
  @IsString()
  status!: string;
}

@Controller('bookings')
@UseGuards(JwtAuthGuard)
export class BookingsController {
  constructor(private readonly bookings: BookingsService) {}

  @Get()
  list(@CurrentUser() user: AuthUser, @Query('status') status?: string) {
    return this.bookings.list(user.userId, status);
  }

  @Post()
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateBookingDto) {
    return this.bookings.create(user.userId, dto);
  }

  @Get(':id')
  detail(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.bookings.detail(user.userId, id);
  }

  @Patch(':id/status')
  status(
    @CurrentUser() user: AuthUser,
    @Param('id') id: string,
    @Body() dto: StatusDto,
  ) {
    return this.bookings.updateStatus(user.userId, id, dto.status);
  }
}
