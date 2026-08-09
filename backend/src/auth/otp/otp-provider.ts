export interface OtpSmsProvider {
  readonly name: string;
  sendSms(phone: string, message: string): Promise<void>;
}
