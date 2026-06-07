import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PushNotificationPermission extends StatelessWidget {
  final bool isArabic;
  final VoidCallback? onAllow;
  final VoidCallback? onDeny;

  const PushNotificationPermission({
    super.key,
    this.isArabic = false,
    this.onAllow,
    this.onDeny,
  });

  static Future<void> showSheet(
    BuildContext context, {
    bool isArabic = false,
    VoidCallback? onAllow,
    VoidCallback? onDeny,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
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
          const Icon(
            Icons.notifications_active_rounded,
            size: 56,
            color: AppColors.royalBlue,
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'فعّل الإشعارات' : 'Enable Notifications',
            style: isArabic
                ? AppTextStyles.arabicTitleMedium
                : AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'ابقَ على اطلاع بالعروض والطلبات والرسائل.'
                : 'Stay updated on deals, orders, and messages.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onAllow,
              child: Text(isArabic ? 'السماح' : 'Allow'),
            ),
          ),
          TextButton(
            onPressed: onDeny,
            child: Text(isArabic ? 'ليس الآن' : 'Not Now'),
          ),
        ],
      ),
    );
  }
}
