import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/address_block.dart';
import 'package:uplift/models/recipient_model.dart';


void main() {
  group('NameAddressBlock Widget', () {
    testWidgets('renders correctly with recipient data', (WidgetTester tester) async {
      final recipient = Recipient(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        streetAddress1: '123 Main St',
        streetAddress2: 'Apt 4B',
        city: 'Springfield',
        state: 'IL',
        zipCode: '62704',
        formQuestions: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NameAddressBlock(recipient: recipient),
          ),
        ),
      );

      expect(find.text('Address'), findsOneWidget);
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text('Apt 4B'), findsOneWidget);
      expect(find.text('Springfield, IL 62704'), findsOneWidget);
    });

    testWidgets('renders correctly with formData only', (WidgetTester tester) async {
      final formData = {
        'streetAddress1': '456 Elm St',
        'streetAddress2': '',
        'city': 'Metropolis',
        'state': 'NY',
        'zipCode': '10001',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NameAddressBlock(formData: formData),
          ),
        ),
      );

      expect(find.text('456 Elm St'), findsOneWidget);
      expect(find.textContaining('Metropolis, NY 10001'), findsOneWidget);
      expect(find.text(''), findsNWidgets(0)); // make sure empty line 2 is skipped
    });

    testWidgets('asserts if neither recipient nor formData is provided', (WidgetTester tester) async {
      expect(
        () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: NameAddressBlock(),
              ),
            ),
          );
        },
        throwsAssertionError,
      );
    });
  });
}
