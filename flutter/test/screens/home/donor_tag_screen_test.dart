import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/screens/home/donor_tag_screen.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
          '[{"tagName": "Education"}, {"tagName": "Healthcare"}, {"tagName": "Environment"}]',
          200,
        ));
  });

  tearDown(() {
    reset(mockHttpClient);
  });

  final questionsAnswers = [
    {'question': 'What is your name?', 'answer': 'John Doe'},
    {'question': 'What causes do you care about?', 'answer': ''},
  ];

  Widget makeTestable() {
    return MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: DonorTagPage(
          questionsAnswers: questionsAnswers,
          httpClient: mockHttpClient,
        ),
      ),
    );
  }

  testWidgets('renders headers, legend, tags and a StandardButton', (tester) async {
    await tester.pumpWidget(makeTestable());

    // initial loading indicator(s)
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    // finish loading
    await tester.pumpAndSettle();

    // headers
    expect(find.text('Select Causes'), findsOneWidget);
    expect(find.text('Choose What Matters to You'), findsOneWidget);

    // legend title
    expect(find.textContaining('Available Causes'), findsOneWidget);

    // tags
    expect(find.text('Education'), findsOneWidget);
    expect(find.text('Healthcare'), findsOneWidget);
    expect(find.text('Environment'), findsOneWidget);

    // at least one StandardButton
    expect(find.byType(StandardButton), findsOneWidget);
  });

  testWidgets('tapping without selection shows error', (tester) async {
    await tester.pumpWidget(makeTestable());
    await tester.pumpAndSettle();

    // tap the button
    await tester.tap(find.byType(StandardButton));
    await tester.pumpAndSettle();

    expect(find.text('Please select at least one tag'), findsOneWidget);
  });

  testWidgets('tapping after selecting one tag proceeds without error', (tester) async {
    await tester.pumpWidget(makeTestable());
    await tester.pumpAndSettle();

    // select a tag
    await tester.tap(find.text('Education'));
    await tester.pumpAndSettle();

    // tap the button
    await tester.tap(find.byType(StandardButton));
    await tester.pumpAndSettle();

    // error should be gone
    expect(find.text('Please select at least one tag'), findsNothing);
  });

  testWidgets('loading indicator remains until tags arrive', (tester) async {
    // delay the response a little
    when(() => mockHttpClient.get(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 50));
      return http.Response(
        '[{"tagName": "Education"}]',
        200,
      );
    });

    await tester.pumpWidget(makeTestable());

    // spinner shows immediately
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    // after the delay
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpAndSettle();

    // spinner should go away
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // and the single tag appears
    expect(find.text('Education'), findsOneWidget);
  });
}
