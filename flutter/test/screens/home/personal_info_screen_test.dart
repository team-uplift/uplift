import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/screens/home/personal_info.dart';

void main() {
  testWidgets('PersonalInfoScreen shows basic UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PersonalInfoScreen(
            mockUserData: {
              'name': 'Test User',
              'email': 'test@example.com',
              'phone': '123-456-7890',
            },
          ),
        ),
      ),
    );

    // Verify basic UI elements are present
    expect(find.text('Personal Info'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('PersonalInfoScreen handles email input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PersonalInfoScreen(
            mockUserData: {
              'name': 'Test User',
              'email': 'test@example.com',
              'phone': '123-456-7890',
            },
          ),
        ),
      ),
    );

    // Find and interact with the email field
    final emailField = find.byType(TextFormField);
    await tester.enterText(emailField, 'new@example.com');
    await tester.pump();

    // Verify the text was entered
    expect(find.text('new@example.com'), findsOneWidget);
  });
}
