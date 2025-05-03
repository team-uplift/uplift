import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/screens/home/donor_tag_screen.dart';
import 'package:uplift/models/donor_tag_model.dart';
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
    // Set up default response for any GET request
    when(() => mockHttpClient.get(any())).thenAnswer((_) async => http.Response(
          '[{"tagName": "Education"}, {"tagName": "Healthcare"}, {"tagName": "Environment"}]',
          200,
        ));
  });

  tearDown(() {
    reset(mockHttpClient);
  });

  final mockQuestionsAnswers = [
    {
      'question': 'What is your name?',
      'answer': 'John Doe',
    },
    {
      'question': 'What causes do you care about?',
      'answer': '',
    },
  ];

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: DonorTagPage(
          questionsAnswers: mockQuestionsAnswers,
          httpClient: mockHttpClient,
        ),
      ),
    );
  }

  testWidgets('DonorTagPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Initial loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the HTTP request to complete and UI to update
    await tester.pumpAndSettle();

    // Verify basic UI elements
    expect(find.text('Select Causes'), findsOneWidget);
    expect(find.text('Choose What Matters to You'), findsOneWidget);
    expect(
      find.text(
          'Select the causes you care about to find recipients who need your help'),
      findsOneWidget,
    );
    expect(find.text('Available Causes'), findsOneWidget);
    expect(find.text('Find Recipients'), findsOneWidget);
  });

  testWidgets('DonorTagPage handles tag selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Wait for the HTTP request to complete and UI to update
    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.text('Education'), findsOneWidget);
    expect(find.text('Healthcare'), findsOneWidget);
    expect(find.text('Environment'), findsOneWidget);

    // Select a tag
    await tester.tap(find.text('Education'));
    await tester.pumpAndSettle();

    // Try to proceed without selecting any tags
    await tester.tap(find.text('Find Recipients'));
    await tester.pumpAndSettle();

    // Verify error message
    expect(find.text('Please select at least one tag'), findsOneWidget);
  });

  testWidgets('DonorTagPage shows loading indicator',
      (WidgetTester tester) async {
    // Mock the HTTP response with a delay
    when(() => mockHttpClient.get(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return http.Response(
        '[{"tagName": "Education"}, {"tagName": "Healthcare"}, {"tagName": "Environment"}]',
        200,
      );
    });

    await tester.pumpWidget(createWidgetUnderTest());

    // Initial loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the HTTP request to complete and UI to update
    await tester.pumpAndSettle();

    // Loading indicator should be gone after initial load
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
