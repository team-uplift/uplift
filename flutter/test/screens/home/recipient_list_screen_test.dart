// test/components/recipient_list_test.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/recipient_list_card.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/screens/home/recipient_list_screen.dart';

/// Override HttpClient so any NetworkImage calls don’t fail in tests.
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

  Future<void> _pumpList(WidgetTester tester, {List<Recipient>? recipients}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RecipientList(fetchedRecipients: recipients),
      ),
    );
    // Let the list render
    await tester.pumpAndSettle();
  }

  testWidgets('shows four cards by default (testRecipients)', (tester) async {
    // No fetchedRecipients: uses RecipientList.testRecipients (4 items)
    await _pumpList(tester);

    // Should find exactly 4 RecipientListCard widgets
    expect(find.byType(RecipientListCard), findsNWidgets(4));

    // And the header text should reflect the count
    expect(find.text('Found 4 Recipients'), findsOneWidget);
  });

  testWidgets('shows empty state when passed an empty list', (tester) async {
    await _pumpList(tester, recipients: []);

    // Should not find any cards
    expect(find.byType(RecipientListCard), findsNothing);

    // Should show the "no recipients" icon and message
    expect(find.byIcon(Icons.search_off), findsOneWidget);
    expect(
      find.text('No recipients found matching your selected tags'),
      findsOneWidget,
    );
  });
}
