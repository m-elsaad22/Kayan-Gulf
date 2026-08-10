import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { assertProductionConfig } from './common/production-guard';
import helmet from 'helmet';

async function bootstrap() {
  assertProductionConfig();

  const app = await NestFactory.create(AppModule);

  app.use(
    helmet({
      contentSecurityPolicy: false,
      crossOriginResourcePolicy: { policy: 'cross-origin' },
    }),
  );

  app.setGlobalPrefix('v1');
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  const origins = process.env.CORS_ORIGINS?.split(',')
    .map((o) => o.trim())
    .filter(Boolean);
  const isProd = (process.env.NODE_ENV ?? 'development') === 'production';
  app.enableCors({
    // Production: only listed origins. Dev: reflect any origin when unset.
    origin: origins?.length ? origins : isProd ? false : true,
    credentials: true,
  });

  const port = Number(process.env.PORT ?? 3000);
  await app.listen(port);
  // eslint-disable-next-line no-console
  console.log(`KAYAN API listening on http://127.0.0.1:${port}/v1`);
}

void bootstrap();
