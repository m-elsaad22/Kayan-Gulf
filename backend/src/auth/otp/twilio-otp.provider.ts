import { Logger } from '@nestjs/common';
import { OtpSmsProvider } from './otp-provider';

/**
 * Twilio SMS.
 * Env: TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_FROM_NUMBER
 */
export class TwilioOtpProvider implements OtpSmsProvider {
  readonly name = 'twilio';
  private readonly logger = new Logger(TwilioOtpProvider.name);

  constructor(
    private readonly accountSid: string,
    private readonly authToken: string,
    private readonly fromNumber: string,
  ) {}

  async sendSms(phone: string, message: string): Promise<void> {
    if (!this.accountSid || !this.authToken || !this.fromNumber) {
      throw new Error('Twilio credentials incomplete');
    }

    const url = `https://api.twilio.com/2010-04-01/Accounts/${this.accountSid}/Messages.json`;
    const body = new URLSearchParams({
      To: phone.startsWith('+') ? phone : `+${phone}`,
      From: this.fromNumber,
      Body: message,
    });

    const auth = Buffer.from(`${this.accountSid}:${this.authToken}`).toString(
      'base64',
    );

    const res = await fetch(url, {
      method: 'POST',
      headers: {
        Authorization: `Basic ${auth}`,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body,
    });

    const text = await res.text();
    if (!res.ok) {
      this.logger.error(`Twilio failed status=${res.status} body=${text}`);
      throw new Error(`twilio_sms_failed:${res.status}`);
    }

    this.logger.log(`Twilio SMS accepted for ${phone}`);
  }
}
