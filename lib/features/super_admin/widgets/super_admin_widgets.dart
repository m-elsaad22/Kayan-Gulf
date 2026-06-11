import 'dart:math' as math;
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/dynamic_theme.dart';
import '../../../core/theme/kayan_motion.dart';
import '../services/design_engine_service.dart';

class AnimatedStatCard extends StatefulWidget {
  final String label;
  final int value;
  final IconData icon;
  final List<double> sparkline;
  final Gradient iconGradient;

  const AnimatedStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.sparkline,
    this.iconGradient = AppGradients.primaryButton,
  });

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard> {
  @override
  Widget build(BuildContext context) {
    final ext = KayanDesignExtension.of(context);
    final rs = ext.radiusShadows;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(rs.cardRadius),
        border: Border.all(color: AppColors.whiteOp(0.1)),
        boxShadow: rs.neumorphismEnabled
            ? [
                BoxShadow(
                  color: AppColors.whiteOp(0.05),
                  blurRadius: 12,
                  offset: const Offset(-3, -3),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(4, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: rs.cardElevation * 2,
                  offset: Offset(0, rs.cardElevation / 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: widget.iconGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.skyBlue.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(widget.icon, color: Colors.white, size: 22),
          ),
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: widget.value.toDouble()),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => Text(
              v.toInt().toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(widget.label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < widget.sparkline.length; i++)
                        FlSpot(i.toDouble(), widget.sparkline[i]),
                    ],
                    isCurved: true,
                    color: AppColors.metallicGold,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.metallicGold.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentActivityList extends StatelessWidget {
  final List<DesignActivity> activities;

  const RecentActivityList({super.key, required this.activities});

  IconData _icon(String name) {
    switch (name) {
      case 'inventory':
        return Icons.inventory_2_outlined;
      case 'handyman':
        return Icons.handyman_outlined;
      case 'campaign':
        return Icons.campaign_outlined;
      case 'palette':
        return Icons.palette_outlined;
      case 'person_add':
        return Icons.person_add_outlined;
      default:
        return Icons.edit_outlined;
    }
  }

  String _timeAgo(DateTime at) {
    final diff = DateTime.now().difference(at);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    return 'منذ ${diff.inDays} ي';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteOp(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.whiteOp(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أحدث النشاطات',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...activities.take(5).map(
                    (a) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.royalBlue.withValues(alpha: 0.25),
                        child: Icon(_icon(a.icon), size: 18, color: AppColors.skyBlue),
                      ),
                      title: Text(a.titleAr, style: const TextStyle(fontSize: 13)),
                      trailing: Text(
                        _timeAgo(a.at),
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneMockupPreview extends StatelessWidget {
  final Widget child;
  final DesignColorPalette palette;
  final bool isDark;

  const PhoneMockupPreview({
    super.key,
    required this.child,
    required this.palette,
    this.isDark = false,
  });

  Color _c(String hex) {
    try {
      return AppColors.fromHex(hex.replaceFirst('#', ''));
    } catch (_) {
      return AppColors.royalBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade800,
            Colors.grey.shade900,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: _c(palette.background),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.black54, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              height: 28,
              color: _c(palette.surface),
              alignment: Alignment.center,
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class HsvColorPickerDialog extends StatefulWidget {
  final Color initial;
  final ValueChanged<Color> onChanged;

  const HsvColorPickerDialog({
    super.key,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<HsvColorPickerDialog> createState() => _HsvColorPickerDialogState();
}

class _HsvColorPickerDialogState extends State<HsvColorPickerDialog> {
  late HSVColor _hsv;
  late TextEditingController _hexCtrl;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initial);
    _hexCtrl = TextEditingController(text: _toHex(widget.initial));
  }

  @override
  void dispose() {
    _hexCtrl.dispose();
    super.dispose();
  }

  String _toHex(Color c) =>
      '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  void _update(Color c) {
    setState(() {
      _hsv = HSVColor.fromColor(c);
      _hexCtrl.text = _toHex(c);
    });
    widget.onChanged(c);
  }

  @override
  Widget build(BuildContext context) {
    final color = _hsv.toColor();
    return AlertDialog(
      title: const Text('اختيار اللون'),
      content: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onPanUpdate: (d) {
                final box = context.findRenderObject() as RenderBox?;
                if (box == null) return;
              },
              child: _ColorWheel(
                hue: _hsv.hue,
                saturation: _hsv.saturation,
                value: _hsv.value,
                onChanged: (h, s, v) {
                  _update(HSVColor.fromAHSV(1, h, s, v).toColor());
                },
              ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _hsv.value,
              onChanged: (v) => _update(_hsv.withValue(v).toColor()),
            ),
            TextField(
              controller: _hexCtrl,
              decoration: const InputDecoration(labelText: 'HEX'),
              onSubmitted: (v) {
                try {
                  final c = AppColors.fromHex(v.replaceFirst('#', ''));
                  _update(c);
                } catch (_) {}
              },
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('تم')),
      ],
    );
  }
}

class _ColorWheel extends StatelessWidget {
  final double hue;
  final double saturation;
  final double value;
  final void Function(double h, double s, double v) onChanged;

  const _ColorWheel({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (d) => _handle(d.localPosition, context),
      onPanUpdate: (d) => _handle(d.localPosition, context),
      child: CustomPaint(
        size: const Size(200, 200),
        painter: _WheelPainter(hue: hue, saturation: saturation, value: value),
      ),
    );
  }

  void _handle(Offset local, BuildContext context) {
    const size = 200.0;
    final center = const Offset(size / 2, size / 2);
    final delta = local - center;
    final dist = delta.distance.clamp(0.0, size / 2);
    final angle = math.atan2(delta.dy, delta.dx);
    final h = (angle * 180 / math.pi + 360) % 360;
    final s = (dist / (size / 2)).clamp(0.0, 1.0);
    onChanged(h, s, value);
  }
}

class _WheelPainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double value;

  _WheelPainter({required this.hue, required this.saturation, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    for (var i = 0; i < 360; i++) {
      final paint = Paint()
        ..shader = SweepGradient(
          colors: [
            for (var h = 0.0; h <= 360; h += 30)
              HSVColor.fromAHSV(1, h, 1, value).toColor(),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }
    final selAngle = hue * math.pi / 180;
    final selR = saturation * radius;
    final sel = center + Offset(math.cos(selAngle) * selR, math.sin(selAngle) * selR);
    canvas.drawCircle(
      sel,
      8,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.hue != hue || old.saturation != saturation || old.value != value;
}

Future<void> copyDesignCode(BuildContext context, String code) async {
  await Clipboard.setData(ClipboardData(text: code));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ الكود')),
    );
  }
  KayanMotion.hapticLight();
}
