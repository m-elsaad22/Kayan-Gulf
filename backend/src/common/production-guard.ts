/**
 * Fail-closed checks when NODE_ENV=production.
 * Prevents shipping with demo OTP, placeholder JWT, open CORS, or SQLite.
 */
export function assertProductionConfig(env: NodeJS.ProcessEnv = process.env): void {
  if ((env.NODE_ENV ?? 'development') !== 'production') {
    return;
  }

  const errors: string[] = [];

  const jwt = env.JWT_ACCESS_SECRET ?? '';
  if (!jwt || jwt.includes('change-me') || jwt.length < 32) {
    errors.push('JWT_ACCESS_SECRET must be a strong secret (≥32 chars, not a placeholder)');
  }

  const db = env.DATABASE_URL ?? '';
  if (!db.startsWith('postgres')) {
    errors.push('DATABASE_URL must be a postgresql:// URL in production');
  }

  const otp = (env.OTP_PROVIDER ?? 'dev').toLowerCase();
  if (otp === 'dev') {
    errors.push('OTP_PROVIDER=dev is forbidden in production (use unifonic|twilio)');
  }
  if ((env.OTP_STRICT ?? 'true').toLowerCase() !== 'true') {
    errors.push('OTP_STRICT must be true in production');
  }

  const cors = (env.CORS_ORIGINS ?? '')
    .split(',')
    .map((o) => o.trim())
    .filter(Boolean);
  if (!cors.length) {
    errors.push('CORS_ORIGINS must list explicit origins in production (admin/web)');
  }

  const payment = (env.PAYMENT_PROVIDER ?? 'mock').toLowerCase();
  if (payment !== 'mock' && payment !== 'cod') {
    if (payment === 'tap' && !env.TAP_SECRET_KEY) {
      errors.push('TAP_SECRET_KEY is required when PAYMENT_PROVIDER=tap');
    }
    if (payment === 'hyperpay' && !env.HYPERPAY_ENTITY_ID) {
      errors.push('HYPERPAY_ENTITY_ID is required when PAYMENT_PROVIDER=hyperpay');
    }
    if (payment === 'paymob' && !env.PAYMOB_API_KEY) {
      errors.push('PAYMOB_API_KEY is required when PAYMENT_PROVIDER=paymob');
    }
    if (!env.PAYMENT_WEBHOOK_SECRET || env.PAYMENT_WEBHOOK_SECRET.length < 16) {
      errors.push('PAYMENT_WEBHOOK_SECRET (≥16 chars) required for non-mock payments');
    }
  }

  if ((env.PAYMENT_ALLOW_CLIENT_CONFIRM ?? '').toLowerCase() === 'true') {
    errors.push('PAYMENT_ALLOW_CLIENT_CONFIRM cannot be true in production');
  }

  if (errors.length) {
    throw new Error(
      `Production config invalid:\n- ${errors.join('\n- ')}\nRefusing to start.`,
    );
  }
}
