import 'package:flutter/material.dart';

enum DeliveryVendorType { restaurant, grocery, pharmacy, herbs, drinks, electronics }

class DeliveryCategory {
  final String id;
  final String nameAr;
  final String nameEn;
  final IconData icon;

  const DeliveryCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
  });
}

class DeliveryVendor {
  final String id;
  final String slug;
  final String nameAr;
  final String nameEn;
  final DeliveryVendorType type;
  final IconData icon;
  final double rating;
  final String reviewCount;
  final String etaAr;
  final String etaEn;
  final bool isOpen;
  final String deliveryFeeAr;
  final String deliveryFeeEn;
  final List<DeliveryMenuItem> menu;

  const DeliveryVendor({
    required this.id,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    required this.icon,
    required this.rating,
    required this.reviewCount,
    required this.etaAr,
    required this.etaEn,
    required this.isOpen,
    required this.deliveryFeeAr,
    required this.deliveryFeeEn,
    required this.menu,
  });

  String name(bool ar) => ar ? nameAr : nameEn;
  String eta(bool ar) => ar ? etaAr : etaEn;
  String deliveryFee(bool ar) => ar ? deliveryFeeAr : deliveryFeeEn;
}

class DeliveryMenuItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final IconData icon;

  const DeliveryMenuItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.icon,
  });

  String name(bool ar) => ar ? nameAr : nameEn;
  String description(bool ar) => ar ? descriptionAr : descriptionEn;
}

class DeliveryCartLine {
  final DeliveryMenuItem item;
  final DeliveryVendor vendor;
  int quantity;

  DeliveryCartLine({
    required this.item,
    required this.vendor,
    this.quantity = 1,
  });

  double get subtotal => item.price * quantity;
}

class DeliveryOrder {
  final String id;
  final DeliveryVendor vendor;
  final List<DeliveryCartLine> lines;
  final double total;
  final String statusAr;
  final String statusEn;
  final DateTime createdAt;

  const DeliveryOrder({
    required this.id,
    required this.vendor,
    required this.lines,
    required this.total,
    required this.statusAr,
    required this.statusEn,
    required this.createdAt,
  });
}
