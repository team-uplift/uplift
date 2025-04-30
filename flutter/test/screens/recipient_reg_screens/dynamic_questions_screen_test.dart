// test/components/dynamic_question_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/screens/recipient_reg_screens/dynamic_questions_screen.dart';

void main() {
  Widget makeTestable({
    required Map<String, dynamic> formData,
    required List<Map<String, dynamic>> questions,
    required int questionIndex,
    required VoidCallback onNext,
    bool returnToConfirmation = false,
  }) {
    return MaterialApp(
      home: DynamicQuestionScreen(
        formData: formData,
        questions: questions,
        questionIndex: questionIndex,
        onNext: onNext,
        onBack: () {},
        onGenerate: () {},
        returnToConfirmation: returnToConfirmation,
      ),
    );
  }

  testWidgets('TEXT question shows text field and requires non-empty',
      (WidgetTester tester) async {
    final formData = <String, dynamic>{};
    var nextCalled = false;

    final questions = [
      {
        'q': 'Enter your name',
        'key': 'name',
        'type': 'text',
        'required': true,
      },
    ];

    await tester.pumpWidget(makeTestable(
      formData: formData,
      questions: questions,
      questionIndex: 0,
      onNext: () => nextCalled = true,
    ));

    // Should display the prompt
    expect(find.text('Enter your name'), findsOneWidget);
    // Should find the FormBuilderTextField by its ValueKey
    final nameField = find.byKey(const ValueKey('name'));
    expect(nameField, findsOneWidget);

    // Tap Next without entering anything: validation should block onNext
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pump();
    expect(nextCalled, isFalse);

    // Enter valid text and tap Next
    await tester.enterText(nameField, 'Alice');
    // Need to call saveAndValidate
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();

    expect(nextCalled, isTrue);
    expect(formData['name'], 'Alice');
  });

  testWidgets('MULTIPLE CHOICE question shows radio buttons and saves choice',
      (WidgetTester tester) async {
    final formData = <String, dynamic>{};
    var nextCalled = false;

    final questions = [
      {
        'q': 'Pick one',
        'key': 'choice',
        'type': 'multipleChoice',
        'required': true,
        'options': ['A', 'B', 'C'],
      },
    ];

    await tester.pumpWidget(makeTestable(
      formData: formData,
      questions: questions,
      questionIndex: 0,
      onNext: () => nextCalled = true,
    ));

    expect(find.text('Pick one'), findsOneWidget);
    // There should be three radio options
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);

    // Try Next without selecting: blocked
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pump();
    expect(nextCalled, isFalse);

    // Select "B"
    await tester.tap(find.text('B'));
    await tester.pump();

    // Now Next should work
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();
    expect(nextCalled, isTrue);
    expect(formData['choice'], 'B');
  });

  testWidgets('CHECKBOX question shows checkboxes and saves list',
      (WidgetTester tester) async {
    final formData = <String, dynamic>{};
    var nextCalled = false;

    final questions = [
      {
        'q': 'Select multiple',
        'key': 'checks',
        'type': 'checkbox',
        'required': true,
        'options': ['X', 'Y', 'Z'],
      },
    ];

    await tester.pumpWidget(makeTestable(
      formData: formData,
      questions: questions,
      questionIndex: 0,
      onNext: () => nextCalled = true,
    ));

    expect(find.text('Select multiple'), findsOneWidget);
    // Checkboxes labeled X, Y, Z
    expect(find.text('X'), findsOneWidget);
    expect(find.text('Y'), findsOneWidget);
    expect(find.text('Z'), findsOneWidget);

    // Next blocked if nothing checked
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pump();
    expect(nextCalled, isFalse);

    // Tap X and Z
    await tester.tap(find.text('X'));
    await tester.pump();
    await tester.tap(find.text('Z'));
    await tester.pump();

    // Now Next works
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();
    expect(nextCalled, isTrue);
    // The formBuilder saves a List<String>
    expect(formData['checks'], ['X', 'Z']);
  });

  testWidgets('COMPOSITE ADDRESS question shows all sub-fields and saves them',
      (WidgetTester tester) async {
    final formData = <String, dynamic>{};
    var nextCalled = false;

    final questions = [
      {
        'q': 'Address',
        'key': 'addressGroup',
        'type': 'compositeAddress',
        'required': true,
      },
    ];

    await tester.pumpWidget(makeTestable(
      formData: formData,
      questions: questions,
      questionIndex: 0,
      onNext: () => nextCalled = true,
    ));

    // Should see the prompt
    expect(find.text('Address'), findsOneWidget);

    // The composite fields use fixed ValueKeys:
    final firstNameField = find.byKey(const ValueKey('firstName'));
    final lastNameField = find.byKey(const ValueKey('lastName'));
    final street1Field = find.byKey(const ValueKey('streetAddress1'));
    final cityField = find.byKey(const ValueKey('city'));
    final stateField = find.byKey(const ValueKey('state'));
    final zipField = find.byKey(const ValueKey('zipCode'));

    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);
    expect(street1Field, findsOneWidget);
    expect(cityField, findsOneWidget);
    expect(stateField, findsOneWidget);
    expect(zipField, findsOneWidget);

    // Fill them out
    await tester.enterText(firstNameField, 'John');
    await tester.enterText(lastNameField, 'Appleseed');
    await tester.enterText(street1Field, '42 Orchard Rd');
    await tester.enterText(cityField, 'Fruitville');

    // For dropdown we need to open it then select
    await tester.tap(find.byKey(const ValueKey('state')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CA').last);
    await tester.pumpAndSettle();

    await tester.enterText(zipField, '90210');

    // Now Next
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();

    expect(nextCalled, isTrue);
    // All fields should be merged into formData
    expect(formData['firstName'], 'John');
    expect(formData['lastName'], 'Appleseed');
    expect(formData['streetAddress1'], '42 Orchard Rd');
    expect(formData['city'], 'Fruitville');
    expect(formData['state'], 'CA');
    expect(formData['zipCode'], '90210');
  });

  testWidgets('button text shows "Back to Confirmation" when returnToConfirmation is true',
      (WidgetTester tester) async {
    final formData = <String, dynamic>{};
    var nextCalled = false;

    final questions = [
      {
        'q': 'Enter',
        'key': 'dummy',
        'type': 'text',
        'required': false,
      },
    ];

    await tester.pumpWidget(makeTestable(
      formData: formData,
      questions: questions,
      questionIndex: 0,
      onNext: () => nextCalled = true,
      returnToConfirmation: true,
    ));

    expect(find.widgetWithText(ElevatedButton, 'Back to Confirmation'),
        findsOneWidget);
  });
}
