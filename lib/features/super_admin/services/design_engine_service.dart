// ============================================================
// KAYAN — Luxury Design Engine (Super Admin)
// Persists identity settings via SharedPreferences
// ============================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'kayan_design_engine_v1';
const _savedFutureKey = 'kayan_design_engine_saved_future_v1';

/// Semantic color palette for one brightness mode.
class DesignColorPalette {
  final String primary;
  final String primaryLight;
  final String primaryDark;
  final String secondary;
  final String background;
  final String surface;
  final String surfaceVariant;
  final String error;
  final String success;
  final String warning;
  final String info;
  final String gold;
  final String turquoise;

  const DesignColorPalette({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.gold,
    required this.turquoise,
  });

  static const DesignColorPalette lightDefaults = DesignColorPalette(
    primary: '#0A2B5E',
    primaryLight: '#1E4D8C',
    primaryDark: '#061B3D',
    secondary: '#0033A0',
    background: '#F8FAFC',
    surface: '#FFFFFF',
    surfaceVariant: '#F1F5F9',
    error: '#DC3545',
    success: '#10B981',
    warning: '#F59E0B',
    info: '#3B82F6',
    gold: '#F4D03F',
    turquoise: '#00A8A8',
  );

  static const DesignColorPalette darkDefaults = DesignColorPalette(
    primary: '#00B4D8',
    primaryLight: '#0096C7',
    primaryDark: '#0077B6',
    secondary: '#00A8A8',
    background: '#0A2B5E',
    surface: '#1A2A3A',
    surfaceVariant: '#243B55',
    error: '#FF6B6B',
    success: '#34D399',
    warning: '#FBBF24',
    info: '#60A5FA',
    gold: '#F9E547',
    turquoise: '#2DD4BF',
  );

  DesignColorPalette copyWith({
    String? primary,
    String? primaryLight,
    String? primaryDark,
    String? secondary,
    String? background,
    String? surface,
    String? surfaceVariant,
    String? error,
    String? success,
    String? warning,
    String? info,
    String? gold,
    String? turquoise,
  }) =>
      DesignColorPalette(
        primary: primary ?? this.primary,
        primaryLight: primaryLight ?? this.primaryLight,
        primaryDark: primaryDark ?? this.primaryDark,
        secondary: secondary ?? this.secondary,
        background: background ?? this.background,
        surface: surface ?? this.surface,
        surfaceVariant: surfaceVariant ?? this.surfaceVariant,
        error: error ?? this.error,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        info: info ?? this.info,
        gold: gold ?? this.gold,
        turquoise: turquoise ?? this.turquoise,
      );

  Map<String, dynamic> toJson() => {
        'primary': primary,
        'primaryLight': primaryLight,
        'primaryDark': primaryDark,
        'secondary': secondary,
        'background': background,
        'surface': surface,
        'surfaceVariant': surfaceVariant,
        'error': error,
        'success': success,
        'warning': warning,
        'info': info,
        'gold': gold,
        'turquoise': turquoise,
      };

  factory DesignColorPalette.fromJson(Map<String, dynamic> j) =>
      DesignColorPalette(
        primary: j['primary'] as String? ?? lightDefaults.primary,
        primaryLight: j['primaryLight'] as String? ?? lightDefaults.primaryLight,
        primaryDark: j['primaryDark'] as String? ?? lightDefaults.primaryDark,
        secondary: j['secondary'] as String? ?? lightDefaults.secondary,
        background: j['background'] as String? ?? lightDefaults.background,
        surface: j['surface'] as String? ?? lightDefaults.surface,
        surfaceVariant: j['surfaceVariant'] as String? ?? lightDefaults.surfaceVariant,
        error: j['error'] as String? ?? lightDefaults.error,
        success: j['success'] as String? ?? lightDefaults.success,
        warning: j['warning'] as String? ?? lightDefaults.warning,
        info: j['info'] as String? ?? lightDefaults.info,
        gold: j['gold'] as String? ?? lightDefaults.gold,
        turquoise: j['turquoise'] as String? ?? lightDefaults.turquoise,
      );
}

