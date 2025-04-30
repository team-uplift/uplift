// test/components/tag_selection_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/match_color_legend.dart';
import 'package:uplift/components/tag_card.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/screens/recipient_reg_screens/tag_selection_screen.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('TagSelection', () {
    late List<Tag> tags;
    late Map<String, dynamic> formData;
    late bool submitCalled;
    late bool backCalled;

setUp(() {
      final now = DateTime.now();
      tags = [
        Tag(
          tagName: 'Low',
          weight: 0.1,
          createdAt: now,
          addedAt: now,
        ),
        Tag(
          tagName: 'High',
          weight: 0.9,
          createdAt: now,
          addedAt: now,
        ),
        Tag(
          tagName: 'Medium',
          weight: 0.5,
          createdAt: now,
          addedAt: now,
        ),
      ];
      formData = {};
      submitCalled = false;
      backCalled = false;
    });

    testWidgets('renders header, count, legend and all tags (sorted by weight)',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(
        TagSelection(
          formData: formData,
          availableTags: tags,
          onSubmit: () => submitCalled = true,
          onBack: () => backCalled = true,
        ),
      ));
      await tester.pumpAndSettle();

      // Header text
      expect(find.text('Select up to 10 interests'), findsOneWidget);

      // Initial count
      expect(find.text('0 of 10 selected'), findsOneWidget);

      // Legend present
      expect(find.byType(MatchColorLegend), findsOneWidget);

      // Tags are displayed in descending weight order: High, Medium, Low
      final cardLabels = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(TagCard),
          matching: find.byType(Text),
        ),
      ).map((t) => t.data).toList();

      // first three Text widgets inside TagCard are the labels
      expect(cardLabels.take(3), ['High', 'Medium', 'Low']);
    });

    testWidgets('tapping a tag toggles selection and updates count',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(
        TagSelection(
          formData: formData,
          availableTags: tags,
          onSubmit: () => submitCalled = true,
          onBack: () => backCalled = true,
        ),
      ));
      await tester.pumpAndSettle();

      // Tap "Medium"
      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();

      expect(find.text('1 of 10 selected'), findsOneWidget);
      expect(tags.firstWhere((t) => t.tagName == 'Medium').selected, isTrue);

      // Tap again to unselect
      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();

      expect(find.text('0 of 10 selected'), findsOneWidget);
      expect(tags.firstWhere((t) => t.tagName == 'Medium').selected, isFalse);
    });

    testWidgets('Submit button is disabled until at least one tag is selected and then calls onSubmit and writes to formData',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(
        TagSelection(
          formData: formData,
          availableTags: tags,
          onSubmit: () => submitCalled = true,
          onBack: () => backCalled = true,
        ),
      ));
      await tester.pumpAndSettle();

      final submitFinder = find.widgetWithText(ElevatedButton, 'Submit');
      final ElevatedButton submitButton = tester.widget(submitFinder);

      // initially disabled
      expect(submitButton.onPressed, isNull);

      // select one tag
      await tester.tap(find.text('Low'));
      await tester.pumpAndSettle();

      final ElevatedButton submitButtonEnabled = tester.widget(submitFinder);
      expect(submitButtonEnabled.onPressed, isNotNull);

      // tap submit
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(submitCalled, isTrue);
      // formData should now have a "tags" key with the selected Tag(s)
      expect(formData.containsKey('tags'), isTrue);
      final List<Tag> selected = formData['tags'] as List<Tag>;
      expect(selected.map((t) => t.tagName), contains('Low'));
    });
  });
}
