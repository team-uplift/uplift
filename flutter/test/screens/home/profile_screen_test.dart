// test/screens/profile_page_test.dart
// Widget tests for ProfilePage navigation

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/screens/home/profile_screen.dart';
import 'package:uplift/components/settings_card.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          name: '/personal_info',
          path: '/personal_info',
          builder: (context, state) => const Scaffold(body: Text('Personal Info Page')),
        ),
        GoRoute(
          name: '/account_settings',
          path: '/account_settings',
          builder: (context, state) => const Scaffold(body: Text('Account Settings Page')),
        ),
      ],
    );
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders hero section and settings cards', (tester) async {
    await pumpApp(tester);

    // Hero texts
    expect(find.text('Your Profile'), findsOneWidget);
    expect(find.text('Manage your account settings and preferences'), findsOneWidget);

    // Settings cards present
    expect(find.byType(SettingsCard), findsNWidgets(2));
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Account Settings'), findsOneWidget);
  });

  testWidgets('tapping Personal Information navigates', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Personal Information'));
    await tester.pumpAndSettle();

    expect(find.text('Personal Info Page'), findsOneWidget);
  });

  testWidgets('tapping Account Settings navigates', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Account Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Account Settings Page'), findsOneWidget);
  });
}