/// Typography size range for one text level.
class TypographyLevel {
  final double lightMin;
  final double lightMax;
  final double darkMin;
  final double darkMax;

  const TypographyLevel({
    required this.lightMin,
    required this.lightMax,
    required this.darkMin,
    required this.darkMax,
  });

  double sizeFor(bool isDark) {
    final min = isDark ? darkMin : lightMin;
    final max = isDark ? darkMax : lightMax;
    return (min + max) / 2;
  }

  Map<String, dynamic> toJson() => {
        'lightMin': lightMin,
        'lightMax': lightMax,
        'darkMin': darkMin,
        'darkMax': darkMax,
      };

  factory TypographyLevel.fromJson(Map<String, dynamic> j, TypographyLevel fallback) =>
      TypographyLevel(
        lightMin: (j['lightMin'] as num?)?.toDouble() ?? fallback.lightMin,
        lightMax: (j['lightMax'] as num?)?.toDouble() ?? fallback.lightMax,
        darkMin: (j['darkMin'] as num?)?.toDouble() ?? fallback.darkMin,
        darkMax: (j['darkMax'] as num?)?.toDouble() ?? fallback.darkMax,
      );

  TypographyLevel copyWith({
    double? lightMin,
    double? lightMax,
    double? darkMin,
    double? darkMax,
  }) =>
      TypographyLevel(
        lightMin: lightMin ?? this.lightMin,
        lightMax: lightMax ?? this.lightMax,
        darkMin: darkMin ?? this.darkMin,
        darkMax: darkMax ?? this.darkMax,
      );
}

class TypographySettings {
  final String arabicFont;
  final String englishFont;
  final TypographyLevel displayLarge;
  final TypographyLevel displayMedium;
  final TypographyLevel headlineLarge;
  final TypographyLevel headlineMedium;
  final TypographyLevel titleLarge;
  final TypographyLevel bodyLarge;
  final TypographyLevel bodyMedium;
  final TypographyLevel labelLarge;

  const TypographySettings({
    this.arabicFont = 'Cairo',
    this.englishFont = 'Poppins',
    this.displayLarge = const TypographyLevel(lightMin: 48, lightMax: 96, darkMin: 44, darkMax: 88),
    this.displayMedium = const TypographyLevel(lightMin: 36, lightMax: 60, darkMin: 32, darkMax: 56),
    this.headlineLarge = const TypographyLevel(lightMin: 28, lightMax: 40, darkMin: 26, darkMax: 38),
    this.headlineMedium = const TypographyLevel(lightMin: 22, lightMax: 32, darkMin: 20, darkMax: 30),
    this.titleLarge = const TypographyLevel(lightMin: 18, lightMax: 24, darkMin: 18, darkMax: 24),
    this.bodyLarge = const TypographyLevel(lightMin: 16, lightMax: 20, darkMin: 16, darkMax: 20),
    this.bodyMedium = const TypographyLevel(lightMin: 14, lightMax: 16, darkMin: 14, darkMax: 16),
    this.labelLarge = const TypographyLevel(lightMin: 12, lightMax: 14, darkMin: 12, darkMax: 14),
  });

  static const arabicFonts = ['Cairo', 'Tajawal', 'Almarai', 'Noto Kufi Arabic'];
  static const englishFonts = ['Poppins', 'Inter', 'Roboto', 'Lato'];

  static const Set<String> arabicSupportedFonts = {
    'Cairo',
    'Tajawal',
    'Almarai',
    'Noto Kufi Arabic',
  };

