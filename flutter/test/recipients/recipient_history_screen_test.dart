// test/screens/recipient_history_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/models/donation_model.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/recipients/recipient_history_screen.dart';

class MockRecipientApi extends Mock implements RecipientApi {}

void main() {
  late MockRecipientApi mockApi;
  late User dummyUser;
  late Recipient dummyRecipient;

  setUp(() {
    mockApi = MockRecipientApi();
    dummyRecipient = Recipient(id: 1, formQuestions: []);
    dummyUser = User(
      id: 1,
      createdAt: DateTime.now(),
      cognitoId: 'cid',
      email: 'a@b.com',
      recipient: true,
      recipientData: dummyRecipient,
      donorData: null,
    );
  });

  Widget _buildTestApp() {
    return MaterialApp(
      home: RecipientHistoryScreen(
        profile: dummyUser,
        recipient: dummyRecipient,
        api: mockApi,
      ),
    );
  }

  testWidgets('tapping a card pushes detail screen and then reloads when popped true',
      (tester) async {
    final donation = Donation(
      id: 20,
      createdAt: DateTime.parse('2025-03-03T00:00:00Z'),
      donorName: 'Carol',
      amount: 250,
    );

    // First call returns [donation], second call returns empty list
    var callCount = 0;
    when(() => mockApi.fetchDonationsForRecipient(1))
        .thenAnswer((_) async {
      callCount++;
      return callCount == 1 ? [donation] : <Donation>[];
    });

    await tester.pumpWidget(_buildTestApp());

    // initial load
    await tester.pump();             // start initState
    await tester.pumpAndSettle();    // finish first load

    // one card present
    expect(find.text('From Carol'), findsOneWidget);

    // Tap it
    await tester.tap(find.byType(ListTile).first);
    await tester.pump(); // begin navigation

    // Simulate that HistoryDetailScreen popped with 'true'
    tester.state<NavigatorState>(find.byType(Navigator)).pop(true);
    await tester.pumpAndSettle();

    // Now the second stub ran and returned empty list.
    // Since _isLoading stays false, no spinner—just empty-state.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('No donations yet'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });
}
