// test/screens/home/topic_screen_test.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/screens/home/topic_screen.dart';
import 'package:uplift/components/topic_module.dart';
import 'package:uplift/components/standard_button.dart';

/// Prevent real HTTP calls so NetworkImage won’t break tests.
class _NoOpHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? c) {
    return super.createHttpClient(c)
      // accept everything
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _NoOpHttpOverrides();
  });

  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const TopicPage()),
        GoRoute(
          name: '/question',
          path: '/question',
          builder: (_, __) => const Scaffold(body: Center(child: Text('Question Page'))),
        ),
      ],
    );
  });

  Future<void> _pump(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );
    // give a small frame for ListView to build
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('builds exactly 4 TopicModule widgets',
      (tester) async {
    await _pump(tester);

    // We don’t rely on their inner images/text – just count them
    expect(find.byType(TopicModule), findsNWidgets(4));
  });

  testWidgets('builds a single Generate Quiz StandardButton',
      (tester) async {
    await _pump(tester);

    final buttons = find.byType(StandardButton);
    expect(buttons, findsOneWidget);
  });
}
