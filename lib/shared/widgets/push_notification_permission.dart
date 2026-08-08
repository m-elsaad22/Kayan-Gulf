import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../widgets/design/kayan_entry_widgets.dart';

class PushNotificationPermission extends StatelessWidget {
  const PushNotificationPermission({super.key, this.isArabic = false, this.onAllow, this.onDeny});

  final bool isArabic;
  final VoidCallback? onAllow;
  final VoidCallback? onDeny;

  static Future<void> showSheet(
    BuildContext context, {
    bool isArabic = false,
    VoidCallback? onAllow,
    VoidCallback? onDeny,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => PushNotificationPermission(
        isArabic: isArabic,
        onAllow: () {
          Navigator.of(context).pop();
          onAllow?.call();
        },
        onDeny: () {
          Navigator.of(context).pop();
          onDeny?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(gradient: KayanDesignTokens.gradBlue, shape: BoxShape.circle),
            child: const Icon(Icons.notifications_active_rounded, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(isArabic ? 'فعّل الإشعارات' : 'Enable notifications', style: KayanDesignTokens.cairo(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'ابقَ على اطلاع بالعروض والطلبات والرسائل.' : 'Stay updated on deals, orders, and messages.',
            textAlign: TextAlign.center,
            style: KayanDesignTokens.cairo(fontSize: 13, color: KayanDesignTokens.muted),
          ),
          const SizedBox(height: 24),
          KayanCtaButton(label: isArabic ? 'السماح' : 'Allow', variant: KayanCtaVariant.blue, onPressed: onAllow),
          TextButton(onPressed: onDeny, child: Text(isArabic ? 'ليس الآن' : 'Not now', style: KayanDesignTokens.cairo(color: KayanDesignTokens.muted))),
        ],
      ),
    );
  }
}
