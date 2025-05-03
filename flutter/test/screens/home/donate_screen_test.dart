import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uplift/screens/home/donate_screen.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/transaction_model.dart';
import 'package:uplift/providers/transaction_notifier_provider.dart';

void main() {
  late Recipient mockRecipient;
  late ProviderContainer container;

  setUp(() {
    mockRecipient = Recipient(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      nickname: 'Johnny',
    );

    container = ProviderContainer(
      overrides: [
        transactionNotifierProvider.overrideWithProvider(
          StateNotifierProvider<TransactionNotifier, List<Transaction>>(
            (ref) => TransactionNotifier(),
          ),
        ),
      ],
    );

    // Set up image loading
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async => null);
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('DonatePage renders basic UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Scaffold(
              body: SafeArea(
                child: SizedBox(
                  width: 800,
                  height: 600,
                  child: DonatePage(recipient: mockRecipient),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify basic UI elements
    expect(find.text('Make a Donation'), findsOneWidget);
    expect(find.text('Support Someone in Need'), findsOneWidget);
    expect(find.text("You're donating to John"), findsOneWidget);
    expect(find.text('Donation Amount'), findsOneWidget);
    expect(find.text('Enter the amount you\'d like to donate'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('DonatePage handles amount input', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Scaffold(
              body: SafeArea(
                child: SizedBox(
                  width: 800,
                  height: 600,
                  child: DonatePage(recipient: mockRecipient),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find the TextField
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // Enter a valid amount
    await tester.enterText(textField, '50');
    await tester.pumpAndSettle();

    // Verify the amount is displayed in the TextField
    expect(find.text('50'), findsOneWidget);

    // Enter an invalid amount (letters)
    await tester.enterText(textField, 'abc');
    await tester.pumpAndSettle();

    // Verify only numbers are accepted
    expect(find.text(''), findsOneWidget);
  });
}
