import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/screens/home/question_screen.dart';

void main() {
  testWidgets('QuestionPage shows basic UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: QuestionPage(),
      ),
    );

    // Verify basic UI elements are present
    expect(find.text('Questions'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
