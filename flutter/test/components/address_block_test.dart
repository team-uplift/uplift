// test/components/name_address_block_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/address_block.dart';
import 'package:uplift/models/recipient_model.dart';

void main() {
  group('NameAddressBlock', () {
    testWidgets('renders correctly with a Recipient object', (tester) async {
      final recipient = Recipient(
        id: 1,
        streetAddress1: '123 Main St',
        streetAddress2: 'Apt 4B',
        city: 'Testville',
        state: 'TS',
        zipCode: '98765',
        formQuestions: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NameAddressBlock(recipient: recipient),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header
      final header = find.text('Address');
      expect(header, findsOneWidget);
      final headerWidget = tester.widget<Text>(header);
      expect(headerWidget.style?.fontWeight, FontWeight.bold);

      // Address lines
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text('Apt 4B'), findsOneWidget);
      expect(find.text('Testville, TS 98765'), findsOneWidget);

      // Divider
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('renders correctly with formData map', (tester) async {
      final formData = {
        'streetAddress1': '456 Side Rd',
        'streetAddress2': '',
        'city': 'Example City',
        'state': 'EX',
        'zipCode': '00000',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NameAddressBlock(formData: formData),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should not render an empty second line
      expect(find.text('456 Side Rd'), findsOneWidget);
      expect(find.text(''), findsNothing);

      // City/state/zip
      expect(find.text('Example City, EX 00000'), findsOneWidget);
    });

    test('throws AssertionError if neither recipient nor formData is provided', () {
      expect(
        () => NameAddressBlock(),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
