import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routing/app_routes.dart';
import '../services/design_engine_service.dart';
import '../widgets/super_admin_shell.dart';
import '../widgets/super_admin_widgets.dart';

class RadiusShadowScreen extends StatefulWidget {
  const RadiusShadowScreen({super.key});

  @override
  State<RadiusShadowScreen> createState() => _RadiusShadowScreenState();
}

class _RadiusShadowScreenState extends State<RadiusShadowScreen> {
  late RadiusShadowSettings _rs;

  @override
  void initState() {
    super.initState();
    _rs = DesignEngineService.instance.settings.radiusShadows;
  }

  Future<void> _apply() async {
    final next = DesignEngineService.instance.settings.copyWith(radiusShadows: _rs);
    await DesignEngineService.instance.applyNow(next, activity: 'تحديث الزوايا والظلال');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تطبيق الزوايا والظلال')),
      );
    }
  }

  String get _devCode => '''
RadiusShadowSettings(
  primaryButtonRadius: ${_rs.primaryButtonRadius},
  cardRadius: ${_rs.cardRadius},
  glassOpacity: ${_rs.glassOpacity},
  glassBlur: ${_rs.glassBlur},
  neumorphismEnabled: ${_rs.neumorphismEnabled},
)''';

  Widget _slider(String label, double value, double min, double max, void Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(0)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SuperAdminShell(
      title: 'نظام الزوايا والظلال',
      currentRoute: AppRoutes.superAdminRadius,
      actions: [IconButton(icon: const Icon(Icons.check), onPressed: _apply)],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.bgCard.withValues(alpha: 0.75),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _slider('أزرار رئيسية', _rs.primaryButtonRadius, 0, 40, (v) => setState(() => _rs = _rs.copyWith(primaryButtonRadius: v))),
                  _slider('أزرار ثانوية', _rs.secondaryButtonRadius, 0, 30, (v) => setState(() => _rs = _rs.copyWith(secondaryButtonRadius: v))),
                  _slider('بطاقات', _rs.cardRadius, 0, 32, (v) => setState(() => _rs = _rs.copyWith(cardRadius: v))),
                  _slider('حقول إدخال', _rs.inputRadius, 0, 24, (v) => setState(() => _rs = _rs.copyWith(inputRadius: v))),
                  _slider('نوافذ منبثقة', _rs.modalRadius, 0, 48, (v) => setState(() => _rs = _rs.copyWith(modalRadius: v))),
                  _slider('صور', _rs.imageRadius, 0, 28, (v) => setState(() => _rs = _rs.copyWith(imageRadius: v))),
                  _slider('Elevation بطاقات', _rs.cardElevation, 0, 24, (v) => setState(() => _rs = _rs.copyWith(cardElevation: v))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Neumorphism'),
            value: _rs.neumorphismEnabled,
            onChanged: (v) => setState(() => _rs = _rs.copyWith(neumorphismEnabled: v)),
          ),
          SwitchListTile(
            title: const Text('Glassmorphism'),
            value: _rs.glassEnabled,
            onChanged: (v) => setState(() => _rs = _rs.copyWith(glassEnabled: v)),
          ),
          if (_rs.glassEnabled) ...[
            _slider('شفافية الزجاج', _rs.glassOpacity, 0.6, 0.9, (v) => setState(() => _rs = _rs.copyWith(glassOpacity: v))),
            _slider('Blur', _rs.glassBlur, 10, 30, (v) => setState(() => _rs = _rs.copyWith(glassBlur: v))),
            SwitchListTile(
              title: const Text('تدرج زجاجي'),
              value: _rs.glassGradient,
              onChanged: (v) => setState(() => _rs = _rs.copyWith(glassGradient: v)),
            ),
          ],
          const SizedBox(height: 16),
          const Text('معاينة مباشرة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PreviewButton(
                label: 'رئيسي',
                radius: _rs.primaryButtonRadius,
                elevation: _rs.primaryButtonElevation,
                neumorphic: _rs.neumorphismEnabled,
                color: scheme.primary,
              ),
              _PreviewButton(
                label: 'ثانوي',
                radius: _rs.secondaryButtonRadius,
                elevation: _rs.secondaryButtonElevation,
                neumorphic: false,
                color: scheme.secondary,
                outlined: true,
              ),
              _PreviewCard(radius: _rs.cardRadius, elevation: _rs.cardElevation, neumorphic: _rs.neumorphismEnabled),
              _PreviewInput(radius: _rs.inputRadius),
              _PreviewImage(radius: _rs.imageRadius, elevation: _rs.imageElevation),
              _PreviewModal(radius: _rs.modalRadius, elevation: _rs.modalElevation),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => copyDesignCode(context, _devCode),
            icon: const Icon(Icons.code),
            label: const Text('نسخ الكود للمطورين'),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _apply, child: const Text('تطبيق الآن')),
        ],
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  final String label;
  final double radius;
  final double elevation;
  final bool neumorphic;
  final Color color;
  final bool outlined;

  const _PreviewButton({
    required this.label,
    required this.radius,
    required this.elevation,
    required this.neumorphic,
    required this.color,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: neumorphic
            ? [
                BoxShadow(color: AppColors.whiteOp(0.06), blurRadius: 8, offset: const Offset(-2, -2)),
                BoxShadow(color: Colors.black38, blurRadius: 10, offset: const Offset(3, 4)),
              ]
            : null,
      ),
      child: outlined
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
              ),
              onPressed: () {},
              child: Text(label),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: elevation,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
              ),
              onPressed: () {},
              child: Text(label),
            ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final double radius;
  final double elevation;
  final bool neumorphic;
  const _PreviewCard({required this.radius, required this.elevation, required this.neumorphic});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: neumorphic ? 0 : elevation,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(radius),
      color: AppColors.bgCard,
      child: Container(
        width: 120,
        height: 80,
        alignment: Alignment.center,
        decoration: neumorphic
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  BoxShadow(color: AppColors.whiteOp(0.05), blurRadius: 8, offset: const Offset(-2, -2)),
                  BoxShadow(color: Colors.black45, blurRadius: 12, offset: const Offset(3, 5)),
                ],
              )
            : null,
        child: const Text('بطاقة'),
      ),
    );
  }
}

class _PreviewInput extends StatelessWidget {
  final double radius;
  const _PreviewInput({required this.radius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'حقل',
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        ),
      ),
    );
  }
}

class _PreviewImage extends StatelessWidget {
  final double radius;
  final double elevation;
  const _PreviewImage({required this.radius, required this.elevation});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: 80,
          height: 80,
          color: AppColors.royalBlue,
          child: const Icon(Icons.image, color: Colors.white),
        ),
      ),
    );
  }
}

class _PreviewModal extends StatelessWidget {
  final double radius;
  final double elevation;
  const _PreviewModal({required this.radius, required this.elevation});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      color: AppColors.bgModal,
      child: SizedBox(
        width: 140,
        height: 70,
        child: Center(child: Text('نافذة', style: TextStyle(color: Colors.white.withValues(alpha: 0.9)))),
      ),
    );
  }
}
