// test/screens/recipient_profile_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/recipients/recipient_profile_screen.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/tag_card.dart';

void main() {
  late User dummyUser;
  late Recipient dummyRecipient;

  setUp(() {
    dummyRecipient = Recipient(
      id: 123,
      firstName: 'Alice',
      lastName: 'Smith',
      streetAddress1: '123 Main St',
      streetAddress2: 'Apt 4',
      city: 'Townsville',
      state: 'TS',
      zipCode: '12345',
      lastAboutMe: 'About me text',
      lastReasonForHelp: 'Reason text',
      formQuestions: [
        {'question': 'Q1', 'answer': 'A1'},
        {'question': 'Q2', 'answer': 'A2'},
      ],
      // incomeLastVerified is null => unverified
      identityLastVerified: null,
      incomeLastVerified: null,
      nickname: null,
      createdAt: null,
      imageURL: null,
      lastDonationTimestamp: null,
      tags: [
        Tag(
          createdAt: DateTime.now(),
          tagName: 'low',
          weight: 0.2,
          addedAt: DateTime.now(),
        ),
        Tag(
          createdAt: DateTime.now(),
          tagName: 'high',
          weight: 0.8,
          addedAt: DateTime.now(),
        ),
      ],
      tagsLastGenerated: null,
    );

    dummyUser = User(
      id: 123,
      cognitoId: 'cid',
      email: 'alice@example.com',
      recipient: true,
      recipientData: dummyRecipient,
      donorData: null,
      createdAt: DateTime.now(),
    );
  });

  Widget buildTestable() {
    return MaterialApp(
      home: RecipientProfileScreen(
        profile: dummyUser,
        recipient: dummyRecipient,
      ),
    );
  }

  testWidgets(
      'renders all profile fields, verify button when unverified, and sorted tags',
      (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    // Name
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Alice Smith'), findsOneWidget);

    // Address
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('123 Main St\nApt 4\nTownsville, TS 12345'),
        findsOneWidget);

    // Email
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('alice@example.com'), findsOneWidget);

    // About Me
    expect(find.text('About Me'), findsOneWidget);
    expect(find.text('About me text'), findsOneWidget);

    // Why I Need Help
    expect(find.text('Why I Need Help'), findsOneWidget);
    expect(find.text('Reason text'), findsOneWidget);

    // Form questions
    expect(find.text('Q1'), findsOneWidget);
    expect(find.text('A1'), findsOneWidget);
    expect(find.text('Q2'), findsOneWidget);
    expect(find.text('A2'), findsOneWidget);

    // Income Verification unverified
    expect(find.text('Income Verification'), findsOneWidget);
    expect(find.text('❌ Not Verified'), findsOneWidget);

    // instead of widgetWithText, just look for the text and/or icon:
    expect(find.text('Verify Now'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    // Two TagCard widgets should be present
    expect(find.byType(TagCard), findsNWidgets(2));

    // They should be sorted by weight descending, so the first tag is 'high'
    final firstTagCard = tester.widget<TagCard>(find.byType(TagCard).first);
    expect(firstTagCard.tag.tagName, 'high');
  });
}