  TypographySettings copyWith({
    String? arabicFont,
    String? englishFont,
    TypographyLevel? displayLarge,
    TypographyLevel? displayMedium,
    TypographyLevel? headlineLarge,
    TypographyLevel? headlineMedium,
    TypographyLevel? titleLarge,
    TypographyLevel? bodyLarge,
    TypographyLevel? bodyMedium,
    TypographyLevel? labelLarge,
  }) =>
      TypographySettings(
        arabicFont: arabicFont ?? this.arabicFont,
        englishFont: englishFont ?? this.englishFont,
        displayLarge: displayLarge ?? this.displayLarge,
        displayMedium: displayMedium ?? this.displayMedium,
        headlineLarge: headlineLarge ?? this.headlineLarge,
        headlineMedium: headlineMedium ?? this.headlineMedium,
        titleLarge: titleLarge ?? this.titleLarge,
        bodyLarge: bodyLarge ?? this.bodyLarge,
        bodyMedium: bodyMedium ?? this.bodyMedium,
        labelLarge: labelLarge ?? this.labelLarge,
      );

  Map<String, dynamic> toJson() => {
        'arabicFont': arabicFont,
        'englishFont': englishFont,
        'displayLarge': displayLarge.toJson(),
        'displayMedium': displayMedium.toJson(),
        'headlineLarge': headlineLarge.toJson(),
        'headlineMedium': headlineMedium.toJson(),
        'titleLarge': titleLarge.toJson(),
        'bodyLarge': bodyLarge.toJson(),
        'bodyMedium': bodyMedium.toJson(),
        'labelLarge': labelLarge.toJson(),
      };

  factory TypographySettings.fromJson(Map<String, dynamic>? j) {
    const d = TypographySettings();
    if (j == null) return d;
    return TypographySettings(
      arabicFont: j['arabicFont'] as String? ?? d.arabicFont,
      englishFont: j['englishFont'] as String? ?? d.englishFont,
      displayLarge: TypographyLevel.fromJson(
          j['displayLarge'] as Map<String, dynamic>? ?? {}, d.displayLarge),
      displayMedium: TypographyLevel.fromJson(
          j['displayMedium'] as Map<String, dynamic>? ?? {}, d.displayMedium),
      headlineLarge: TypographyLevel.fromJson(
          j['headlineLarge'] as Map<String, dynamic>? ?? {}, d.headlineLarge),
      headlineMedium: TypographyLevel.fromJson(
          j['headlineMedium'] as Map<String, dynamic>? ?? {}, d.headlineMedium),
      titleLarge: TypographyLevel.fromJson(
          j['titleLarge'] as Map<String, dynamic>? ?? {}, d.titleLarge),
      bodyLarge: TypographyLevel.fromJson(
          j['bodyLarge'] as Map<String, dynamic>? ?? {}, d.bodyLarge),
      bodyMedium: TypographyLevel.fromJson(
          j['bodyMedium'] as Map<String, dynamic>? ?? {}, d.bodyMedium),
      labelLarge: TypographyLevel.fromJson(
          j['labelLarge'] as Map<String, dynamic>? ?? {}, d.labelLarge),
    );
  }
}

class RadiusShadowSettings {
  final double primaryButtonRadius;
  final double secondaryButtonRadius;
  final double cardRadius;
  final double inputRadius;
  final double modalRadius;
  final double imageRadius;
  final double primaryButtonElevation;
  final double secondaryButtonElevation;
  final double cardElevation;
  final double modalElevation;
  final double imageElevation;
  final bool neumorphismEnabled;
  final bool glassEnabled;
  final double glassOpacity;
  final double glassBlur;
  final bool glassGradient;

  const RadiusShadowSettings({
    this.primaryButtonRadius = 12,
    this.secondaryButtonRadius = 10,
    this.cardRadius = 16,
    this.inputRadius = 12,
    this.modalRadius = 24,
    this.imageRadius = 12,
    this.primaryButtonElevation = 4,
    this.secondaryButtonElevation = 2,
    this.cardElevation = 6,
    this.modalElevation = 20,
    this.imageElevation = 8,
    this.neumorphismEnabled = true,
    this.glassEnabled = true,
    this.glassOpacity = 0.75,
    this.glassBlur = 18,
    this.glassGradient = true,
  });

