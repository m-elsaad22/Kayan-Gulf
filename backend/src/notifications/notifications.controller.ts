import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import {
  IsArray,
  IsObject,
  IsOptional,
  IsString,
  MinLength,
} from 'class-validator';
import { AdminGuard } from '../auth/admin.guard';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AuthUser, CurrentUser } from '../common/current-user.decorator';
import { NotificationsService } from './notifications.service';

class PushUserDto {
  @IsString()
  @MinLength(2)
  title!: string;

  @IsString()
  @MinLength(1)
  body!: string;

  @IsOptional()
  @IsObject()
  data?: Record<string, string>;
}

class PushTokensDto {
  @IsArray()
  tokens!: string[];

  @IsString()
  title!: string;

  @IsString()
  body!: string;

  @IsOptional()
  @IsObject()
  data?: Record<string, string>;
}

@Controller('notifications')
@UseGuards(JwtAuthGuard)
export class NotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  /** Push to the authenticated user's registered devices. */
  @Post('push/me')
  pushMe(@CurrentUser() user: AuthUser, @Body() dto: PushUserDto) {
    return this.notifications.pushToUser(user.userId, dto);
  }

  /** Admin-only: push to explicit device tokens. */
  @Post('push')
  @UseGuards(AdminGuard)
  pushTokens(@Body() dto: PushTokensDto) {
    return this.notifications.pushToTokens(dto);
  }
}
