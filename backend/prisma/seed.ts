import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  await prisma.payment.deleteMany();
  await prisma.orderItem.deleteMany();
  await prisma.order.deleteMany();
  await prisma.booking.deleteMany();
  await prisma.cartItem.deleteMany();
  await prisma.cart.deleteMany();
  await prisma.address.deleteMany();
  await prisma.deviceToken.deleteMany();
  await prisma.refreshToken.deleteMany();
  await prisma.otpCode.deleteMany();
  await prisma.productImage.deleteMany();
  await prisma.product.deleteMany();
  await prisma.classifiedAd.deleteMany();
  await prisma.service.deleteMany();
  await prisma.vendor.deleteMany();
  await prisma.category.deleteMany();
  await prisma.banner.deleteMany();
  await prisma.user.deleteMany();

  const passwordHash = await bcrypt.hash('password123', 10);
  const adminHash = await bcrypt.hash('kayan@admin', 10);
  const demoUser = await prisma.user.create({
    data: {
      email: 'demo@kayan.app',
      phone: '+966500000001',
      name: 'Demo User',
      passwordHash,
      isProfileComplete: true,
      role: 'user',
    },
  });

  await prisma.user.create({
    data: {
      email: 'admin@kayan.app',
      phone: '+966500000000',
      name: 'KAYAN Admin',
      passwordHash: adminHash,
      isProfileComplete: true,
      role: 'admin',
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
    { slug: 'plumbing', nameAr: 'سباكة', nameEn: 'Plumbing', color: '#3B82F6', emoji: '🔧' },
    {
      slug: 'electrical',
      nameAr: 'كهرباء',
      nameEn: 'Electrical',
      color: '#F59E0B',
      emoji: '⚡',
      isEmergency: true,
    },
    { slug: 'ac', nameAr: 'تكييف', nameEn: 'AC', color: '#06B6D4', emoji: '❄️' },
    { slug: 'cleaning', nameAr: 'تنظيف', nameEn: 'Cleaning', color: '#10B981', emoji: '🧹' },
    { slug: 'painting', nameAr: 'دهان', nameEn: 'Painting', color: '#8B5CF6', emoji: '🎨' },
    { slug: 'movers', nameAr: 'نقل عفش', nameEn: 'Movers', color: '#F97316', emoji: '📦' },
  ];

  for (const [i, c] of services.entries()) {
    await prisma.category.create({
      data: {
        slug: c.slug,
        nameAr: c.nameAr,
        nameEn: c.nameEn,
        color: c.color,
        emoji: c.emoji,
        isEmergency: c.isEmergency ?? false,
        kind: 'service',
        sortOrder: i,
      },
    });
  }

  const classifiedCats = [
    { slug: 'cl-electronics', nameAr: 'إلكترونيات', nameEn: 'Electronics', emoji: '📱' },
    { slug: 'vehicles', nameAr: 'سيارات', nameEn: 'Vehicles', emoji: '🚗' },
    { slug: 'realestate', nameAr: 'عقارات', nameEn: 'Real Estate', emoji: '🏠' },
    { slug: 'furniture', nameAr: 'أثاث', nameEn: 'Furniture', emoji: '🛋️' },
    { slug: 'cl-sports', nameAr: 'رياضة', nameEn: 'Sports', emoji: '⚽' },
    { slug: 'books', nameAr: 'كتب', nameEn: 'Books', emoji: '📚' },
  ];
  for (const [i, c] of classifiedCats.entries()) {
    await prisma.category.create({
      data: {
        slug: c.slug,
        nameAr: c.nameAr,
        nameEn: c.nameEn,
        emoji: c.emoji,
        kind: 'classified',
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

  const acCat = await prisma.category.findUniqueOrThrow({ where: { slug: 'ac' } });
  const plumbingCat = await prisma.category.findUniqueOrThrow({
    where: { slug: 'plumbing' },
  });
  const paintingCat = await prisma.category.findUniqueOrThrow({
    where: { slug: 'painting' },
  });
  const cleaningCat = await prisma.category.findUniqueOrThrow({
    where: { slug: 'cleaning' },
  });

  const serviceSeeds = [
    {
      slug: 'ac-install',
      nameAr: 'تركيب وصيانة تكييف سبليت',
      nameEn: 'Split AC Installation & Service',
      basePrice: 150,
      discountedPrice: 120,
      imageUrl: 'https://picsum.photos/300/200?random=40',
      rating: 4.8,
      totalRatings: 312,
      totalBookings: 1840,
      categoryId: acCat.id,
      estimatedDurationMin: 120,
    },
    {
      slug: 'drain-clean',
      nameAr: 'تسليك مجاري',
      nameEn: 'Drain Cleaning',
      basePrice: 80,
      discountedPrice: null as number | null,
      imageUrl: 'https://picsum.photos/300/200?random=41',
      rating: 4.4,
      totalRatings: 90,
      totalBookings: 180,
      categoryId: plumbingCat.id,
      isEmergency: true,
      estimatedDurationMin: 60,
    },
    {
      slug: 'house-paint',
      nameAr: 'دهان منزل',
      nameEn: 'House Painting',
      basePrice: 500,
      discountedPrice: null as number | null,
      imageUrl: 'https://picsum.photos/300/200?random=42',
      rating: 4.6,
      totalRatings: 64,
      totalBookings: 90,
      categoryId: paintingCat.id,
      estimatedDurationMin: 240,
    },
    {
      slug: 'deep-clean',
      nameAr: 'نظافة شاملة',
      nameEn: 'Deep Cleaning',
      basePrice: 200,
      discountedPrice: null as number | null,
      imageUrl: 'https://picsum.photos/300/200?random=43',
      rating: 4.7,
      totalRatings: 140,
      totalBookings: 310,
      categoryId: cleaningCat.id,
      estimatedDurationMin: 180,
    },
  ];

  for (const s of serviceSeeds) {
    await prisma.service.create({
      data: {
        slug: s.slug,
        nameAr: s.nameAr,
        nameEn: s.nameEn,
        descriptionAr: `خدمة ${s.nameAr} احترافية في السعودية والخليج.`,
        descriptionEn: `Professional ${s.nameEn} across KSA and the Gulf.`,
        basePrice: s.basePrice,
        discountedPrice: s.discountedPrice,
        imageUrl: s.imageUrl,
        galleryUrlsJson: JSON.stringify([
          s.imageUrl,
          `https://picsum.photos/600/400?random=${s.slug.length + 90}`,
        ]),
        rating: s.rating,
        totalRatings: s.totalRatings,
        totalBookings: s.totalBookings,
        isEmergency: s.isEmergency ?? false,
        estimatedDurationMin: s.estimatedDurationMin,
        categoryId: s.categoryId,
        featuresJson: JSON.stringify([
          {
            icon: '✅',
            textAr: 'فنيون معتمدون',
            textEn: 'Certified technicians',
          },
          { icon: '🛡️', textAr: 'ضمان سنة', textEn: '1-year warranty' },
        ]),
        whatToExpectJson: JSON.stringify([
          'سيتواصل الفني قبل الوصول',
          'تنفيذ الخدمة وفحص النتيجة',
        ]),
        faqsJson: JSON.stringify([
          {
            questionAr: 'هل السعر شامل؟',
            questionEn: 'Is price inclusive?',
            answerAr: 'نعم، شامل العمالة.',
            answerEn: 'Yes, labor included.',
          },
        ]),
        isFeatured: true,
      },
    });
  }

  const clElectronics = await prisma.category.findUniqueOrThrow({
    where: { slug: 'cl-electronics' },
  });
  const vehicles = await prisma.category.findUniqueOrThrow({
    where: { slug: 'vehicles' },
  });
  const realestate = await prisma.category.findUniqueOrThrow({
    where: { slug: 'realestate' },
  });
  const furniture = await prisma.category.findUniqueOrThrow({
    where: { slug: 'furniture' },
  });

  const adSeeds = [
    {
      slug: 'iphone-15-pro-max',
      title: 'آيفون 15 برو ماكس 256GB',
      price: 3200,
      city: 'الرياض',
      district: 'حي النخيل',
      categoryId: clElectronics.id,
      isBoosted: true,
      isFeatured: true,
      condition: 'likeNew',
    },
    {
      slug: 'camry-2022',
      title: 'تويوتا كامري 2022',
      price: 95000,
      city: 'جدة',
      district: 'حي الروضة',
      categoryId: vehicles.id,
      isNegotiable: true,
      condition: 'likeNew',
    },
    {
      slug: 'apartment-olaya',
      title: 'شقة للإيجار - حي العليا',
      price: 3500,
      city: 'الرياض',
      district: 'حي العليا',
      categoryId: realestate.id,
      condition: 'newItem',
    },
    {
      slug: 'sofa-new',
      title: 'أريكة جديدة',
      price: 800,
      city: 'دبي',
      district: 'مارينا',
      categoryId: furniture.id,
      condition: 'newItem',
    },
  ];

  for (const [i, a] of adSeeds.entries()) {
    await prisma.classifiedAd.create({
      data: {
        slug: a.slug,
        title: a.title,
        description: `${a.title} — إعلان عبر كيان.`,
        price: a.price,
        city: a.city,
        district: a.district,
        categoryId: a.categoryId,
        condition: a.condition,
        isBoosted: a.isBoosted ?? false,
        isFeatured: a.isFeatured ?? false,
        isNegotiable: a.isNegotiable ?? false,
        imageUrlsJson: JSON.stringify([
          `https://picsum.photos/600/500?random=${50 + i}`,
          `https://picsum.photos/600/500?random=${60 + i}`,
        ]),
        ownerId: demoUser.id,
        status: 'ACTIVE',
        viewCount: 100 + i * 40,
        favoriteCount: 10 + i,
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      },
    });
  }

  const acService = await prisma.service.findUniqueOrThrow({
    where: { slug: 'ac-install' },
  });
  await prisma.booking.create({
    data: {
      bookingNumber: 'BK-5829401',
      userId: demoUser.id,
      serviceId: acService.id,
      price: 120,
      scheduledAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
      status: 'CONFIRMED',
      addressLine: 'حي النخيل، الرياض',
      notes: 'غرفة النوم',
    },
  });

  // eslint-disable-next-line no-console
  console.log('Seed complete:');
  // eslint-disable-next-line no-console
  console.log('  user:  demo@kayan.app / password123');
  // eslint-disable-next-line no-console
  console.log('  admin: admin@kayan.app / kayan@admin');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
