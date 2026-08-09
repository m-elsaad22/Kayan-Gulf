import { Logger } from '@nestjs/common';
import { OtpSmsProvider } from './otp-provider';

/**
 * Unifonic Cloud SMS (GCC-friendly).
 * Docs: https://docs.unifonic.com/
 *
 * Env:
 * - UNIFONIC_APP_SID
 * - UNIFONIC_SENDER_ID
 * - UNIFONIC_BASE_URL (optional, default el.cloud.unifonic.com)
 */
export class UnifonicOtpProvider implements OtpSmsProvider {
  readonly name = 'unifonic';
  private readonly logger = new Logger(UnifonicOtpProvider.name);

  constructor(
    private readonly appSid: string,
    private readonly senderId: string,
    private readonly baseUrl = 'https://el.cloud.unifonic.com',
  ) {}

  async sendSms(phone: string, message: string): Promise<void> {
    if (!this.appSid) {
      throw new Error('UNIFONIC_APP_SID is required');
    }

    const recipient = phone.replace(/^\+/, '');
    const url = `${this.baseUrl.replace(/\/$/, '')}/rest/SMS/messages`;
    const body = new URLSearchParams({
      AppSid: this.appSid,
      SenderID: this.senderId || 'KAYAN',
      Body: message,
      Recipient: recipient,
    });

    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body,
    });

    const text = await res.text();
    if (!res.ok) {
      this.logger.error(`Unifonic failed status=${res.status} body=${text}`);
      throw new Error(`unifonic_sms_failed:${res.status}`);
    }

    this.logger.log(`Unifonic SMS accepted for ${phone}`);
  }
}
