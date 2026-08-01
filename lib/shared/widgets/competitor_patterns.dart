// ============================================================
// KAYAN — Competitor-inspired UI patterns
// NOON · DARI/BYTAK · Open Sooq
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_border_radius.dart';
import '../../core/theme/app_text_styles.dart';

/// NOON-style flash deal strip with live countdown.
class NoonFlashDealStrip extends StatefulWidget {
  final String title;
  final Duration endsIn;
  final VoidCallback? onTap;

  const NoonFlashDealStrip({
    super.key,
    required this.title,
    required this.endsIn,
    this.onTap,
  });

  @override
  State<NoonFlashDealStrip> createState() => _NoonFlashDealStripState();
}

class _NoonFlashDealStripState extends State<NoonFlashDealStrip> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.endsIn;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining = _remaining - const Duration(seconds: 1);
        if (_remaining.isNegative) _remaining = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeText {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF3D00)],
          ),
          borderRadius: AppBorderRadius.card,
        ),
        child: Row(
          children: [
            const Icon(Icons.flash_on_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.title,
                style: AppTextStyles.titleSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '⏱ $_timeText',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// DARI/BYTAK-style verified provider badge row.
class ServiceVerifiedProviderRow extends StatelessWidget {
  final String name;
  final double rating;
  final int jobsDone;
  final bool isVerified;

  const ServiceVerifiedProviderRow({
    super.key,
    required this.name,
    required this.rating,
    required this.jobsDone,
    this.isVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardBg
            : AppColors.lightCardBg,
        borderRadius: AppBorderRadius.card,
        border: Border.all(color: AppColors.turquoise.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.turquoise.withValues(alpha: 0.15),
            child: const Icon(Icons.handyman, color: AppColors.turquoise),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded,
                          color: AppColors.skyBlue, size: 18),
                    ],
                  ],
                ),
                Text(
                  '⭐ $rating · $jobsDone ${jobsDone == 1 ? 'job' : 'jobs'}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.lightSubtext,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Open Sooq-style seller action buttons (call, chat, WhatsApp).
class ClassifiedsSellerActions extends StatelessWidget {
  final VoidCallback? onCall;
  final VoidCallback? onChat;
  final VoidCallback? onWhatsApp;

  const ClassifiedsSellerActions({
    super.key,
    this.onCall,
    this.onChat,
    this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: onCall,
              icon: const Icon(Icons.phone_rounded, size: 18),
              label: const Text('اتصال'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.callBlue,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onChat,
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('محادثة'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.icon(
              onPressed: onWhatsApp,
              icon: const Icon(Icons.chat_rounded, size: 18),
              label: const Text('واتساب'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.whatsappGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// NOON-style checkout step indicator.
class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const CheckoutStepIndicator({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i <= currentStep;
          final done = i < currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: active
                            ? AppColors.pepsiBlue
                            : AppColors.silver.withValues(alpha: 0.4),
                        child: done
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: active ? Colors.white : AppColors.lightSubtext,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: active ? AppColors.lightText : AppColors.lightSubtext,
                          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < labels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      color: i < currentStep
                          ? AppColors.pepsiBlue
                          : AppColors.silver.withValues(alpha: 0.35),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Service booking timeline (DARI pattern).
class ServiceBookingTimeline extends StatelessWidget {
  final List<String> steps;
  final int activeIndex;

  const ServiceBookingTimeline({
    super.key,
    required this.steps,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(steps.length, (i) {
          final active = i == activeIndex;
          final done = i < activeIndex;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    done
                        ? Icons.check_circle_rounded
                        : active
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                    color: done || active
                        ? AppColors.turquoise
                        : AppColors.silver,
                    size: 22,
                  ),
                  if (i < steps.length - 1)
                    Container(
                      width: 2,
                      height: 28,
                      color: done
                          ? AppColors.turquoise
                          : AppColors.silver.withValues(alpha: 0.4),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    steps[i],
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      color: active ? AppColors.lightText : AppColors.lightSubtext,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
