// test/components/confirmation_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/screens/recipient_reg_screens/confirmation_screen.dart';
import 'package:uplift/screens/recipient_reg_screens/registration_questions.dart';


void main() {
  group('Confirmation widget', () {
    final addressData = {
      'firstName': 'John',
      'lastName': 'Doe',
      'streetAddress1': '123 Main St',
      'streetAddress2': 'Apt 4',
      'city': 'Anytown',
      'state': 'CA',
      'zipCode': '12345',
      // plus any other keys your registrationQuestions will pick up...
      // for example, if registrationQuestions includes a question with key 'foo':
      // 'foo': 'bar',
    };

    late String jumpedTo;
    late bool generated;

    setUp(() {
      jumpedTo = '';
      generated = false;
    });

    Widget makeTestable() {
      return MaterialApp(
        home: Confirmation(
          formData: addressData,
          onBack: () {}, // not used in this widget
          onJumpToQuestion: (key) => jumpedTo = key,
          onGenerate: () => generated = true,
        ),
      );
    }

    testWidgets('renders Name & Address card with grouped content and tap to edit',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable());
      // We should see the title
      expect(find.text('Name & Address'), findsOneWidget);
      // And the content joined by newlines
      const expectedContent =
          'John Doe\n123 Main St\nApt 4\nAnytown, CA 12345';
      expect(find.text(expectedContent), findsOneWidget);
      // And the "Tap to edit" hint
      expect(find.text('Tap to edit'), findsOneWidget);

      // Tapping the little edit icon should call onJumpToQuestion('basicAddressInfo')
      await tester.tap(find.byIcon(Icons.edit).first);
      expect(jumpedTo, 'basicAddressInfo');
    });

    testWidgets('shows Generate Tags dialog and calls onGenerate when confirmed',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable());

      // Tap the bottom "Generate Tags" button
      await tester.tap(find.text('Generate Tags'));
      await tester.pumpAndSettle();

      // Dialog should appear
      expect(find.text('Generate Tags?'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to generate tags? You will not be able to edit your profile or regenerate tags for 24 hours.',
        ),
        findsOneWidget,
      );

      // Tap the confirmation button
      await tester.tap(find.text('Yes, Generate Tags'));
      await tester.pumpAndSettle();

      expect(generated, isTrue);
    });

    testWidgets('cancelling the Generate Tags dialog does not call onGenerate',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestable());

      // Open dialog...
      await tester.tap(find.text('Generate Tags'));
      await tester.pumpAndSettle();

      // Tap "Cancel"
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog gone
      expect(find.text('Generate Tags?'), findsNothing);
      expect(generated, isFalse);
    });
  });
}
