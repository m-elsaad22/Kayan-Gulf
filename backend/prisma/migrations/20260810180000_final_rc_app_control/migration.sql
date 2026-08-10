-- Final RC: Google identity, user status/roles, AppControl, AuditLog, device fields

ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "avatarUrl" TEXT;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "googleSub" TEXT;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "authProvider" TEXT NOT NULL DEFAULT 'password';
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "status" TEXT NOT NULL DEFAULT 'active';
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "lastLoginAt" TIMESTAMP(3);
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "deletedAt" TIMESTAMP(3);

CREATE UNIQUE INDEX IF NOT EXISTS "User_googleSub_key" ON "User"("googleSub");
CREATE INDEX IF NOT EXISTS "User_status_idx" ON "User"("status");
CREATE INDEX IF NOT EXISTS "User_role_idx" ON "User"("role");

ALTER TABLE "DeviceToken" ADD COLUMN IF NOT EXISTS "appVersion" TEXT;
ALTER TABLE "DeviceToken" ADD COLUMN IF NOT EXISTS "deviceName" TEXT;
ALTER TABLE "DeviceToken" ADD COLUMN IF NOT EXISTS "status" TEXT NOT NULL DEFAULT 'active';
ALTER TABLE "DeviceToken" ADD COLUMN IF NOT EXISTS "lastSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

CREATE INDEX IF NOT EXISTS "DeviceToken_status_idx" ON "DeviceToken"("status");

CREATE TABLE IF NOT EXISTS "AppControl" (
    "id" TEXT NOT NULL DEFAULT 'default',
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "maintenanceMode" BOOLEAN NOT NULL DEFAULT false,
    "messageAr" TEXT NOT NULL DEFAULT 'التطبيق متوقف مؤقتًا.',
    "messageEn" TEXT NOT NULL DEFAULT 'The app is temporarily unavailable.',
    "minVersion" TEXT NOT NULL DEFAULT '1.0.0',
    "latestVersion" TEXT NOT NULL DEFAULT '1.0.0',
    "forceUpdate" BOOLEAN NOT NULL DEFAULT false,
    "supportUrl" TEXT NOT NULL DEFAULT 'https://www.rukn-eltatawer.com/',
    "websiteUrl" TEXT NOT NULL DEFAULT 'https://www.rukn-eltatawer.com/',
    "apkUrl" TEXT,
    "playStoreUrl" TEXT,
    "updatedById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AppControl_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "AuditLog" (
    "id" TEXT NOT NULL,
    "actorId" TEXT,
    "action" TEXT NOT NULL,
    "resource" TEXT NOT NULL,
    "resourceId" TEXT,
    "metaJson" TEXT,
    "ip" TEXT,
    "success" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "AuditLog_action_idx" ON "AuditLog"("action");
CREATE INDEX IF NOT EXISTS "AuditLog_createdAt_idx" ON "AuditLog"("createdAt");
CREATE INDEX IF NOT EXISTS "AuditLog_actorId_idx" ON "AuditLog"("actorId");

DO $$ BEGIN
  ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_actorId_fkey"
    FOREIGN KEY ("actorId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

INSERT INTO "AppControl" (
  "id", "enabled", "maintenanceMode", "messageAr", "messageEn",
  "minVersion", "latestVersion", "forceUpdate", "supportUrl", "websiteUrl", "updatedAt"
)
VALUES (
  'default', true, false,
  'التطبيق يعمل بشكل طبيعي.',
  'The app is running normally.',
  '1.0.0', '1.0.0', false,
  'https://www.rukn-eltatawer.com/',
  'https://www.rukn-eltatawer.com/',
  CURRENT_TIMESTAMP
)
ON CONFLICT ("id") DO NOTHING;
