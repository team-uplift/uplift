// test/recipients/recipient_profile_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/tag_card.dart';
import 'package:uplift/recipients/recipient_profile_screen.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/verify_card.dart';
import 'package:uplift/components/recipient_tag_section.dart';
import 'package:uplift/components/donor_visible_info_card.dart';
import 'package:uplift/components/question_carousel.dart';

void main() {
  late User dummyUser;
  late Recipient dummyRecipient;

  setUp(() {
    final now = DateTime.now();
    dummyRecipient = Recipient(
      id: 1,
      firstName: 'Alice',
      lastName: 'Smith',
      streetAddress1: '123 Main St',
      streetAddress2: null,
      city: 'Townsville',
      state: 'TS',
      zipCode: '12345',
      lastAboutMe: 'About me text',
      lastReasonForHelp: 'Reason text',
      formQuestions: [
        {'question': 'Q1', 'answer': 'A1'},
        {'question': 'Q2', 'answer': 'A2'},
      ],
      incomeLastVerified: null,           // unverified
      identityLastVerified: null,
      nickname: null,
      createdAt: now,
      imageURL: null,
      lastDonationTimestamp: now,
      tags: [
        Tag(createdAt: now, addedAt: now, tagName: 'one', weight: 0.3),
        Tag(createdAt: now, addedAt: now, tagName: 'two', weight: 0.7),
      ],
      tagsLastGenerated: null,
    );

    dummyUser = User(
      id: 1,
      cognitoId: 'cid',
      email: 'alice@example.com',
      recipient: true,
      recipientData: dummyRecipient,
      donorData: null,
      createdAt: now,
    );
  });

  testWidgets('displays verify card, tags, info, and questions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RecipientProfileScreen(
          profile: dummyUser,
          recipient: dummyRecipient,
          onVerifyPressed: () {},   // no-op
        ),
      ),
    );

    // Let everything build
    await tester.pumpAndSettle();

    // 1) VerifyCard should show up when unverified
    expect(find.byType(VerifyCard), findsOneWidget);

    // 2) Tag section should show exactly two tags
    expect(find.byType(ProfileTagsSection), findsOneWidget);
    expect(find.byType(TagCard), findsNWidgets(2));

    // 3) Visible-info (About Me / Reason) card
    expect(find.byType(VisibleInfoCard), findsOneWidget);
    expect(find.text('About me text'), findsOneWidget);
    expect(find.text('Reason text'), findsOneWidget);

    // 4) Question carousel shows each question/answer
    expect(find.byType(QuestionCarousel), findsOneWidget);
    expect(find.text('Q1'), findsOneWidget);
    expect(find.text('A1'), findsOneWidget);
    expect(find.text('Q2'), findsOneWidget);
    expect(find.text('A2'), findsOneWidget);
  });
}
