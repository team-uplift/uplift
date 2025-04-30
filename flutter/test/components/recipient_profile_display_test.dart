// test/components/recipient_profile_display_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/recipient_profile_display.dart';
import 'package:uplift/components/match_color_legend.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';

void main() {
  late Recipient dummyRecipient;
  late List<Tag> dummyTags;

  setUp(() {
    dummyRecipient = Recipient(
      id: 1,
      formQuestions: [],
    );
    final now = DateTime.now();
    dummyTags = [
      Tag(
        createdAt: now,
        addedAt: now,
        tagName: 'Tag A',
        weight: 0.1,
      ),
      Tag(
        createdAt: now,
        addedAt: now,
        tagName: 'Tag B',
        weight: 0.2,
      ),
    ];
  });

  testWidgets('renders profile fields, tags, legend, and verify button when unverified',
      (tester) async {
    bool verifyCalled = false;
    final profileFields = {
      'Name': 'Alice',
      'Age': '30',
      'Income Verification': 'Not Verified',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipientProfileDisplay(
            profileFields: profileFields,
            tags: dummyTags,
            onVerifyPressed: () {
              verifyCalled = true;
            },
            recipient: dummyRecipient,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Profile field cards
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('Income Verification'), findsOneWidget);
    expect(find.text('Not Verified'), findsOneWidget);

    // Verify Now button label
    final verifyLabel = find.text('Verify Now');
    expect(verifyLabel, findsOneWidget);

    // Tap the button via its text
    await tester.tap(verifyLabel);
    await tester.pumpAndSettle();
    expect(verifyCalled, isTrue);

    // MatchColorLegend should appear
    expect(find.byType(MatchColorLegend), findsOneWidget);

    // TagCard widgets should render tag names
    expect(find.text('Tag A'), findsOneWidget);
    expect(find.text('Tag B'), findsOneWidget);
  });

  testWidgets('does not show verify button when already verified',
      (tester) async {
    final profileFields = {
      'Income Verification': '✅ Verified',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipientProfileDisplay(
            profileFields: profileFields,
            tags: [],
            onVerifyPressed: () {},
            recipient: dummyRecipient,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Now label should not appear
    expect(find.text('Verify Now'), findsNothing);

    // The verified checkmark should be shown
    expect(find.text('✅ Verified'), findsOneWidget);
  });
}
