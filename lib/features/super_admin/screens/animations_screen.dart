import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/dynamic_theme.dart';
import '../../../core/theme/kayan_motion.dart';
import '../../../routing/app_routes.dart';
import '../services/design_engine_service.dart';
import '../widgets/super_admin_shell.dart';

class AnimationsScreen extends StatefulWidget {
  const AnimationsScreen({super.key});

  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen>
    with TickerProviderStateMixin {
  late MotionSettings _motion;
  late AnimationController _demoCtrl;
  int _demoIndex = 0;

  @override
  void initState() {
    super.initState();
    _motion = DesignEngineService.instance.settings.motion;
    _demoCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _motion.transitionDurationMs),
    );
  }

  @override
  void dispose() {
    _demoCtrl.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final next = DesignEngineService.instance.settings.copyWith(motion: _motion);
    await DesignEngineService.instance.applyNow(next, activity: 'تحديث التأثيرات الحركية');
    _demoCtrl.duration = Duration(milliseconds: _motion.transitionDurationMs);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تطبيق الحركة')),
      );
    }
  }

  void _runDemo() {
    KayanMotion.hapticForTap(primary: _motion.hapticFeedback == 'vibrate');
    _demoCtrl.forward(from: 0);
    setState(() => _demoIndex = (_demoIndex + 1) % 5);
  }

  Widget _demoChild(int i) {
    final colors = [
      AppColors.royalBlue,
      AppColors.pepsiBlue,
      AppColors.turquoise,
      AppColors.metallicGold,
      AppColors.skyBlue,
    ];
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colors[i % colors.length],
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }

  Widget _animatedDemo() {
    final curve = DynamicTheme.curveFromName(_motion.curveName);
    final anim = CurvedAnimation(parent: _demoCtrl, curve: curve);

    switch (_motion.transitionType) {
      case 'slide':
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(anim),
          child: _demoChild(_demoIndex),
        );
      case 'scale':
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1).animate(anim),
          child: _demoChild(_demoIndex),
        );
      case 'rotate':
        return RotationTransition(
          turns: Tween<double>(begin: 0.1, end: 0).animate(anim),
          child: _demoChild(_demoIndex),
        );
      case 'hero':
        return Hero(
          tag: 'kayan_motion_demo',
          child: _demoChild(_demoIndex),
        );
      case 'fade':
      default:
        return FadeTransition(opacity: anim, child: _demoChild(_demoIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SuperAdminShell(
      title: 'التأثيرات الحركية السينمائية',
      currentRoute: AppRoutes.superAdminAnimations,
      actions: [IconButton(icon: const Icon(Icons.check), onPressed: _apply)],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.bgCard.withValues(alpha: 0.75),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _motion.transitionType,
                    decoration: const InputDecoration(labelText: 'نوع الانتقال', filled: true),
                    items: MotionSettings.transitionTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _motion = _motion.copyWith(transitionType: v)),
                  ),
                  const SizedBox(height: 12),
                  Text('مدة الانتقال: ${_motion.transitionDurationMs}ms'),
                  Slider(
                    value: _motion.transitionDurationMs.toDouble(),
                    min: 150,
                    max: 800,
                    divisions: 13,
                    label: '${_motion.transitionDurationMs}ms',
                    onChanged: (v) => setState(() {
                      _motion = _motion.copyWith(transitionDurationMs: v.round());
                      _demoCtrl.duration = Duration(milliseconds: v.round());
                    }),
                  ),
                  DropdownButtonFormField<String>(
                    value: _motion.curveName,
                    decoration: const InputDecoration(labelText: 'منحنى الحركة', filled: true),
                    items: MotionSettings.curveNames
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _motion = _motion.copyWith(curveName: v)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _motion.hoverEffect,
                    decoration: const InputDecoration(labelText: 'Hover (ويب)', filled: true),
                    items: MotionSettings.hoverEffects
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _motion = _motion.copyWith(hoverEffect: v)),
                  ),
                  DropdownButtonFormField<String>(
                    value: _motion.hapticFeedback,
                    decoration: const InputDecoration(labelText: 'ردود فعل لمسية', filled: true),
                    items: MotionSettings.hapticModes
                        .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                        .toList(),
                    onChanged: (v) => setState(() => _motion = _motion.copyWith(hapticFeedback: v)),
                  ),
                  DropdownButtonFormField<String>(
                    value: _motion.scrollEffect,
                    decoration: const InputDecoration(labelText: 'تأثير التمرير', filled: true),
                    items: MotionSettings.scrollEffects
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _motion = _motion.copyWith(scrollEffect: v)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('معاينة مباشرة (5 تأثيرات)', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Center(child: _animatedDemo()),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _runDemo,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('تشغيل العرض'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final json = const JsonEncoder.withIndent('  ').convert(_motion.toJson());
              await Clipboard.setData(ClipboardData(text: json));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم نسخ JSON للتأثير')),
                );
              }
            },
            icon: const Icon(Icons.download),
            label: const Text('تحميل التأثير كـ JSON'),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _apply, child: const Text('تطبيق الحركة الآن')),
        ],
      ),
    );
  }
}