  RadiusShadowSettings copyWith({
    double? primaryButtonRadius,
    double? secondaryButtonRadius,
    double? cardRadius,
    double? inputRadius,
    double? modalRadius,
    double? imageRadius,
    double? primaryButtonElevation,
    double? secondaryButtonElevation,
    double? cardElevation,
    double? modalElevation,
    double? imageElevation,
    bool? neumorphismEnabled,
    bool? glassEnabled,
    double? glassOpacity,
    double? glassBlur,
    bool? glassGradient,
  }) =>
      RadiusShadowSettings(
        primaryButtonRadius: primaryButtonRadius ?? this.primaryButtonRadius,
        secondaryButtonRadius: secondaryButtonRadius ?? this.secondaryButtonRadius,
        cardRadius: cardRadius ?? this.cardRadius,
        inputRadius: inputRadius ?? this.inputRadius,
        modalRadius: modalRadius ?? this.modalRadius,
        imageRadius: imageRadius ?? this.imageRadius,
        primaryButtonElevation: primaryButtonElevation ?? this.primaryButtonElevation,
        secondaryButtonElevation: secondaryButtonElevation ?? this.secondaryButtonElevation,
        cardElevation: cardElevation ?? this.cardElevation,
        modalElevation: modalElevation ?? this.modalElevation,
        imageElevation: imageElevation ?? this.imageElevation,
        neumorphismEnabled: neumorphismEnabled ?? this.neumorphismEnabled,
        glassEnabled: glassEnabled ?? this.glassEnabled,
        glassOpacity: glassOpacity ?? this.glassOpacity,
        glassBlur: glassBlur ?? this.glassBlur,
        glassGradient: glassGradient ?? this.glassGradient,
      );

  Map<String, dynamic> toJson() => {
        'primaryButtonRadius': primaryButtonRadius,
        'secondaryButtonRadius': secondaryButtonRadius,
        'cardRadius': cardRadius,
        'inputRadius': inputRadius,
        'modalRadius': modalRadius,
        'imageRadius': imageRadius,
        'primaryButtonElevation': primaryButtonElevation,
        'secondaryButtonElevation': secondaryButtonElevation,
        'cardElevation': cardElevation,
        'modalElevation': modalElevation,
        'imageElevation': imageElevation,
        'neumorphismEnabled': neumorphismEnabled,
        'glassEnabled': glassEnabled,
        'glassOpacity': glassOpacity,
        'glassBlur': glassBlur,
        'glassGradient': glassGradient,
      };

  factory RadiusShadowSettings.fromJson(Map<String, dynamic>? j) {
    const d = RadiusShadowSettings();
    if (j == null) return d;
    return RadiusShadowSettings(
      primaryButtonRadius: (j['primaryButtonRadius'] as num?)?.toDouble() ?? d.primaryButtonRadius,
      secondaryButtonRadius: (j['secondaryButtonRadius'] as num?)?.toDouble() ?? d.secondaryButtonRadius,
      cardRadius: (j['cardRadius'] as num?)?.toDouble() ?? d.cardRadius,
      inputRadius: (j['inputRadius'] as num?)?.toDouble() ?? d.inputRadius,
      modalRadius: (j['modalRadius'] as num?)?.toDouble() ?? d.modalRadius,
      imageRadius: (j['imageRadius'] as num?)?.toDouble() ?? d.imageRadius,
      primaryButtonElevation: (j['primaryButtonElevation'] as num?)?.toDouble() ?? d.primaryButtonElevation,
      secondaryButtonElevation: (j['secondaryButtonElevation'] as num?)?.toDouble() ?? d.secondaryButtonElevation,
      cardElevation: (j['cardElevation'] as num?)?.toDouble() ?? d.cardElevation,
      modalElevation: (j['modalElevation'] as num?)?.toDouble() ?? d.modalElevation,
      imageElevation: (j['imageElevation'] as num?)?.toDouble() ?? d.imageElevation,
      neumorphismEnabled: j['neumorphismEnabled'] as bool? ?? d.neumorphismEnabled,
      glassEnabled: j['glassEnabled'] as bool? ?? d.glassEnabled,
      glassOpacity: (j['glassOpacity'] as num?)?.toDouble() ?? d.glassOpacity,
      glassBlur: (j['glassBlur'] as num?)?.toDouble() ?? d.glassBlur,
      glassGradient: j['glassGradient'] as bool? ?? d.glassGradient,
    );
  }
}

