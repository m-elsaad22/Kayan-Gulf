// ============================================================
// KAYAN — Shimmer Loader
// lib/shared/widgets/loaders/shimmer_loader.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_border_radius.dart';

// ── Basic shimmer box ─────────────────────────────────────────
class ShimmerBox extends StatelessWidget {
  final double  width;
  final double  height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:      AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width:        width,
        height:       height,
        decoration:   BoxDecoration(
          color:        AppColors.shimmerBase,
          borderRadius: borderRadius ?? AppBorderRadius.sm,
        ),
      ),
    );
  }
}

// ── Product card skeleton ─────────────────────────────────────
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:      AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color:        AppColors.shimmerBase,
          borderRadius: AppBorderRadius.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.shimmerHighlight,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppBorderRadius.card.topLeft.x),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerLine(double.infinity, 12),
                  const SizedBox(height: 4),
                  _shimmerLine(100, 10),
                  const SizedBox(height: 8),
                  _shimmerLine(80, 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerLine(double w, double h) => Container(
    width:        w, height: h,
    decoration:   BoxDecoration(
      color:        AppColors.shimmerHighlight,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

// ── Banner skeleton ───────────────────────────────────────────
class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:      AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height:     180,
        margin:     const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color:        AppColors.shimmerBase,
          borderRadius: AppBorderRadius.card,
        ),
      ),
    );
  }
}

// ── Category icon skeleton ────────────────────────────────────
class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:      AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color:        AppColors.shimmerBase,
              borderRadius: AppBorderRadius.md,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 48, height: 10,
            decoration: BoxDecoration(
              color:        AppColors.shimmerHighlight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header skeleton ───────────────────────────────────
class SectionHeaderShimmer extends StatelessWidget {
  const SectionHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:      AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Row(
        children: [
          Container(width: 120, height: 16,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase, borderRadius: BorderRadius.circular(4))),
          const Spacer(),
          Container(width: 60, height: 12,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase, borderRadius: BorderRadius.circular(4))),
        ],
      ),
    );
  }
}
