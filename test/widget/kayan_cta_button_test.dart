import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/shared/widgets/design/kayan_entry_widgets.dart';

void main() {
  testWidgets('KayanCtaButton renders label and responds to tap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KayanCtaButton(
            label: 'متابعة',
            variant: KayanCtaVariant.blue,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('متابعة'), findsOneWidget);
    await tester.tap(find.text('متابعة'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('KayanCtaButton disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KayanCtaButton(
            label: 'معطّل',
            variant: KayanCtaVariant.green,
            onPressed: null,
          ),
        ),
      ),
    );

    final button = tester.widget<GestureDetector>(
      find.descendant(
        of: find.byType(KayanCtaButton),
        matching: find.byType(GestureDetector),
      ).first,
    );
    expect(button.onTap, isNull);
  });
}