class MotionSettings {
  final String transitionType; // slide, fade, scale, rotate, hero
  final int transitionDurationMs;
  final String curveName;
  final String hoverEffect; // scale, glow, lift
  final String hapticFeedback; // vibrate, sound, none
  final String scrollEffect; // parallax, sticky, fade

  const MotionSettings({
    this.transitionType = 'fade',
    this.transitionDurationMs = 320,
    this.curveName = 'easeInOut',
    this.hoverEffect = 'scale',
    this.hapticFeedback = 'vibrate',
    this.scrollEffect = 'fade',
  });

  static const transitionTypes = ['slide', 'fade', 'scale', 'rotate', 'hero'];
  static const curveNames = [
    'easeInOut',
    'easeOut',
    'easeIn',
    'bounceOut',
    'elasticOut',
    'fastOutSlowIn',
    'linear',
    'decelerate',
    'accelerate',
    'easeOutCubic',
    'easeInCubic',
    'easeOutBack',
  ];
  static const hoverEffects = ['scale', 'glow', 'lift'];
  static const hapticModes = ['vibrate', 'sound', 'none'];
  static const scrollEffects = ['parallax', 'sticky', 'fade'];

  MotionSettings copyWith({
    String? transitionType,
    int? transitionDurationMs,
    String? curveName,
    String? hoverEffect,
    String? hapticFeedback,
    String? scrollEffect,
  }) =>
      MotionSettings(
        transitionType: transitionType ?? this.transitionType,
        transitionDurationMs: transitionDurationMs ?? this.transitionDurationMs,
        curveName: curveName ?? this.curveName,
        hoverEffect: hoverEffect ?? this.hoverEffect,
        hapticFeedback: hapticFeedback ?? this.hapticFeedback,
        scrollEffect: scrollEffect ?? this.scrollEffect,
      );

  Map<String, dynamic> toJson() => {
        'transitionType': transitionType,
        'transitionDurationMs': transitionDurationMs,
        'curveName': curveName,
        'hoverEffect': hoverEffect,
        'hapticFeedback': hapticFeedback,
        'scrollEffect': scrollEffect,
      };

  factory MotionSettings.fromJson(Map<String, dynamic>? j) {
    const d = MotionSettings();
    if (j == null) return d;
    return MotionSettings(
      transitionType: j['transitionType'] as String? ?? d.transitionType,
      transitionDurationMs: j['transitionDurationMs'] as int? ?? d.transitionDurationMs,
      curveName: j['curveName'] as String? ?? d.curveName,
      hoverEffect: j['hoverEffect'] as String? ?? d.hoverEffect,
      hapticFeedback: j['hapticFeedback'] as String? ?? d.hapticFeedback,
      scrollEffect: j['scrollEffect'] as String? ?? d.scrollEffect,
    );
  }
}

class SavedColorPalette {
  final String name;
  final DesignColorPalette light;
  final DesignColorPalette dark;
  final DateTime createdAt;

