// test/components/basic_info_card_test.dart
// Tests generated by ChatGPT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/basic_info_card.dart';
import 'package:uplift/constants/constants.dart';
void main() {
  group('BasicInfoCard', () {
    const fullName = 'John Doe';
    const address = '789 Elm St, Suite 5';
    const email = 'john@example.com';

    testWidgets('renders correctly with provided data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BasicInfoCard(
              fullName: fullName,
              address: address,
              email: email,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify fullName text
      expect(find.text(fullName), findsOneWidget);
      final fullNameText = tester.widget<Text>(find.text(fullName));
      expect(fullNameText.style, equals(Theme.of(tester.element(find.text(fullName))).textTheme.titleLarge));

      // Verify address row
      final locationIcon = find.widgetWithIcon(Row, Icons.location_on);
      expect(locationIcon, findsOneWidget);
      expect(find.text(address), findsOneWidget);

      // Verify email row
      final emailIcon = find.widgetWithIcon(Row, Icons.email);
      expect(emailIcon, findsOneWidget);
      expect(find.text(email), findsOneWidget);

      // Verify Card properties
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, equals(AppColors.warmWhite));
      expect(card.margin, equals(const EdgeInsets.symmetric(horizontal: 8, vertical: 10)));
      expect(card.elevation, equals(5));

      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, equals(BorderRadius.circular(20)));
      expect(shape.side.color, equals(AppColors.baseBlue));
      expect(shape.side.width, equals(4));
    });

    testWidgets('throws when required fields are null', (tester) async {
      // Since fullName, address, and email are required and non-nullable in build,
      // passing null should throw a FlutterError.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BasicInfoCard(),
          ),
        ),
      );
      expect(tester.takeException(), isA<TypeError>());
    });
  });
}
