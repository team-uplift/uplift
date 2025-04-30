// test/components/standard_button_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/standard_button.dart';

void main() {
  testWidgets('renders the title in uppercase', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StandardButton(
            title: 'Click Me',
          ),
        ),
      ),
    );
    // The text should be uppercased
    expect(find.text('CLICK ME'), findsOneWidget);

    // Verify the text style is white
    final textWidget = tester.widget<Text>(find.text('CLICK ME'));
    expect(textWidget.style?.color, Colors.white);
  });

  testWidgets('invokes onPressed callback when tapped', (tester) async {
    bool wasPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StandardButton(
            title: 'Tap',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    // Tap the button
    await tester.tap(find.byType(StandardButton));
    await tester.pumpAndSettle();

    // Callback should have been invoked
    expect(wasPressed, isTrue);
  });

  testWidgets('does nothing when onPressed is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StandardButton(
            title: 'No Action',
            onPressed: null,
          ),
        ),
      ),
    );

    // Should not throw when tapped
    await tester.tap(find.byType(StandardButton));
    await tester.pumpAndSettle();

    // Still finds the button rendered
    expect(find.text('NO ACTION'), findsOneWidget);
  });

  testWidgets('has correct styling and layout', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StandardButton(title: 'Style'),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(StandardButton),
        matching: find.byType(Container),
      ).first,
    );

    // Check height
    final box = tester.renderObject<RenderBox>(
      find.descendant(
        of: find.byType(StandardButton),
        matching: find.byType(Container),
      ).first,
    );
    expect(box.size.height, 60.0);

    // Check decoration
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.black);
    expect(decoration.borderRadius, BorderRadius.all(Radius.circular(10)));
  });
}
