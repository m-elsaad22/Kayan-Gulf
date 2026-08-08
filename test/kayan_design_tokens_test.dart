import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/core/theme/kayan_design_tokens.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KayanDesignTokens', () {
    test('core brand colors are defined', () {
      expect(KayanDesignTokens.kBlue, isA<Color>());
      expect(KayanDesignTokens.kGreen, isA<Color>());
      expect(KayanDesignTokens.bg, isA<Color>());
      expect(KayanDesignTokens.surface, isA<Color>());
    });

    test('colorFromHex parses 6-digit hex', () {
      expect(
        KayanDesignTokens.colorFromHex('#0B4F9E'),
        const Color(0xFF0B4F9E),
      );
    });

    test('colorFromHex returns fallback on invalid input', () {
      expect(
        KayanDesignTokens.colorFromHex('invalid'),
        KayanDesignTokens.kBlue,
      );
    });

    test('gradients are non-empty', () {
      expect(KayanDesignTokens.gradBlue.colors, isNotEmpty);
      expect(KayanDesignTokens.gradGreen.colors, isNotEmpty);
      expect(KayanDesignTokens.shadowS, isNotEmpty);
    });
  });
}
