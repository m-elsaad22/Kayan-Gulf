// Product card — light design
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/kayan_design_tokens.dart';
import '../../../core/theme/kayan_motion.dart';
import '../../../features/home/data/models/home_models.dart';
import '../loaders/shimmer_loader.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.isHorizontal = false,
    this.showTimer = false,
    this.onTap,
    this.onFavorite,
    this.isFavorited = false,
  });

  final ProductCardModel product;
  final bool isHorizontal;
  final bool showTimer;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorited;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.showTimer && widget.product.flashDealEndsAt != null) {
      _tick();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  void _tick() {
    final end = widget.product.flashDealEndsAt;
    if (end == null) return;
    final now = DateTime.now();
    if (mounted) setState(() => _remaining = end.isAfter(now) ? end.difference(now) : Duration.zero);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return widget.isHorizontal ? _buildHorizontal() : _buildGrid();
  }

  Widget _buildGrid() {
    final p = widget.product;
    final discount = p.discountPercent;

    return GestureDetector(
      onTap: () {
        KayanMotion.hapticLight();
        widget.onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          border: Border.all(color: KayanDesignTokens.border),
          boxShadow: KayanDesignTokens.shadowS,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(KayanDesignTokens.radiusM)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: p.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: p.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const ShimmerBox(width: double.infinity, height: double.infinity),
                            errorWidget: (_, __, ___) => Container(color: KayanDesignTokens.bg, child: const Icon(Icons.image_outlined, color: KayanDesignTokens.muted)),
                          )
                        : Container(color: KayanDesignTokens.bg, child: const Icon(Icons.shopping_bag_outlined, color: KayanDesignTokens.muted, size: 32)),
                  ),
                ),
                if (discount > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: KayanDesignTokens.danger, borderRadius: BorderRadius.circular(6)),
                      child: Text('-${discount.toInt()}%', style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                if (widget.showTimer && _remaining > Duration.zero)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: KayanDesignTokens.oOrange,
                      child: Center(child: Text('⏱ $_timerText', style: KayanDesignTokens.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white))),
                    ),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onFavorite?.call();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                      child: Icon(
                        widget.isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16,
                        color: widget.isFavorited ? KayanDesignTokens.danger : KayanDesignTokens.muted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.nameAr, style: KayanDesignTokens.cairo(fontSize: 12, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  if (p.reviewCount > 0)
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: KayanDesignTokens.oOrange),
                        Text(' ${p.rating.toStringAsFixed(1)}', style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted)),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${p.price.toStringAsFixed(0)} ر.س', style: KayanDesignTokens.cairo(fontSize: 14, fontWeight: FontWeight.w900, color: KayanDesignTokens.oOrange)),
                      if (p.originalPrice != null) ...[
                        const SizedBox(width: 6),
                        Text('${p.originalPrice!.toStringAsFixed(0)}', style: KayanDesignTokens.cairo(fontSize: 11, color: KayanDesignTokens.muted).copyWith(decoration: TextDecoration.lineThrough)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontal() {
    final p = widget.product;
    return GestureDetector(
      onTap: () {
        KayanMotion.hapticLight();
        widget.onTap?.call();
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(KayanDesignTokens.radiusM),
          border: Border.all(color: KayanDesignTokens.border),
          boxShadow: KayanDesignTokens.shadowS,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(KayanDesignTokens.radiusM)),
              child: SizedBox(
                width: 110,
                height: 110,
                child: p.imageUrl != null
                    ? CachedNetworkImage(imageUrl: p.imageUrl!, fit: BoxFit.cover)
                    : Container(color: KayanDesignTokens.bg, child: const Icon(Icons.shopping_bag_outlined)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(p.nameAr, style: KayanDesignTokens.cairo(fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Text('${p.price.toStringAsFixed(0)} ر.س', style: KayanDesignTokens.cairo(fontWeight: FontWeight.w900, color: KayanDesignTokens.oOrange)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
