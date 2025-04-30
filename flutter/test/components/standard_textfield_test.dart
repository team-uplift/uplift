// test/components/standard_text_field_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/standard_text_field.dart';

void main() {
  testWidgets('renders a TextField with the given label', (tester) async {
    const labelText = 'Email Address';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StandardTextField(title: labelText)),
      ),
    );
    await tester.pumpAndSettle();

    // Find the TextField
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    // Inspect its decoration
    final textField = tester.widget<TextField>(textFieldFinder);
    final decoration = textField.decoration!;
    
    // Verify the label is a Text widget with the correct text
    expect(decoration.label, isA<Text>());
    final labelWidget = decoration.label as Text;
    expect(labelWidget.data, equals(labelText));
  });

  testWidgets('uses a grey outline border when enabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StandardTextField(title: 'Test')),
      ),
    );
    await tester.pumpAndSettle();

    // Grab the TextField widget
    final textField = tester.widget<TextField>(find.byType(TextField));
    final decoration = textField.decoration!;

    // Verify enabledBorder is an OutlineInputBorder with grey border side
    final enabledBorder = decoration.enabledBorder;
    expect(enabledBorder, isA<OutlineInputBorder>());

    final outline = enabledBorder as OutlineInputBorder;
    expect(outline.borderSide.color, Colors.grey);
  });

  testWidgets('allows input of text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StandardTextField(title: 'Enter')),
      ),
    );
    await tester.pumpAndSettle();

    // Enter text into the TextField
    await tester.enterText(find.byType(TextField), 'Hello Flutter');
    await tester.pump();

    // The underlying EditableText widget should contain our input
    expect(find.text('Hello Flutter'), findsOneWidget);
  });
}
