// Competitor-inspired UI patterns — light design
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/kayan_design_tokens.dart';

/// NOON-style flash deal strip with live countdown.
class NoonFlashDealStrip extends StatefulWidget {
  const NoonFlashDealStrip({super.key, required this.title, required this.endsIn, this.onTap});

  final String title;
  final Duration endsIn;
  final VoidCallback? onTap;

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
          gradient: KayanDesignTokens.gradOrange,
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        ),
        child: Row(
          children: [
            const Icon(Icons.flash_on_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(widget.title, style: KayanDesignTokens.cairo(color: Colors.white, fontWeight: FontWeight.w800))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
              child: Text('⏱ $_timeText', style: KayanDesignTokens.cairo(color: Colors.white, fontWeight: FontWeight.w800).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceVerifiedProviderRow extends StatelessWidget {
  const ServiceVerifiedProviderRow({
    super.key,
    required this.name,
    required this.rating,
    required this.jobsDone,
    this.isVerified = true,
  });

  final String name;
  final double rating;
  final int jobsDone;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
        border: Border.all(color: KayanDesignTokens.kGreen.withValues(alpha: 0.35)),
        boxShadow: KayanDesignTokens.shadowS,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: KayanDesignTokens.kGreen.withValues(alpha: 0.12),
            child: const Icon(Icons.handyman, color: KayanDesignTokens.kGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(name, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800))),
                    if (isVerified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded, color: KayanDesignTokens.kBlue, size: 18),
                    ],
                  ],
                ),
                Text('⭐ $rating · $jobsDone ${jobsDone == 1 ? 'job' : 'jobs'}', style: KayanDesignTokens.cairo(fontSize: 12, color: KayanDesignTokens.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClassifiedsSellerActions extends StatelessWidget {
  const ClassifiedsSellerActions({super.key, this.onCall, this.onChat, this.onWhatsApp});

  final VoidCallback? onCall;
  final VoidCallback? onChat;
  final VoidCallback? onWhatsApp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: FilledButton.icon(onPressed: onCall, icon: const Icon(Icons.phone_rounded, size: 18), label: const Text('اتصال'), style: FilledButton.styleFrom(backgroundColor: KayanDesignTokens.kBlue))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton.icon(onPressed: onChat, icon: const Icon(Icons.chat_bubble_outline, size: 18), label: const Text('محادثة'))),
          const SizedBox(width: 8),
          Expanded(child: FilledButton.icon(onPressed: onWhatsApp, icon: const Icon(Icons.chat_rounded, size: 18), label: const Text('واتساب'), style: FilledButton.styleFrom(backgroundColor: KayanDesignTokens.kGreen))),
        ],
      ),
    );
  }
}

class CheckoutStepIndicator extends StatelessWidget {
  const CheckoutStepIndicator({super.key, required this.currentStep, required this.labels});

  final int currentStep;
  final List<String> labels;

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
                        backgroundColor: active ? KayanDesignTokens.kBlue : KayanDesignTokens.muted.withValues(alpha: 0.3),
                        child: done
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : Text('${i + 1}', style: KayanDesignTokens.cairo(color: active ? Colors.white : KayanDesignTokens.muted, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 4),
                      Text(labels[i], maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w400, color: active ? KayanDesignTokens.text2 : KayanDesignTokens.muted)),
                    ],
                  ),
                ),
                if (i < labels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      color: i < currentStep ? KayanDesignTokens.kBlue : KayanDesignTokens.muted.withValues(alpha: 0.25),
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

class ServiceBookingTimeline extends StatelessWidget {
  const ServiceBookingTimeline({super.key, required this.steps, required this.activeIndex});

  final List<String> steps;
  final int activeIndex;

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
                  Icon(done ? Icons.check_circle_rounded : active ? Icons.radio_button_checked : Icons.radio_button_off, color: done || active ? KayanDesignTokens.kGreen : KayanDesignTokens.muted, size: 22),
                  if (i < steps.length - 1)
                    Container(width: 2, height: 28, color: done ? KayanDesignTokens.kGreen : KayanDesignTokens.muted.withValues(alpha: 0.3)),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(steps[i], style: KayanDesignTokens.cairo(fontWeight: active ? FontWeight.w800 : FontWeight.w400, color: active ? KayanDesignTokens.text2 : KayanDesignTokens.muted)),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
