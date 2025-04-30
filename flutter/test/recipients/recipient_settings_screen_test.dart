// test/screens/recipient_settings_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/recipients/recipient_settings_screen.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';

void main() {
  late User dummyUser;
  late Recipient dummyRecipient;
  late GoRouter router;

  setUp(() {
    // user + recipient with a tagsLastGenerated >24h ago (so canEdit==true)
    final yesterday = DateTime.now().subtract(Duration(hours: 25));
    dummyRecipient = Recipient(
      id: 1,
      firstName: 'A',
      lastName: 'B',
      streetAddress1: '',
      streetAddress2: '',
      city: '',
      state: '',
      zipCode: '',
      lastAboutMe: '',
      lastReasonForHelp: '',
      formQuestions: [],
      identityLastVerified: null,
      incomeLastVerified: null,
      nickname: null,
      createdAt: null,
      imageURL: null,
      lastDonationTimestamp: null,
      tags: [Tag(createdAt: yesterday, tagName: 't', weight: 0.5, addedAt: yesterday)],
      tagsLastGenerated: yesterday,
    );
    dummyUser = User(
      id: 1,
      cognitoId: 'cid',
      email: 'e@x.com',
      recipient: true,
      recipientData: dummyRecipient,
      donorData: null,
      createdAt: null,
    );

    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (c, s) => RecipientSettingsScreen(
            profile: dummyUser,
            recipient: dummyRecipient,
          ),
        ),
        GoRoute(
          path: '/recipient_registration',
          name: '/recipient_registration',
          builder: (c, s) => const Scaffold(body: Text('REGISTRATION PAGE')),
        ),
      ],
    );
  });

  Widget buildTestable() {
    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('when tagsLastGenerated >24h ago, Edit Profile is enabled and taps through',
      (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    // The subtitle should *not* say "Available in"
    expect(
      find.descendant(
        of: find.byIcon(Icons.edit),
        matching: find.textContaining('Available in'),
      ),
      findsNothing,
    );

    // And tapping the ListTile should nav to registration
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();

    expect(find.text('REGISTRATION PAGE'), findsOneWidget);
  });

  testWidgets('when tagsLastGenerated recently, Edit Profile stays disabled',
      (tester) async {
    // make tagsLastGenerated only 1m ago → cooldown still in effect
    dummyRecipient = Recipient(
      id: 1,
      firstName: 'A',
      lastName: 'B',
      streetAddress1: '',
      streetAddress2: '',
      city: '',
      state: '',
      zipCode: '',
      lastAboutMe: '',
      lastReasonForHelp: '',
      formQuestions: [],
      identityLastVerified: null,
      incomeLastVerified: null,
      nickname: null,
      createdAt: null,
      imageURL: null,
      lastDonationTimestamp: null,
      tags: [Tag(createdAt: DateTime.now(), tagName: 't', weight: 0.5, addedAt: DateTime.now())],
      tagsLastGenerated: DateTime.now().subtract(Duration(minutes: 1)),
    );
    dummyUser = User(
      id: 1,
      cognitoId: 'cid',
      email: 'e@x.com',
      recipient: true,
      recipientData: dummyRecipient,
      donorData: null,
      createdAt: null,
    );
    // rebuild router with the fresh dummyRecipient
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (c, s) => RecipientSettingsScreen(
            profile: dummyUser,
            recipient: dummyRecipient,
          ),
        ),
      ],
    );

    await tester.pumpWidget(buildTestable());
    await tester.pump(); // start cooldown timer
    await tester.pump(const Duration(milliseconds: 10)); // let state settle

    // Now the subtitle should show an "Available in" countdown
    expect(
      find.textContaining('Available in'),
      findsOneWidget,
    );

    // Tapping should do nothing
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();
    // Still on the same screen
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.textContaining('Available in'), findsOneWidget);
  });
}
