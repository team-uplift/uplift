// test/screens/home/question_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/screens/home/question_screen.dart';

void main() {
  testWidgets('QuestionPage shows an AppBar with title "Questions"', (tester) async {
    // Build our widget inside a MaterialApp so AppBar can work.
    await tester.pumpWidget(
      const MaterialApp(
        home: QuestionPage(),
      ),
    );

    // Look for an AppBar and the title text.
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Questions'), findsOneWidget);
  });
}
