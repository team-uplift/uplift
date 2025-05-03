// test/services/income_verification_service_test.dart
// Widget tests for IncomeVerificationService.pickImageSource

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/services/income_verification_service.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:image_picker/image_picker.dart';

/// A dummy RecipientApi since pickImageSource doesn't use it
class FakeApi extends RecipientApi {}

void main() {
  late IncomeVerificationService service;

  setUp(() {
    service = IncomeVerificationService(FakeApi());
  });

  testWidgets('pickImageSource returns camera when tapped', (tester) async {
    ImageSource? selected;

    // Pump a widget that calls pickImageSource on a button tap
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (ctx) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  service.pickImageSource(ctx).then((result) {
                    selected = result;
                  });
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    // Tap to open bottom sheet
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Should show two options
    expect(find.text('Take Photo'), findsOneWidget);
    expect(find.text('Choose from Gallery'), findsOneWidget);

    // Tap 'Take Photo'
    await tester.tap(find.text('Take Photo'));
    await tester.pumpAndSettle();

    // Verify result
    expect(selected, ImageSource.camera);
  });

  testWidgets('pickImageSource returns gallery when tapped', (tester) async {
    ImageSource? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (ctx) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  service.pickImageSource(ctx).then((result) {
                    selected = result;
                  });
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Tap 'Choose from Gallery'
    await tester.tap(find.text('Choose from Gallery'));
    await tester.pumpAndSettle();

    expect(selected, ImageSource.gallery);
  });
}
