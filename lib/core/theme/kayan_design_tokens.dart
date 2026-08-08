// Design tokens extracted from design/html/*.html (KAYAN v2 screens)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Light-first palette matching the HTML screen designs.
abstract final class KayanDesignTokens {
  static const Color kBlue = Color(0xFF0B4F9E);
  static const Color kBlueDeep = Color(0xFF062E63);
  static const Color kBlueLight = Color(0xFF3C86D6);
  static const Color kOrange = Color(0xFFE2801F);
  static const Color kOrangeLight = Color(0xFFF4A94D);
  static const Color kGreen = Color(0xFF1FA073);
  static const Color kGreenLight = Color(0xFF4FC79B);
  static const Color gold = Color(0xFFE3B34A);
  static const Color silver = Color(0xFFB9C3D1);
  static const Color bg = Color(0xFFF5F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF132038);
  static const Color text2 = Color(0xFF4C5A72);
  static const Color muted = Color(0xFF8894A6);
  static const Color border = Color(0xFFE4E9F2);
  static const Color danger = Color(0xFFE2541F);
  static const Color success = Color(0xFF1FA073);

  // Delivery / orders section
  static const Color oOrange = Color(0xFFD87220);
  static const Color oOrangeLight = Color(0xFFFF8636);
  static const Color oGreenOpen = Color(0xFF2ECC71);

  static const double radiusS = 14;
  static const double radiusM = 20;
  static const double radiusL = 28;

  static const LinearGradient gradHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E5AB0), kBlue, kBlueDeep],
    stops: [0, 0.55, 1],
  );

  static const LinearGradient gradGold = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gold, Color(0xFFF4CD7E)],
  );

  static const LinearGradient gradBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kBlue, kBlueLight],
  );

  static const LinearGradient gradOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kOrange, kOrangeLight],
  );

  static const LinearGradient gradGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kGreen, kGreenLight],
  );

  static const LinearGradient gradDeliveryOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA8380F), oOrange],
  );

  static const LinearGradient hubServices = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0E7A56), kGreen],
  );

  static const LinearGradient hubShop = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFB5620F), kOrange],
  );

  static const LinearGradient hubClassifieds = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [kBlueDeep, kBlue],
  );

  static const LinearGradient hubOrders = gradDeliveryOrange;

  static const LinearGradient secHeroGreen = hubServices;
  static const LinearGradient secHeroOrange = hubShop;
  static const LinearGradient secHeroBlue = hubClassifieds;
  static const LinearGradient secHeroRedOrange = hubOrders;

  static List<BoxShadow> shadowS = [
    BoxShadow(
      color: kBlueDeep.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowM = [
    BoxShadow(
      color: kBlueDeep.withValues(alpha: 0.14),
      blurRadius: 34,
      offset: const Offset(0, 14),
    ),
  ];

  static TextStyle cairo({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    Color color = text,
    double? height,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// Parse `#RRGGBB` or `RRGGBB` hex strings into a [Color].
  static Color colorFromHex(String hex, {Color fallback = kBlue}) {
    try {
      final buffer = StringBuffer();
      final cleaned = hex.replaceFirst('#', '');
      if (cleaned.length == 6 || cleaned.length == 7) buffer.write('ff');
      buffer.write(cleaned);
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}
