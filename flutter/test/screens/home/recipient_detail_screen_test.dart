// test/components/recipient_detail_page_test.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/screens/home/recipient_detail_screen.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/components/standard_button.dart';

/// Prevent actual network image loads from failing in tests.
class _NoOpHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _NoOpHttpOverrides();
  });

  Widget _wrapForTest(Recipient recipient) {
    return MaterialApp(
      home: RecipientDetailPage(recipient: recipient),
    );
  }

  testWidgets('shows DONATE button for a valid recipient', (tester) async {
    final valid = Recipient(
      id: 42,
      firstName: 'Alice',
      lastName: 'Smith',
      imageURL: null,
      lastAboutMe: 'About Alice',
      lastReasonForHelp: null,
      city: 'Springfield',
      state: 'IL',
      streetAddress1: '',
      streetAddress2: '',
      zipCode: '',
      formQuestions: [],
      identityLastVerified: null,
      incomeLastVerified: null,
      nickname: null,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(_wrapForTest(valid));
    await tester.pumpAndSettle();

    // Share icon should be present
    expect(find.byIcon(Icons.share), findsOneWidget);

    // StandardButton titled "DONATE" should appear
    expect(find.widgetWithText(StandardButton, 'DONATE'), findsOneWidget);

    // Fallback message should NOT appear
    expect(
      find.text('Cannot donate to this recipient - missing required information'),
      findsNothing,
    );
  });

  testWidgets('shows fallback message for an invalid recipient', (tester) async {
    // Invalid: no id and no name/nickname
    final invalid = Recipient(
      id: 42,
      firstName: null,
      lastName: null,
      imageURL: null,
      lastAboutMe: null,
      lastReasonForHelp: null,
      city: null,
      state: null,
      streetAddress1: '',
      streetAddress2: '',
      zipCode: '',
      formQuestions: [],
      identityLastVerified: null,
      incomeLastVerified: null,
      nickname: null,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(_wrapForTest(invalid));
    await tester.pumpAndSettle();

    // Share icon still present
    expect(find.byIcon(Icons.share), findsOneWidget);

    // No DONATE button
    expect(find.widgetWithText(StandardButton, 'DONATE'), findsNothing);

    // Instead, the fallback message should be shown
    expect(
      find.text('Cannot donate to this recipient - missing required information'),
      findsOneWidget,
    );
  });
}
