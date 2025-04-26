import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/recipient_list_card.dart'; // adjust path
import 'package:uplift/models/recipient_model.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: '/recipient_list',
          builder: (context, state) => Scaffold(body: child),
        ),
        GoRoute(
          path: '/recipient_detail',
          name: '/recipient_detail',
          builder: (context, state) => const Scaffold(body: Text('Recipient Detail Page')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  group('RecipientListCard Widget', () {
    final testRecipient = Recipient(
      id: 1,
      firstName: 'Testy',
      lastAboutMe: 'I love Flutter!',
      city: 'Metropolis',
      state: 'NY',
      formQuestions: [],
    );

    testWidgets('displays recipient information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(RecipientListCard(recipient: testRecipient)));

      expect(find.text('Testy'), findsOneWidget);
      expect(find.text('I love Flutter!'), findsOneWidget);
      expect(find.text('Metropolis, NY'), findsOneWidget);
    });

    testWidgets('navigates to detail page when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(RecipientListCard(recipient: testRecipient)));

      // Tap the card
      await tester.tap(find.byType(RecipientListCard));
      await tester.pumpAndSettle();

      // Should navigate to recipient detail page
      expect(find.text('Recipient Detail Page'), findsOneWidget);
    });
  });
}
