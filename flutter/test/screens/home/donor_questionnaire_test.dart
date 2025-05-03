import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import '../../../lib/screens/home/donor_questionnaire_screen.dart';

void main() {
  testWidgets('DonorQuestionnaire flow test', (WidgetTester tester) async {
    // Set up a mock GoRouter
    final mockRouter = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DonorQuestionnaire(),
      ),
      GoRoute(
        path: '/donor_tag',
        name: '/donor_tag',
        builder: (context, state) {
          return Scaffold(
            body: Text('Tag Page'),
          );
        },
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: mockRouter,
      ),
    );

    // Check the first question is displayed
    expect(find.text('What motivates you to help others?'), findsOneWidget);
    expect(find.text('Question 1 of 3'), findsOneWidget);

    // Tap the first option
    await tester.tap(find.text("Making a positive impact in someone's life"));
    await tester.pumpAndSettle();

    // Check second question
    expect(find.text('How often would you like to donate?'), findsOneWidget);
    expect(find.text('Question 2 of 3'), findsOneWidget);

    // Tap second question's option
    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();

    // Check third question
    expect(find.text('Which causes are you most passionate about?'),
        findsOneWidget);
    expect(find.text('Question 3 of 3'), findsOneWidget);

    // Tap third question's option
    await tester.tap(find.text('Food security'));
    await tester.pumpAndSettle();

    // After final question, it should navigate to /donor_tag
    expect(find.text('Tag Page'), findsOneWidget);
  });
}