  const SavedColorPalette({
    required this.name,
    required this.light,
    required this.dark,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'light': light.toJson(),
        'dark': dark.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavedColorPalette.fromJson(Map<String, dynamic> j) => SavedColorPalette(
        name: j['name'] as String,
        light: DesignColorPalette.fromJson(j['light'] as Map<String, dynamic>),
        dark: DesignColorPalette.fromJson(j['dark'] as Map<String, dynamic>),
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

class DesignActivity {
  final String id;
  final String titleAr;
  final String icon;
  final DateTime at;

  const DesignActivity({
    required this.id,
    required this.titleAr,
    required this.icon,
    required this.at,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleAr': titleAr,
        'icon': icon,
        'at': at.toIso8601String(),
      };

  factory DesignActivity.fromJson(Map<String, dynamic> j) => DesignActivity(
        id: j['id'] as String,
        titleAr: j['titleAr'] as String,
        icon: j['icon'] as String? ?? 'edit',
        at: DateTime.tryParse(j['at'] as String? ?? '') ?? DateTime.now(),
      );
}

/// Complete design identity configuration.
class DesignSettings {
  final DesignColorPalette lightColors;
  final DesignColorPalette darkColors;
  final TypographySettings typography;
  final RadiusShadowSettings radiusShadows;
  final MotionSettings motion;
  final List<SavedColorPalette> savedPalettes;
  final List<DesignActivity> recentActivities;

  const DesignSettings({
    this.lightColors = DesignColorPalette.lightDefaults,
    this.darkColors = DesignColorPalette.darkDefaults,
    this.typography = const TypographySettings(),
    this.radiusShadows = const RadiusShadowSettings(),
    this.motion = const MotionSettings(),
    this.savedPalettes = const [],
    this.recentActivities = const [],
  });

  DesignSettings copyWith({
    DesignColorPalette? lightColors,
    DesignColorPalette? darkColors,
    TypographySettings? typography,
    RadiusShadowSettings? radiusShadows,
    MotionSettings? motion,
    List<SavedColorPalette>? savedPalettes,
    List<DesignActivity>? recentActivities,
  }) =>
      DesignSettings(
        lightColors: lightColors ?? this.lightColors,
        darkColors: darkColors ?? this.darkColors,
        typography: typography ?? this.typography,
        radiusShadows: radiusShadows ?? this.radiusShadows,
        motion: motion ?? this.motion,
        savedPalettes: savedPalettes ?? this.savedPalettes,
        recentActivities: recentActivities ?? this.recentActivities,
      );

  Map<String, dynamic> toJson() => {
        'lightColors': lightColors.toJson(),
        'darkColors': darkColors.toJson(),
        'typography': typography.toJson(),
        'radiusShadows': radiusShadows.toJson(),
        'motion': motion.toJson(),
        'savedPalettes': savedPalettes.map((e) => e.toJson()).toList(),
        'recentActivities': recentActivities.map((e) => e.toJson()).toList(),
      };

  factory DesignSettings.fromJson(Map<String, dynamic> j) => DesignSettings(
        lightColors: DesignColorPalette.fromJson(
            j['lightColors'] as Map<String, dynamic>? ?? {}),
        darkColors: DesignColorPalette.fromJson(
            j['darkColors'] as Map<String, dynamic>? ?? {}),
        typography: TypographySettings.fromJson(
            j['typography'] as Map<String, dynamic>?),
        radiusShadows: RadiusShadowSettings.fromJson(
            j['radiusShadows'] as Map<String, dynamic>?),
        motion: MotionSettings.fromJson(j['motion'] as Map<String, dynamic>?),
        savedPalettes: (j['savedPalettes'] as List<dynamic>?)
                ?.map((e) => SavedColorPalette.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        recentActivities: (j['recentActivities'] as List<dynamic>?)
                ?.map((e) => DesignActivity.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  static DesignSettings get defaults => const DesignSettings();
}

/// Singleton service — persists and notifies the app on every change.
class DesignEngineService {
  DesignEngineService._();
  static final DesignEngineService instance = DesignEngineService._();

  final ValueNotifier<int> revisionNotifier = ValueNotifier<int>(0);

  DesignSettings _settings = DesignSettings.defaults;
  SharedPreferences? _prefs;

  DesignSettings get settings => _settings;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_prefsKey);
    if (raw != null) {
      try {
        _settings = DesignSettings.fromJson(
            jsonDecode(raw) as Map<String, dynamic>);
      } catch (e) {
        if (kDebugMode) debugPrint('[DesignEngine] load error: $e');
        _settings = DesignSettings.defaults;
      }
    }
    if (_settings.recentActivities.isEmpty) {
      _settings = _settings.copyWith(recentActivities: _seedActivities());
      await _persist();
    }
  }

  List<DesignActivity> _seedActivities() => [
        DesignActivity(
          id: '1',
          titleAr: 'إضافة منتج جديد',
          icon: 'inventory',
          at: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        DesignActivity(
          id: '2',
          titleAr: 'حجز خدمة منزلية',
          icon: 'handyman',
          at: DateTime.now().subtract(const Duration(minutes: 34)),
        ),
        DesignActivity(
          id: '3',
          titleAr: 'نشر إعلان مبوب',
          icon: 'campaign',
          at: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        DesignActivity(
          id: '4',
          titleAr: 'تحديث ألوان الهوية',
          icon: 'palette',
          at: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        DesignActivity(
          id: '5',
          titleAr: 'تسجيل مستخدم جديد',
          icon: 'person_add',
          at: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];

  Future<void> updateSettings(DesignSettings next, {String? activity}) async {
    _settings = next;
    if (activity != null) {
      await logActivity(activity);
      return;
    }
    await _persist();
    _notify();
  }

  Future<void> applyNow(DesignSettings next, {String activity = 'تطبيق إعدادات التصميم'}) async {
    _settings = next;
    await logActivity(activity, persistSettings: false);
    await _persist();
    _notify();
  }

  Future<void> saveForFuture() async {
    await _prefs?.setString(_savedFutureKey, jsonEncode(_settings.toJson()));
    await logActivity('حفظ الإعدادات للإصدارات القادمة');
  }

  Future<void> resetToDefaults() async {
    _settings = DesignSettings.defaults.copyWith(
      recentActivities: _settings.recentActivities,
    );
    await logActivity('إعادة تعيين الهوية للافتراضي');
    await _persist();
    _notify();
  }

  String exportJson() => const JsonEncoder.withIndent('  ').convert(_settings.toJson());

  Future<bool> importJson(String raw) async {
    try {
      final parsed = DesignSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      await applyNow(parsed, activity: 'استيراد إعدادات JSON');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> savePalette(String name) async {
    final palette = SavedColorPalette(
      name: name,
      light: _settings.lightColors,
      dark: _settings.darkColors,
      createdAt: DateTime.now(),
    );
    final list = [..._settings.savedPalettes, palette];
    _settings = _settings.copyWith(savedPalettes: list);
    await logActivity('حفظ لوحة ألوان: $name');
  }

  Future<void> loadPalette(SavedColorPalette palette) async {
    _settings = _settings.copyWith(
      lightColors: palette.light,
      darkColors: palette.dark,
    );
    await applyNow(_settings, activity: 'تحميل لوحة: ${palette.name}');
  }

  Future<void> logActivity(String titleAr, {String icon = 'edit', bool persistSettings = true}) async {
    final entry = DesignActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titleAr: titleAr,
      icon: icon,
      at: DateTime.now(),
    );
    final activities = [entry, ..._settings.recentActivities].take(5).toList();
    _settings = _settings.copyWith(recentActivities: activities);
    if (persistSettings) {
      await _persist();
      _notify();
    }
  }

  Future<void> _persist() async {
    await _prefs?.setString(_prefsKey, jsonEncode(_settings.toJson()));
  }

  void _notify() {
    revisionNotifier.value++;
  }
}
