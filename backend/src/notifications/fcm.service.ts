import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import * as path from 'path';

type FirebaseAdminApp = {
  messaging: () => {
    sendEachForMulticast: (msg: {
      tokens: string[];
      notification?: { title: string; body: string };
      data?: Record<string, string>;
    }) => Promise<{ successCount: number; failureCount: number }>;
  };
};

/**
 * FCM sender.
 * - If FIREBASE_SERVICE_ACCOUNT_PATH (or FIREBASE_SERVICE_ACCOUNT_JSON) is set,
 *   uses firebase-admin.
 * - Otherwise logs payloads (safe for local/dev).
 */
@Injectable()
export class FcmService implements OnModuleInit {
  private readonly logger = new Logger(FcmService.name);
  private app: FirebaseAdminApp | null = null;
  private mode: 'admin' | 'log' = 'log';

  constructor(private readonly config: ConfigService) {}

  async onModuleInit() {
    const jsonInline = this.config.get<string>('FIREBASE_SERVICE_ACCOUNT_JSON');
    const filePath = this.config.get<string>('FIREBASE_SERVICE_ACCOUNT_PATH');

    if (!jsonInline && !filePath) {
      this.logger.warn(
        'FCM in log mode — set FIREBASE_SERVICE_ACCOUNT_PATH for real push',
      );
      return;
    }

    try {
      // Dynamic import so builds work even if admin isn't used.
      // eslint-disable-next-line @typescript-eslint/no-require-imports
      const admin = require('firebase-admin') as {
        apps: unknown[];
        initializeApp: (opts: { credential: unknown }) => FirebaseAdminApp;
        credential: { cert: (svc: unknown) => unknown };
      };

      let serviceAccount: unknown;
      if (jsonInline) {
        serviceAccount = JSON.parse(jsonInline);
      } else if (filePath) {
        const abs = path.isAbsolute(filePath)
          ? filePath
          : path.join(process.cwd(), filePath);
        serviceAccount = JSON.parse(fs.readFileSync(abs, 'utf8'));
      }

      if (!admin.apps.length) {
        this.app = admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
        });
      } else {
        this.app = admin.apps[0] as FirebaseAdminApp;
      }
      this.mode = 'admin';
      this.logger.log('FCM firebase-admin initialized');
    } catch (err) {
      this.logger.error(
        'Failed to init firebase-admin; falling back to log mode',
        err,
      );
      this.mode = 'log';
    }
  }

  async sendToTokens(
    tokens: string[],
    payload: {
      title: string;
      body: string;
      data?: Record<string, string>;
    },
  ): Promise<{ successCount: number; failureCount: number; mode: string }> {
    const unique = [...new Set(tokens.filter(Boolean))];
    if (unique.length === 0) {
      return { successCount: 0, failureCount: 0, mode: this.mode };
    }

    if (this.mode === 'log' || !this.app) {
      this.logger.log(
        `[FCM log] tokens=${unique.length} title="${payload.title}" body="${payload.body}"`,
      );
      return { successCount: unique.length, failureCount: 0, mode: 'log' };
    }

    const result = await this.app.messaging().sendEachForMulticast({
      tokens: unique,
      notification: { title: payload.title, body: payload.body },
      data: payload.data,
    });
    return {
      successCount: result.successCount,
      failureCount: result.failureCount,
      mode: 'admin',
    };
  }
}
