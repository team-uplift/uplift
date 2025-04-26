import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/donor_tag_card.dart'; // adjust the import if needed
import 'package:uplift/models/donor_tag_model.dart';

void main() {
  group('DonorTagCard Widget', () {
    final testTag = DonorTag(tagName: 'Wellness', createdAt: '2025-04-21T12:00:00Z');

    testWidgets('displays the correct tag name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DonorTagCard(tag: testTag, isSelected: false),
          ),
        ),
      );

      expect(find.text('Wellness'), findsOneWidget);
    });

    testWidgets('renders selected style when isSelected is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DonorTagCard(tag: testTag, isSelected: true),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = animatedContainer.decoration as BoxDecoration;

      // Assert that the background color is greenish when selected
      expect((decoration.color as Color).green, greaterThan(100));
      expect(decoration.border!.top.color, equals(Colors.green));
    });

    testWidgets('renders unselected style when isSelected is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DonorTagCard(tag: testTag, isSelected: false),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = animatedContainer.decoration as BoxDecoration;

      // Assert that the background color is white when not selected
      expect(decoration.color, equals(Colors.white));
      expect(decoration.border!.top.color, equals(Colors.grey.shade300));
    });
  });
}
