// test/screens/history_detail_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/models/donation_model.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/recipients/recipient_history_details_screen.dart';

void main() {
  final dummyUser = User(
    id: 1,
    createdAt: DateTime.now(),
    cognitoId: 'cid',
    email: 'a@b.com',
    recipient: true,
    recipientData: null,
    donorData: null,
  );

  final donationWithoutThankYou = Donation(
    id: 42,
    createdAt: DateTime.parse('2025-01-02T03:04:05Z'),
    donorName: 'Bob',
    amount: 1234,             // 1234 cents
    thankYouMessage: null,
  );
  final donationWithThankYou = Donation(
    id: 42,
    createdAt: DateTime.parse('2025-01-02T03:04:05Z'),
    donorName: 'Bob',
    amount: 1234,
    thankYouMessage: 'Thanks so much!',
  );

  Widget _wrap(Donation d) => MaterialApp(home: HistoryDetailScreen(item: d, profile: dummyUser));

  testWidgets('shows donation info and send UI when no thank-you yet', (tester) async {
    await tester.pumpWidget(_wrap(donationWithoutThankYou));
    await tester.pumpAndSettle();

    // Donor name/card
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Date: 2025-01-02'), findsOneWidget);
    expect(find.text('Amount: \$1234.00'), findsOneWidget);

    // Send-message UI is shown
    expect(find.text('Write a Thank You Message:'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Rather than widgetWithIcon, just check the Icon and the label separately
    expect(find.byIcon(Icons.send), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('shows thank-you card when donation has thankYouMessage', (tester) async {
    await tester.pumpWidget(_wrap(donationWithThankYou));
    await tester.pumpAndSettle();

    // No send-UI
    expect(find.text('Write a Thank You Message:'), findsNothing);
    expect(find.byType(TextField), findsNothing);
    expect(find.byIcon(Icons.send), findsNothing);
    expect(find.text('Send'), findsNothing);

    // Thank-you card appears
    expect(find.text('Your Thank You Message'), findsOneWidget);
    expect(find.text('Thanks so much!'), findsOneWidget);
  });
}
