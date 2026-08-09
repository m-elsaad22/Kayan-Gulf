-- AlterTable
ALTER TABLE "Category" ADD COLUMN "emoji" TEXT;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE IF EXISTS "ServiceCard";
DROP TABLE IF EXISTS "AdCard";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "Service" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "slug" TEXT NOT NULL,
    "nameAr" TEXT NOT NULL,
    "nameEn" TEXT NOT NULL,
    "descriptionAr" TEXT,
    "descriptionEn" TEXT,
    "basePrice" REAL NOT NULL,
    "discountedPrice" REAL,
    "pricingType" TEXT NOT NULL DEFAULT 'FIXED',
    "currency" TEXT NOT NULL DEFAULT 'SAR',
    "imageUrl" TEXT,
    "galleryUrlsJson" TEXT NOT NULL DEFAULT '[]',
    "rating" REAL NOT NULL DEFAULT 0,
    "totalRatings" INTEGER NOT NULL DEFAULT 0,
    "totalBookings" INTEGER NOT NULL DEFAULT 0,
    "isEmergency" BOOLEAN NOT NULL DEFAULT false,
    "isAvailable" BOOLEAN NOT NULL DEFAULT true,
    "isFeatured" BOOLEAN NOT NULL DEFAULT true,
    "estimatedDurationMin" INTEGER NOT NULL DEFAULT 60,
    "featuresJson" TEXT NOT NULL DEFAULT '[]',
    "whatToExpectJson" TEXT NOT NULL DEFAULT '[]',
    "faqsJson" TEXT NOT NULL DEFAULT '[]',
    "categoryId" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Service_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Booking" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "bookingNumber" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "price" REAL NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'SAR',
    "scheduledAt" DATETIME NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'CONFIRMED',
    "addressLine" TEXT NOT NULL,
    "notes" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Booking_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Booking_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ClassifiedAd" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "slug" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "price" REAL,
    "isFree" BOOLEAN NOT NULL DEFAULT false,
    "isNegotiable" BOOLEAN NOT NULL DEFAULT false,
    "city" TEXT NOT NULL,
    "district" TEXT NOT NULL DEFAULT '',
    "condition" TEXT NOT NULL DEFAULT 'good',
    "imageUrlsJson" TEXT NOT NULL DEFAULT '[]',
    "viewCount" INTEGER NOT NULL DEFAULT 0,
    "favoriteCount" INTEGER NOT NULL DEFAULT 0,
    "isBoosted" BOOLEAN NOT NULL DEFAULT false,
    "isFeatured" BOOLEAN NOT NULL DEFAULT false,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "expiresAt" DATETIME,
    "categoryId" TEXT,
    "ownerId" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "ClassifiedAd_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "ClassifiedAd_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Service_slug_key" ON "Service"("slug");
CREATE INDEX "Service_categoryId_idx" ON "Service"("categoryId");
CREATE INDEX "Service_isFeatured_idx" ON "Service"("isFeatured");
CREATE UNIQUE INDEX "Booking_bookingNumber_key" ON "Booking"("bookingNumber");
CREATE INDEX "Booking_userId_idx" ON "Booking"("userId");
CREATE INDEX "Booking_status_idx" ON "Booking"("status");
CREATE UNIQUE INDEX "ClassifiedAd_slug_key" ON "ClassifiedAd"("slug");
CREATE INDEX "ClassifiedAd_categoryId_idx" ON "ClassifiedAd"("categoryId");
CREATE INDEX "ClassifiedAd_ownerId_idx" ON "ClassifiedAd"("ownerId");
CREATE INDEX "ClassifiedAd_status_idx" ON "ClassifiedAd"("status");
CREATE INDEX "ClassifiedAd_isFeatured_idx" ON "ClassifiedAd"("isFeatured");
