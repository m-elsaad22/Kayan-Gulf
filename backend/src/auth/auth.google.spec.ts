import { UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';

describe('AuthService Google audience helpers', () => {
  const prisma = {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    refreshToken: { create: jest.fn() },
    $transaction: jest.fn(async (ops: unknown[]) => ops),
  } as never;

  const jwt = {
    signAsync: jest.fn().mockResolvedValue('access'),
  } as never;

  const config = {
    get: jest.fn((key: string) => {
      if (key === 'GOOGLE_CLIENT_IDS') return 'web-client.apps.googleusercontent.com';
      if (key === 'JWT_ACCESS_TTL') return '15m';
      if (key === 'JWT_REFRESH_TTL') return '30d';
      return undefined;
    }),
    getOrThrow: jest.fn().mockReturnValue('secret-secret-secret-secret-1234'),
  } as never;

  const otp = {} as never;
  let service: AuthService;

  beforeEach(() => {
    jest.resetAllMocks();
    (config as { get: jest.Mock }).get.mockImplementation((key: string) => {
      if (key === 'GOOGLE_CLIENT_IDS') return 'web-client.apps.googleusercontent.com';
      if (key === 'JWT_ACCESS_TTL') return '15m';
      if (key === 'JWT_REFRESH_TTL') return '30d';
      return undefined;
    });
    (config as { getOrThrow: jest.Mock }).getOrThrow.mockReturnValue(
      'secret-secret-secret-secret-1234',
    );
    (jwt as { signAsync: jest.Mock }).signAsync.mockResolvedValue('access');
    (prisma as { $transaction: jest.Mock }).$transaction.mockImplementation(
      async (ops: unknown) => ops,
    );
    (prisma as { refreshToken: { create: jest.Mock } }).refreshToken.create.mockResolvedValue({});
    service = new AuthService(prisma, jwt, config, otp);
  });

  it('rejects production google login without idToken', async () => {
    const prev = process.env.NODE_ENV;
    process.env.NODE_ENV = 'production';
    await expect(
      service.loginWithGoogle({ email: 'a@b.com' }),
    ).rejects.toBeInstanceOf(UnauthorizedException);
    process.env.NODE_ENV = prev;
  });

  it('rejects wrong audience', async () => {
    const prev = process.env.NODE_ENV;
    process.env.NODE_ENV = 'production';
    global.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        email: 'user@gmail.com',
        email_verified: 'true',
        sub: 'sub-1',
        aud: 'other-client.apps.googleusercontent.com',
        iss: 'https://accounts.google.com',
      }),
    }) as unknown as typeof fetch;

    await expect(
      service.loginWithGoogle({ idToken: 'tok' }),
    ).rejects.toThrow(/invalid_google_audience|Unauthorized/);

    process.env.NODE_ENV = prev;
  });

  it('creates user from verified token', async () => {
    process.env.NODE_ENV = 'test';
    global.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        email: 'user@gmail.com',
        email_verified: 'true',
        sub: 'sub-99',
        aud: 'web-client.apps.googleusercontent.com',
        iss: 'https://accounts.google.com',
        name: 'User',
      }),
    }) as unknown as typeof fetch;

    (prisma as { user: { findUnique: jest.Mock } }).user.findUnique
      .mockResolvedValueOnce(null) // by googleSub
      .mockResolvedValueOnce(null); // by email
    (prisma as { user: { create: jest.Mock } }).user.create.mockResolvedValue({
      id: 'u1',
      isProfileComplete: true,
      role: 'user',
      status: 'active',
      deletedAt: null,
    });
    (prisma as { user: { update: jest.Mock } }).user.update.mockResolvedValue({});

    const result = await service.loginWithGoogle({ idToken: 'tok' });
    expect(result.userId).toBe('u1');
    expect(result.accessToken).toBe('access');
    expect(
      (prisma as { user: { create: jest.Mock } }).user.create,
    ).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          googleSub: 'sub-99',
          authProvider: 'google',
          email: 'user@gmail.com',
        }),
      }),
    );
  });
});
