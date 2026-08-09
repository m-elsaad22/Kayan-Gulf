import { HttpException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OtpService } from '../otp.service';

describe('OtpService rate limit', () => {
  const prisma = {
    otpCode: {
      create: jest.fn().mockResolvedValue({}),
      count: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
  };

  const configMap: Record<string, string> = {
    OTP_PROVIDER: 'dev',
    OTP_STRICT: 'false',
    OTP_TTL_MINUTES: '10',
    OTP_MAX_PER_HOUR: '2',
    OTP_COOLDOWN_SECONDS: '60',
  };

  const config = {
    get: (key: string) => configMap[key],
  } as unknown as ConfigService;

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('throws otp_cooldown when last send is recent', async () => {
    prisma.otpCode.count.mockResolvedValue(0);
    prisma.otpCode.findFirst.mockResolvedValue({
      createdAt: new Date(),
    });

    const service = new OtpService(prisma as never, config);
    await expect(service.send('+966500000001')).rejects.toBeInstanceOf(
      HttpException,
    );
  });

  it('sends in dev mode when under limits', async () => {
    prisma.otpCode.count.mockResolvedValue(0);
    prisma.otpCode.findFirst.mockResolvedValue(null);

    const service = new OtpService(prisma as never, config);
    const result = await service.send('+966500000001');
    expect(result).toEqual({ ok: true, provider: 'dev' });
    expect(prisma.otpCode.create).toHaveBeenCalled();
  });
});
