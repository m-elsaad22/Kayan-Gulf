import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/dynamic_theme.dart';
import '../../../routing/app_routes.dart';
import '../services/design_engine_service.dart';
import '../widgets/super_admin_shell.dart';
import '../widgets/super_admin_widgets.dart';

class ColorControlScreen extends StatefulWidget {
  const ColorControlScreen({super.key});

  @override
  State<ColorControlScreen> createState() => _ColorControlScreenState();
}

class _ColorControlScreenState extends State<ColorControlScreen> {
  late DesignColorPalette _light;
  late DesignColorPalette _dark;
  bool _previewDark = false;
  final _paletteNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = DesignEngineService.instance.settings;
    _light = s.lightColors;
    _dark = s.darkColors;
  }

  @override
  void dispose() {
    _paletteNameCtrl.dispose();
    super.dispose();
  }

  Color _parse(String hex) {
    try {
      return AppColors.fromHex(hex.replaceFirst('#', ''));
    } catch (_) {
      return AppColors.royalBlue;
    }
  }

  Future<void> _pickColor(bool isLight, String field, String current) async {
    Color picked = _parse(current);
    await showDialog<void>(
      context: context,
      builder: (_) => HsvColorPickerDialog(
        initial: picked,
        onChanged: (c) => picked = c,
      ),
    );
    final hex = '#${picked.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    setState(() {
      if (isLight) {
        _light = _updateLightField(_light, field, hex);
      } else {
        _dark = _updateDarkField(_dark, field, hex);
      }
    });
  }

  DesignColorPalette _updateLightField(DesignColorPalette p, String f, String v) {
    switch (f) {
      case 'primary': return p.copyWith(primary: v);
      case 'primaryLight': return p.copyWith(primaryLight: v);
      case 'primaryDark': return p.copyWith(primaryDark: v);
      case 'secondary': return p.copyWith(secondary: v);
      case 'background': return p.copyWith(background: v);
      case 'surface': return p.copyWith(surface: v);
      case 'surfaceVariant': return p.copyWith(surfaceVariant: v);
      case 'error': return p.copyWith(error: v);
      case 'success': return p.copyWith(success: v);
      case 'warning': return p.copyWith(warning: v);
      case 'info': return p.copyWith(info: v);
      case 'gold': return p.copyWith(gold: v);
      case 'turquoise': return p.copyWith(turquoise: v);
      default: return p;
    }
  }

  DesignColorPalette _updateDarkField(DesignColorPalette p, String f, String v) =>
      _updateLightField(p, f, v);

  DesignSettings get _draft => DesignEngineService.instance.settings.copyWith(
        lightColors: _light,
        darkColors: _dark,
      );

  Future<void> _applyNow() async {
    await DesignEngineService.instance.applyNow(_draft, activity: 'تطبيق الألوان فوراً');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تطبيق الألوان على التطبيق')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _previewDark ? _dark : _light;
    final engine = DesignEngineService.instance;

    return SuperAdminShell(
      title: 'التحكم في الألوان الفاخرة',
      currentRoute: AppRoutes.superAdminColors,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Text('معاينة:', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('فاتح'),
                selected: !_previewDark,
                onSelected: (_) => setState(() => _previewDark = false),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('داكن'),
                selected: _previewDark,
                onSelected: (_) => setState(() => _previewDark = true),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _ColorFields(
                  title: 'الوضع الفاتح',
                  palette: _light,
                  onPick: (f, v) => _pickColor(true, f, v),
                  onHex: (f, v) => setState(() => _light = _updateLightField(_light, f, v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _ColorFields(
                  title: 'الوضع الداكن',
                  palette: _dark,
                  onPick: (f, v) => _pickColor(false, f, v),
                  onHex: (f, v) => setState(() => _dark = _updateDarkField(_dark, f, v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: PhoneMockupPreview(
                  palette: palette,
                  isDark: _previewDark,
                  child: Theme(
                    data: _previewDark
                        ? DynamicTheme.dark(_draft)
                        : DynamicTheme.light(_draft),
                    child: Builder(
                      builder: (ctx) => Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'كيان KAYAN',
                              style: Theme.of(ctx).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(onPressed: () {}, child: const Text('زر رئيسي')),
                            const SizedBox(height: 6),
                            OutlinedButton(onPressed: () {}, child: const Text('ثانوي')),
                            const SizedBox(height: 8),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text('بطاقة', style: Theme.of(ctx).textTheme.bodyMedium),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _applyNow,
                icon: const Icon(Icons.bolt),
                label: const Text('تطبيق الألوان الآن'),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  await engine.saveForFuture();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('حُفظت للإصدارات القادمة')),
                    );
                  }
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('حفظ للإصدارات القادمة'),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  await engine.resetToDefaults();
                  setState(() {
                    _light = engine.settings.lightColors;
                    _dark = engine.settings.darkColors;
                  });
                },
                icon: const Icon(Icons.restore),
                label: const Text('إعادة تعيين'),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: engine.exportJson()),
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ JSON')),
                    );
                  }
                },
                icon: const Icon(Icons.upload),
                label: const Text('تصدير JSON'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _paletteNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم اللوحة المفضلة',
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () async {
                  if (_paletteNameCtrl.text.trim().isEmpty) return;
                  await engine.updateSettings(_draft);
                  await engine.savePalette(_paletteNameCtrl.text.trim());
                  _paletteNameCtrl.clear();
                  setState(() {});
                },
                child: const Text('حفظ اللوحة'),
              ),
            ],
          ),
          if (engine.settings.savedPalettes.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('اللوحات المحفوظة', style: TextStyle(fontWeight: FontWeight.w700)),
            ...engine.settings.savedPalettes.map(
              (p) => ListTile(
                title: Text(p.name),
                trailing: IconButton(
                  icon: const Icon(Icons.color_lens),
                  onPressed: () async {
                    await engine.loadPalette(p);
                    setState(() {
                      _light = engine.settings.lightColors;
                      _dark = engine.settings.darkColors;
                    });
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ColorFields extends StatelessWidget {
  final String title;
  final DesignColorPalette palette;
  final void Function(String field, String value) onPick;
  final void Function(String field, String value) onHex;

  const _ColorFields({
    required this.title,
    required this.palette,
    required this.onPick,
    required this.onHex,
  });

  static const _fields = [
    ('primary', 'Primary'),
    ('primaryLight', 'Primary Light'),
    ('primaryDark', 'Primary Dark'),
    ('secondary', 'Secondary'),
    ('background', 'Background'),
    ('surface', 'Surface'),
    ('surfaceVariant', 'Surface Variant'),
    ('error', 'Error'),
    ('success', 'Success'),
    ('warning', 'Warning'),
    ('info', 'Info'),
    ('gold', 'Gold'),
    ('turquoise', 'Turquoise'),
  ];

  String _get(DesignColorPalette p, String f) {
    switch (f) {
      case 'primary': return p.primary;
      case 'primaryLight': return p.primaryLight;
      case 'primaryDark': return p.primaryDark;
      case 'secondary': return p.secondary;
      case 'background': return p.background;
      case 'surface': return p.surface;
      case 'surfaceVariant': return p.surfaceVariant;
      case 'error': return p.error;
      case 'success': return p.success;
      case 'warning': return p.warning;
      case 'info': return p.info;
      case 'gold': return p.gold;
      case 'turquoise': return p.turquoise;
      default: return p.primary;
    }
  }

  Color _c(String hex) {
    try {
      return AppColors.fromHex(hex.replaceFirst('#', ''));
    } catch (_) {
      return AppColors.royalBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.bgCard.withValues(alpha: 0.7),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            ..._fields.map((f) {
              final val = _get(palette, f.$1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => onPick(f.$1, val),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _c(val),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: val,
                        decoration: InputDecoration(
                          labelText: f.$2,
                          isDense: true,
                          filled: true,
                        ),
                        onChanged: (v) => onHex(f.$1, v),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
