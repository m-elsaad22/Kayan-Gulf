import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/shared/widgets/design/kayan_design_widgets.dart';

void main() {
  testWidgets('KayanSectionHeader shows title and action', (tester) async {
    var actionTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KayanSectionHeader(
            title: 'عروض اليوم',
            action: 'عرض الكل',
            onAction: () => actionTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('عروض اليوم'), findsOneWidget);
    expect(find.text('عرض الكل'), findsOneWidget);
    await tester.tap(find.text('عرض الكل'));
    await tester.pump();
    expect(actionTapped, isTrue);
  });

  testWidgets('KayanLightTopBar shows title and triggers back', (tester) async {
    var backTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KayanLightTopBar(
            title: 'الإعدادات',
            onBack: () => backTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('الإعدادات'), findsOneWidget);
    await tester.tap(find.byType(KayanHeroIconButton));
    await tester.pump();
    expect(backTapped, isTrue);
  });

  testWidgets('KayanFilterSlotRow selects chip on tap', (tester) async {
    var selected = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KayanFilterSlotRow(
            labels: const ['الكل', 'جديد', 'مميز'],
            selectedIndex: selected,
            onSelected: (i) => selected = i,
          ),
        ),
      ),
    );

    expect(find.text('الكل'), findsOneWidget);
    await tester.tap(find.text('مميز'));
    await tester.pump();
    expect(selected, 2);
  });
}
