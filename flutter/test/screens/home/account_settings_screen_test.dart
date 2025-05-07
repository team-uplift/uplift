// test/widget/account_settings_screen_smoke_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/components/settings_card.dart';
import 'package:uplift/screens/home/account_settings_screen.dart';

void main() {
  testWidgets('AccountSettingsScreen renders basic UI elements',
      (tester) async {
    // Pump the screen inside a MaterialApp so AppBar and Theme work
    await tester.pumpWidget(
      MaterialApp(
        home: AccountSettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // There are two "Account Settings" labels: AppBar & hero section
    expect(find.text('Account Settings'), findsNWidgets(2));

    // Hero subtitle
    expect(
      find.text('Manage your account preferences and security'),
      findsOneWidget,
    );

    // The two SettingsCards
    expect(find.byType(SettingsCard), findsNWidgets(2));
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Delete Account'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });
}
