import { assertProductionConfig } from './production-guard';

describe('assertProductionConfig', () => {
  const base = {
    NODE_ENV: 'production',
    JWT_ACCESS_SECRET: 'a'.repeat(32),
    DATABASE_URL: 'postgresql://kayan:kayan@db:5432/kayan',
    OTP_PROVIDER: 'unifonic',
    OTP_STRICT: 'true',
    CORS_ORIGINS: 'https://admin.example.com',
    PAYMENT_PROVIDER: 'mock',
    GOOGLE_CLIENT_IDS: '123456789-abc.apps.googleusercontent.com',
  };

  it('allows a valid production config', () => {
    expect(() => assertProductionConfig(base)).not.toThrow();
  });

  it('rejects OTP_PROVIDER=dev', () => {
    expect(() =>
      assertProductionConfig({ ...base, OTP_PROVIDER: 'dev' }),
    ).toThrow(/OTP_PROVIDER/);
  });

  it('rejects sqlite DATABASE_URL', () => {
    expect(() =>
      assertProductionConfig({
        ...base,
        DATABASE_URL: 'file:./dev.db',
      }),
    ).toThrow(/DATABASE_URL/);
  });

  it('rejects empty CORS_ORIGINS', () => {
    expect(() =>
      assertProductionConfig({ ...base, CORS_ORIGINS: '' }),
    ).toThrow(/CORS_ORIGINS/);
  });

  it('rejects tap without secret', () => {
    expect(() =>
      assertProductionConfig({
        ...base,
        PAYMENT_PROVIDER: 'tap',
        PAYMENT_WEBHOOK_SECRET: 'webhook-secret-16+',
      }),
    ).toThrow(/TAP_SECRET_KEY/);
  });

  it('skips checks outside production', () => {
    expect(() =>
      assertProductionConfig({ NODE_ENV: 'development', OTP_PROVIDER: 'dev' }),
    ).not.toThrow();
  });
});
