import 'package:flutter/material.dart';

import 'wallet_light_screen.dart';

/// المحفظة — legacy alias يوجّه إلى [WalletLightScreen] (تصميم خفيف).
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) => const WalletLightScreen();
}
