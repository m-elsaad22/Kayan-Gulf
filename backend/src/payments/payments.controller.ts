import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { IsIn, IsOptional, IsString, MinLength } from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AuthUser, CurrentUser } from '../common/current-user.decorator';
import { PaymentsService } from './payments.service';

class IntentDto {
  @IsString()
  @MinLength(3)
  orderId!: string;

  @IsIn(['cod', 'tabby', 'tamara', 'card', 'applepay', 'wallet'])
  paymentMethod!: string;
}

class ConfirmDto {
  @IsString()
  orderId!: string;

  @IsString()
  providerRef!: string;
}

class WebhookDto {
  @IsOptional()
  @IsString()
  orderId?: string;

  @IsOptional()
  @IsString()
  providerRef?: string;

  @IsOptional()
  @IsString()
  status?: string;
}

@Controller()
export class PaymentsController {
  constructor(private readonly payments: PaymentsService) {}

  @Post('payments/intent')
  @UseGuards(JwtAuthGuard)
  intent(@CurrentUser() user: AuthUser, @Body() dto: IntentDto) {
    return this.payments.createIntent(user.userId, dto);
  }

  @Post('payments/confirm')
  @UseGuards(JwtAuthGuard)
  confirm(@CurrentUser() user: AuthUser, @Body() dto: ConfirmDto) {
    return this.payments.confirm(user.userId, dto);
  }

  @Post('webhooks/payments')
  webhook(@Body() dto: WebhookDto) {
    return this.payments.webhook(dto);
  }
}
