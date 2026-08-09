import { Logger } from '@nestjs/common';
import { OtpSmsProvider } from './otp-provider';

export class DevOtpProvider implements OtpSmsProvider {
  readonly name = 'dev';
  private readonly logger = new Logger(DevOtpProvider.name);

  async sendSms(phone: string, message: string): Promise<void> {
    this.logger.log(`[dev OTP SMS] to=${phone} message=${message}`);
  }
}
