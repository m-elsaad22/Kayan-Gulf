import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  await prisma.payment.deleteMany();
  await prisma.orderItem.deleteMany();
  await prisma.order.deleteMany();
  await prisma.cartItem.deleteMany();
  await prisma.cart.deleteMany();
  await prisma.address.deleteMany();
  await prisma.deviceToken.deleteMany();
  await prisma.refreshToken.deleteMany();
  await prisma.otpCode.deleteMany();
  await prisma.productImage.deleteMany();
  await prisma.product.deleteMany();
  await prisma.vendor.deleteMany();
  await prisma.category.deleteMany();
  await prisma.banner.deleteMany();
  await prisma.serviceCard.deleteMany();
  await prisma.adCard.deleteMany();
  await prisma.user.deleteMany();

  const passwordHash = await bcrypt.hash('password123', 10);
  const demoUser = await prisma.user.create({
    data: {
      email: 'demo@kayan.app',
      phone: '+966500000001',
      name: 'Demo User',
      passwordHash,
      isProfileComplete: true,
    },
  });

  await prisma.address.create({
    data: {
      userId: demoUser.id,
      label: 'المنزل',
      recipientName: 'Demo User',
      phone: '+966500000001',
      country: 'SA',
      city: 'الرياض',
      district: 'العليا',
      streetLine1: 'طريق الملك فهد',
      streetLine2: 'مبنى كيان',
      isDefault: true,
    },
  });

  await prisma.banner.createMany({
    data: [
      {
        imageUrl:
          'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
        titleAr: 'خصومات تصل إلى ٥٠٪',
        titleEn: 'Up to 50% Off',
        actionRoute: '/shop/flash-deals',
        sortOrder: 0,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800',
        titleAr: 'توصيل سريع في الخليج',
        titleEn: 'Fast Gulf Delivery',
        actionRoute: '/shop',
        sortOrder: 1,
      },
    ],
  });

  const ecommerce = [
    { slug: 'electronics', nameAr: 'إلكترونيات', nameEn: 'Electronics', color: '#4169E1' },
    { slug: 'fashion', nameAr: 'أزياء', nameEn: 'Fashion', color: '#EC4899' },
    { slug: 'home', nameAr: 'المنزل', nameEn: 'Home', color: '#10B981' },
    { slug: 'beauty', nameAr: 'جمال', nameEn: 'Beauty', color: '#F97316' },
    { slug: 'sports', nameAr: 'رياضة', nameEn: 'Sports', color: '#6366F1' },
    { slug: 'toys', nameAr: 'ألعاب', nameEn: 'Toys', color: '#F59E0B' },
    { slug: 'food', nameAr: 'طعام', nameEn: 'Food', color: '#14B8A6' },
    { slug: 'automotive', nameAr: 'سيارات', nameEn: 'Automotive', color: '#64748B' },
  ];

  for (const [i, c] of ecommerce.entries()) {
    await prisma.category.create({
      data: { ...c, kind: 'ecommerce', sortOrder: i },
    });
  }

  const services = [
    { slug: 'plumbing', nameAr: 'سباكة', nameEn: 'Plumbing', color: '#3B82F6' },
    {
      slug: 'electrical',
      nameAr: 'كهرباء',
      nameEn: 'Electrical',
      color: '#F59E0B',
      isEmergency: true,
    },
    { slug: 'ac', nameAr: 'تكييف', nameEn: 'AC', color: '#06B6D4' },
    { slug: 'cleaning', nameAr: 'تنظيف', nameEn: 'Cleaning', color: '#10B981' },
    { slug: 'painting', nameAr: 'دهان', nameEn: 'Painting', color: '#8B5CF6' },
    { slug: 'movers', nameAr: 'نقل عفش', nameEn: 'Movers', color: '#F97316' },
  ];

  for (const [i, c] of services.entries()) {
    await prisma.category.create({
      data: {
        slug: c.slug,
        nameAr: c.nameAr,
        nameEn: c.nameEn,
        color: c.color,
        isEmergency: c.isEmergency ?? false,
        kind: 'service',
        sortOrder: i,
      },
    });
  }

  const vendor = await prisma.vendor.create({
    data: { businessName: 'متجر كيان', slug: 'kayan-store' },
  });

  const electronics = await prisma.category.findUniqueOrThrow({
    where: { slug: 'electronics' },
  });

  const catalog = [
    {
      slug: 'sony-headphones',
      nameAr: 'سماعات سوني',
      nameEn: 'Sony Headphones',
      price: 299,
      compareAtPrice: 599,
      flash: true,
      featured: true,
    },
    {
      slug: 'samsung-phone',
      nameAr: 'جوال سامسونج',
      nameEn: 'Samsung Phone',
      price: 1899,
      compareAtPrice: 2999,
      flash: true,
      featured: true,
    },
    {
      slug: 'apple-laptop',
      nameAr: 'لابتوب آبل',
      nameEn: 'Apple Laptop',
      price: 4999,
      compareAtPrice: 7999,
      flash: true,
      featured: true,
    },
    {
      slug: 'smart-watch',
      nameAr: 'ساعة ذكية',
      nameEn: 'Smart Watch',
      price: 799,
      compareAtPrice: 1299,
      flash: true,
      featured: false,
    },
    {
      slug: 'tablet-pro',
      nameAr: 'تابلت برو',
      nameEn: 'Tablet Pro',
      price: 1299,
      compareAtPrice: 1999,
      flash: false,
      featured: true,
    },
    {
      slug: 'camera-kit',
      nameAr: 'كاميرا',
      nameEn: 'Camera Kit',
      price: 999,
      compareAtPrice: 1599,
      flash: false,
      featured: true,
    },
    {
      slug: 'rec-product-1',
      nameAr: 'مقترح لك 1',
      nameEn: 'Recommended 1',
      price: 120,
      compareAtPrice: null as number | null,
      flash: false,
      featured: false,
    },
    {
      slug: 'rec-product-2',
      nameAr: 'مقترح لك 2',
      nameEn: 'Recommended 2',
      price: 180,
      compareAtPrice: null as number | null,
      flash: false,
      featured: false,
    },
  ];

  for (const [i, item] of catalog.entries()) {
    await prisma.product.create({
      data: {
        slug: item.slug,
        nameAr: item.nameAr,
        nameEn: item.nameEn,
        descriptionAr: `وصف ${item.nameAr} — شحن داخل السعودية والخليج.`,
        descriptionEn: `${item.nameEn} — shipping across KSA and the Gulf.`,
        price: item.price,
        compareAtPrice: item.compareAtPrice,
        stock: 20 + i,
        rating: 4.1 + (i % 5) * 0.15,
        totalRatings: 40 + i * 12,
        isFeatured: item.featured,
        freeShipping: i % 2 === 0,
        deliveryDays: 2 + (i % 3),
        tagsJson: JSON.stringify(['kayan', 'gulf']),
        flashDealEndsAt: item.flash
          ? new Date(Date.now() + (2 + i) * 3600_000)
          : null,
        categoryId: electronics.id,
        vendorId: vendor.id,
        images: {
          create: [
            {
              url: `https://picsum.photos/600/600?random=${100 + i}`,
              isMain: true,
              sortOrder: 0,
            },
            {
              url: `https://picsum.photos/600/600?random=${200 + i}`,
              isMain: false,
              sortOrder: 1,
            },
          ],
        },
      },
    });
  }

  await prisma.serviceCard.createMany({
    data: [
      {
        slug: 'ac-install',
        nameAr: 'تركيب تكييف',
        nameEn: 'AC Installation',
        basePrice: 150,
        imageUrl: 'https://picsum.photos/300/200?random=40',
        rating: 4.5,
        totalBookings: 220,
        categoryNameAr: 'تكييف',
      },
      {
        slug: 'drain-clean',
        nameAr: 'تسليك مجاري',
        nameEn: 'Drain Cleaning',
        basePrice: 80,
        imageUrl: 'https://picsum.photos/300/200?random=41',
        rating: 4.4,
        totalBookings: 180,
        categoryNameAr: 'سباكة',
        isEmergency: true,
      },
      {
        slug: 'house-paint',
        nameAr: 'دهان منزل',
        nameEn: 'House Painting',
        basePrice: 500,
        imageUrl: 'https://picsum.photos/300/200?random=42',
        rating: 4.6,
        totalBookings: 90,
        categoryNameAr: 'دهان',
      },
      {
        slug: 'deep-clean',
        nameAr: 'نظافة شاملة',
        nameEn: 'Deep Cleaning',
        basePrice: 200,
        imageUrl: 'https://picsum.photos/300/200?random=43',
        rating: 4.7,
        totalBookings: 310,
        categoryNameAr: 'تنظيف',
      },
    ],
  });

  await prisma.adCard.createMany({
    data: [
      {
        slug: 'ad-iphone',
        title: 'آيفون ١٥ برو',
        price: 3200,
        thumbnailUrl: 'https://picsum.photos/300/200?random=50',
        city: 'الرياض',
        isBoosted: true,
      },
      {
        slug: 'ad-camry',
        title: 'سيارة كامري',
        price: 45000,
        thumbnailUrl: 'https://picsum.photos/300/200?random=51',
        city: 'جدة',
      },
      {
        slug: 'ad-apartment',
        title: 'شقة للإيجار',
        price: 3500,
        thumbnailUrl: 'https://picsum.photos/300/200?random=52',
        city: 'أبوظبي',
      },
      {
        slug: 'ad-sofa',
        title: 'أريكة جديدة',
        price: 800,
        thumbnailUrl: 'https://picsum.photos/300/200?random=53',
        city: 'دبي',
      },
    ],
  });

  // eslint-disable-next-line no-console
  console.log('Seed complete: demo@kayan.app / password123');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
