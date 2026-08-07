import 'package:flutter/material.dart';

import '../models/delivery_models.dart';

const deliveryCategories = <DeliveryCategory>[
  DeliveryCategory(id: 'restaurants', nameAr: 'مطاعم', nameEn: 'Restaurants', icon: Icons.lunch_dining_rounded),
  DeliveryCategory(id: 'grocery', nameAr: 'بقالة', nameEn: 'Grocery', icon: Icons.shopping_cart_rounded),
  DeliveryCategory(id: 'pharmacy', nameAr: 'صيدليات', nameEn: 'Pharmacy', icon: Icons.medication_rounded),
  DeliveryCategory(id: 'herbs', nameAr: 'عطارة', nameEn: 'Herbs', icon: Icons.spa_rounded),
  DeliveryCategory(id: 'drinks', nameAr: 'مشروبات', nameEn: 'Drinks', icon: Icons.local_cafe_rounded),
  DeliveryCategory(id: 'electronics', nameAr: 'أجهزة', nameEn: 'Electronics', icon: Icons.devices_rounded),
];

final mockDeliveryVendors = <DeliveryVendor>[
  DeliveryVendor(
    id: '1',
    slug: 'burger-house',
    nameAr: 'برجر هاوس',
    nameEn: 'Burger House',
    type: DeliveryVendorType.restaurant,
    icon: Icons.lunch_dining_rounded,
    rating: 4.6,
    reviewCount: '1.2K',
    etaAr: '25-35 د',
    etaEn: '25-35 min',
    isOpen: true,
    deliveryFeeAr: 'توصيل مجاني',
    deliveryFeeEn: 'Free delivery',
    menu: const [
      DeliveryMenuItem(
        id: 'b1',
        nameAr: 'برجر كلاسيك',
        nameEn: 'Classic Burger',
        descriptionAr: 'لحم بقري، جبنة شيدر، خس، طماطم',
        descriptionEn: 'Beef patty, cheddar, lettuce, tomato',
        price: 32,
        icon: Icons.lunch_dining_rounded,
      ),
      DeliveryMenuItem(
        id: 'b2',
        nameAr: 'برجر دبل',
        nameEn: 'Double Burger',
        descriptionAr: 'طبقتان لحم مع صوص خاص',
        descriptionEn: 'Double patty with house sauce',
        price: 45,
        icon: Icons.lunch_dining_rounded,
      ),
      DeliveryMenuItem(
        id: 'b3',
        nameAr: 'بطاطس مقلية',
        nameEn: 'French Fries',
        descriptionAr: 'بطاطس مقرمشة مع ملح البحر',
        descriptionEn: 'Crispy fries with sea salt',
        price: 12,
        icon: Icons.fastfood_rounded,
      ),
    ],
  ),
  DeliveryVendor(
    id: '2',
    slug: 'pizza-hut',
    nameAr: 'بيتزا هت',
    nameEn: 'Pizza Hut',
    type: DeliveryVendorType.restaurant,
    icon: Icons.local_pizza_rounded,
    rating: 4.5,
    reviewCount: '2.3K',
    etaAr: '20-30 د',
    etaEn: '20-30 min',
    isOpen: true,
    deliveryFeeAr: 'توصيل 5 ر.س',
    deliveryFeeEn: 'SAR 5 delivery',
    menu: const [
      DeliveryMenuItem(
        id: 'p1',
        nameAr: 'بيتزا مارجريتا',
        nameEn: 'Margherita Pizza',
        descriptionAr: 'جبنة موزاريلا وصلصة طماطم',
        descriptionEn: 'Mozzarella and tomato sauce',
        price: 38,
        icon: Icons.local_pizza_rounded,
      ),
      DeliveryMenuItem(
        id: 'p2',
        nameAr: 'بيتزا بيبروني',
        nameEn: 'Pepperoni Pizza',
        descriptionAr: 'بيبروني مدخن وجبنة',
        descriptionEn: 'Smoked pepperoni and cheese',
        price: 42,
        icon: Icons.local_pizza_rounded,
      ),
    ],
  ),
  DeliveryVendor(
    id: '3',
    slug: 'spinneys',
    nameAr: 'سبينس سوبرماركت',
    nameEn: 'Spinneys Supermarket',
    type: DeliveryVendorType.grocery,
    icon: Icons.shopping_basket_rounded,
    rating: 4.7,
    reviewCount: '900',
    etaAr: '30-45 د',
    etaEn: '30-45 min',
    isOpen: true,
    deliveryFeeAr: 'توصيل مجاني',
    deliveryFeeEn: 'Free delivery',
    menu: const [
      DeliveryMenuItem(
        id: 'g1',
        nameAr: 'حليب طازج 1 لتر',
        nameEn: 'Fresh Milk 1L',
        descriptionAr: 'حليب كامل الدسم',
        descriptionEn: 'Full-fat fresh milk',
        price: 8,
        icon: Icons.egg_alt_rounded,
      ),
      DeliveryMenuItem(
        id: 'g2',
        nameAr: 'خبز عربي',
        nameEn: 'Arabic Bread',
        descriptionAr: 'ربطة خبز طازجة',
        descriptionEn: 'Fresh bread bundle',
        price: 4,
        icon: Icons.bakery_dining_rounded,
      ),
    ],
  ),
  DeliveryVendor(
    id: '4',
    slug: 'nahdi',
    nameAr: 'صيدلية النهدي',
    nameEn: 'Nahdi Pharmacy',
    type: DeliveryVendorType.pharmacy,
    icon: Icons.medication_rounded,
    rating: 4.8,
    reviewCount: '650',
    etaAr: '15-25 د',
    etaEn: '15-25 min',
    isOpen: true,
    deliveryFeeAr: 'توصيل 7 ر.س',
    deliveryFeeEn: 'SAR 7 delivery',
    menu: const [
      DeliveryMenuItem(
        id: 'ph1',
        nameAr: 'باراسيتامول 500',
        nameEn: 'Paracetamol 500',
        descriptionAr: 'مسكن للألم والحرارة',
        descriptionEn: 'Pain and fever relief',
        price: 15,
        icon: Icons.medication_liquid_rounded,
      ),
    ],
  ),
];

