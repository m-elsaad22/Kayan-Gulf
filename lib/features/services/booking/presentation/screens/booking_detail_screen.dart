import 'package:flutter/material.dart';

import 'booking_detail_light_screen.dart';

/// تفاصيل الحجز — legacy alias يوجّه إلى [BookingDetailLightScreen] (تصميم خفيف).
class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) => BookingDetailLightScreen(bookingId: bookingId);
}
