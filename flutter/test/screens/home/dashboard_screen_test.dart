import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uplift/screens/home/dashboard_screen.dart';
import 'package:uplift/components/donation_card.dart';
import 'package:uplift/providers/donation_notifier_provider.dart';

class MockDonationNotifier extends StateNotifier<List<Donation>>
    implements DonationNotifier {
  MockDonationNotifier() : super([]);

  @override
  Future<void> fetchDonations() async {
    // No-op implementation for testing
  }
}

void main() {
  late MockDonationNotifier mockDonationNotifier;
  late ProviderContainer container;

  setUp(() {
    mockDonationNotifier = MockDonationNotifier();
    container = ProviderContainer(
      overrides: [
        donationNotifierProvider.overrideWithProvider(
          StateNotifierProvider<DonationNotifier, List<Donation>>(
            (ref) => mockDonationNotifier,
          ),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('DashboardPage renders basic UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: Scaffold(
            body: DashboardPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify basic UI elements
    expect(find.text('Your Impact'), findsOneWidget);
    expect(find.text('Total Impact'), findsOneWidget);
    expect(find.text('Donation History'), findsOneWidget);
    expect(find.text('View All'), findsOneWidget);
  });

  testWidgets('DashboardPage shows empty state UI',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: Scaffold(
            body: DashboardPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify empty state UI elements
    expect(find.byIcon(Icons.volunteer_activism_outlined), findsOneWidget);
    expect(find.text('No donations yet'), findsOneWidget);
    expect(
      find.text('Start making a difference by helping someone in need'),
      findsOneWidget,
    );
  });
}
