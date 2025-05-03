// test/screens/home/quiz_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uplift/screens/home/quiz_screen.dart';

void main() {
  Widget _buildTestable() {
    return MaterialApp(
      home: const QuizPage(),
      // We omit GoRouter here since we won't tap through to the final navigation.
    );
  }

  testWidgets('initially displays the first question', (tester) async {
    await tester.pumpWidget(_buildTestable());
    expect(find.text('What is the capital of France?'), findsOneWidget);
    // It should show the three choices
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('London'), findsOneWidget);
    expect(find.text('Berlin'), findsOneWidget);
  });

  testWidgets('tapping the choice button advances to the next question', (tester) async {
    await tester.pumpWidget(_buildTestable());

    // Tap any of the choice buttons (they all call the same callback)
    await tester.tap(find.text('Paris'));
    await tester.pumpAndSettle();

    // Now we should see question 2
    expect(find.text('Which planet is known as the Red Planet?'), findsOneWidget);
    expect(find.text('Mars'), findsOneWidget);

    // Tap again to advance to question 3
    await tester.tap(find.text('Mars'));
    await tester.pumpAndSettle();

    expect(find.text('How many continents are there on Earth?'), findsOneWidget);
    expect(find.text('Seven'), findsOneWidget);
  });
}
