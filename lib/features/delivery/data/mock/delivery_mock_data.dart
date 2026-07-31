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
