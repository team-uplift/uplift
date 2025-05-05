// test/widget/donation_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/donation_card.dart';
import 'package:uplift/providers/donation_notifier_provider.dart';
import 'package:uplift/models/recipient_model.dart';

void main() {
  group('DonationCard Widget', () {
    testWidgets(
      'displays provided nickname, date, amount, and colored mail icon when thankYouMessage present',
      (tester) async {
        // Arrange
        final donation = Donation(
          id: 1,
          donorId: 99,
          recipient: Recipient(
            id: 1,
            firstName: null,
            lastName: null,
            streetAddress1: null,
            streetAddress2: null,
            city: null,
            state: null,
            zipCode: null,
            lastAboutMe: null,
            lastReasonForHelp: null,
            formQuestions: null,
            identityLastVerified: null,
            incomeLastVerified: null,
            nickname: 'Nick',
            createdAt: null,
            imageURL: null,
            lastDonationTimestamp: null,
            tags: null,
            tagsLastGenerated: null,
          ),
          createdAt: DateTime(2025, 5, 4),
          amount: 123.4,
          thankYouMessage: 'Thanks!',
          recipientId: 1,
          recipientName: 'test',
        );

        // Pump widget with a theme to supply primaryColor
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(primaryColor: Colors.blue),
            home: Scaffold(
              body: DonationCard(donation: donation),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert nickname
        expect(find.text('Nick'), findsOneWidget);
        // Assert formatted date
        expect(find.text('5/4/2025'), findsOneWidget);
        // Assert formatted amount
        expect(find.text('\$123.40'), findsOneWidget);
        // Assert mail icon colored primary
        final icon = tester.widget<Icon>(find.byIcon(Icons.mail));
        expect((icon.color as Color), Colors.blue);
      },
    );

    testWidgets(
      'falls fallback to Anonymous and grey mail icon when thankYouMessage empty',
      (tester) async {
        // Arrange
        final donation = Donation(
          id: 2,
          donorId: 100,
          recipient: null,
          createdAt: DateTime(2025, 1, 1),
          amount: 5.0,
          thankYouMessage: '',
          recipientId: 1,
          recipientName: 'test',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DonationCard(donation: donation),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert default name
        expect(find.text('Anonymous'), findsOneWidget);
        // Assert date
        expect(find.text('1/1/2025'), findsOneWidget);
        // Assert amount
        expect(find.text('\$5.00'), findsOneWidget);
        // Assert mail icon grey
        final icon = tester.widget<Icon>(find.byIcon(Icons.mail));
        expect((icon.color as Color).value, equals(Colors.grey[300]!.value));
      },
    );
  });
}
