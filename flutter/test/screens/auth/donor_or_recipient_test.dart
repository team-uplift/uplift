// test/components/donor_or_recipient_test.dart
// Widget tests for DonorOrRecipient navigation buttons using button order

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/screens/auth/donor_or_recipient_screen.dart';
// import 'package:uplift/screens/donor_or_recipient.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DonorOrRecipient(),
        ),
        GoRoute(
          name: '/home',
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Page')),
        ),
        GoRoute(
          name: '/recipient_registration',
          path: '/recipient_registration',
          builder: (context, state) => const Scaffold(body: Text('Recipient Registration Page')),
        ),
      ],
    );
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders two StandardButton widgets', (tester) async {
    await pumpApp(tester);
    expect(find.byType(StandardButton), findsNWidgets(2));
  });




}