DeliveryVendor? findDeliveryVendor(String slug) {
  try {
    return mockDeliveryVendors.firstWhere((v) => v.slug == slug);
  } catch (_) {
    return null;
  }
}

final mockDeliveryOrders = <DeliveryOrder>[
  DeliveryOrder(
    id: 'ord-1001',
    vendor: mockDeliveryVendors[0],
    lines: [
      DeliveryCartLine(
        item: mockDeliveryVendors[0].menu[0],
        vendor: mockDeliveryVendors[0],
        quantity: 2,
      ),
      DeliveryCartLine(
        item: mockDeliveryVendors[0].menu[2],
        vendor: mockDeliveryVendors[0],
        quantity: 1,
      ),
    ],
    total: 76,
    statusAr: 'قيد التوصيل',
    statusEn: 'On the way',
    createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
  ),
  DeliveryOrder(
    id: 'ord-1002',
    vendor: mockDeliveryVendors[1],
    lines: [
      DeliveryCartLine(
        item: mockDeliveryVendors[1].menu[0],
        vendor: mockDeliveryVendors[1],
        quantity: 1,
      ),
    ],
    total: 38,
    statusAr: 'تم التسليم',
    statusEn: 'Delivered',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  DeliveryOrder(
    id: 'ord-1003',
    vendor: mockDeliveryVendors[2],
    lines: [
      DeliveryCartLine(
        item: mockDeliveryVendors[2].menu[0],
        vendor: mockDeliveryVendors[2],
        quantity: 3,
      ),
    ],
    total: 24,
    statusAr: 'ملغي',
    statusEn: 'Cancelled',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

class DeliveryCoupon {
  final String code;
  final String titleAr;
  final String titleEn;
  final String discountAr;
  final String discountEn;
  final bool isActive;

  const DeliveryCoupon({
    required this.code,
    required this.titleAr,
    required this.titleEn,
    required this.discountAr,
    required this.discountEn,
    this.isActive = true,
  });
}

const mockDeliveryCoupons = <DeliveryCoupon>[
  DeliveryCoupon(
    code: 'KAYAN30',
    titleAr: 'خصم 30% على أول طلب',
    titleEn: '30% off first order',
    discountAr: '30%',
    discountEn: '30%',
  ),
  DeliveryCoupon(
    code: 'FREE5',
    titleAr: 'توصيل مجاني',
    titleEn: 'Free delivery',
    discountAr: 'مجاني',
    discountEn: 'Free',
  ),
  DeliveryCoupon(
    code: 'BURGER15',
    titleAr: 'خصم 15 ر.س على المطاعم',
    titleEn: 'SAR 15 off restaurants',
    discountAr: '15 ر.س',
    discountEn: 'SAR 15',
  ),
];

final mockDeliveryFavoriteSlugs = ['burger-house', 'pizza-hut', 'nahdi'];
