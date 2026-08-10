-- Rukn El Tatawer integration readiness: site links on AppControl + service website mapping

ALTER TABLE "AppControl" ADD COLUMN IF NOT EXISTS "privacyUrl" TEXT NOT NULL DEFAULT 'https://www.rukn-eltatawer.com/privacy';
ALTER TABLE "AppControl" ADD COLUMN IF NOT EXISTS "termsUrl" TEXT NOT NULL DEFAULT 'https://www.rukn-eltatawer.com/terms';
ALTER TABLE "AppControl" ADD COLUMN IF NOT EXISTS "whatsappUrl" TEXT NOT NULL DEFAULT '';
ALTER TABLE "AppControl" ADD COLUMN IF NOT EXISTS "phoneUrl" TEXT NOT NULL DEFAULT '';
ALTER TABLE "AppControl" ADD COLUMN IF NOT EXISTS "appDownloadUrl" TEXT NOT NULL DEFAULT 'https://www.rukn-eltatawer.com/kayan/';

ALTER TABLE "Service" ADD COLUMN IF NOT EXISTS "websiteUrl" TEXT;
ALTER TABLE "Service" ADD COLUMN IF NOT EXISTS "availableCitiesJson" TEXT NOT NULL DEFAULT '[]';

CREATE INDEX IF NOT EXISTS "Service_isAvailable_idx" ON "Service"("isAvailable");
