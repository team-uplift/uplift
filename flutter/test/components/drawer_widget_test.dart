// test/components/recipient_list_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/recipient_list_card.dart';
import 'package:uplift/models/recipient_model.dart';

void main() {
  final testRecipient = Recipient(
    id: 1,
    firstName: 'Testy',
    nickname: 'Testy',
    lastAboutMe: 'I love Flutter!',
    city: 'Metropolis',
    state: 'NY',
    formQuestions: [],
  );

  testWidgets('displays recipient information correctly', (tester) async {
    // No GoRouter here—just MaterialApp + Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: RecipientListCard(recipient: testRecipient)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Testy'), findsOneWidget);
    expect(find.text('I love Flutter!'), findsOneWidget);
    expect(find.text('Metropolis, NY'), findsOneWidget);
  });

  testWidgets('navigates to detail page when tapped', (tester) async {
    // Build router *inside* the test
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: RecipientListCard(recipient: testRecipient),
          ),
        ),
        GoRoute(
          name: '/recipient_detail',  // exactly what the widget calls
          path: '/recipient_detail',
          builder: (context, state) => const Scaffold(
            body: Text('Recipient Detail Page'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );
    await tester.pumpAndSettle();

    // Tap the card
    await tester.tap(find.byType(RecipientListCard));
    await tester.pumpAndSettle();

    // Verify we reached the detail page
    expect(find.text('Recipient Detail Page'), findsOneWidget);
  });
}
