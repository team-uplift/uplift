// test/utils/logger_test.dart

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/utils/logger.dart';
import 'package:logging/logging.dart';

void main() {
  group('logger setup', () {
    test('setupLogging captures and prints INFO and above', () {
      final printed = <String>[];
      // Intercept all calls to print()
      final spec = ZoneSpecification(
        print: (_, __, ___, String line) {
          printed.add(line);
        },
      );

      // Run in a custom zone so our print override applies
      return Zone.current.fork(specification: spec).run(() {
        // Initialize logging
        setupLogging();

        // Emit messages at various levels
        log.finest('finest');    // below Level.ALL? should still print
        log.info('information');
        log.warning('warn');
        log.severe('error');

        // We expect at least the INFO/WARNING/SEVERE messages to be printed
        // The exact timestamp will vary, so just assert the message substrings
        expect(
          printed.any((line) => line.contains('[INFO]') && line.contains('(UpLift): information')),
          isTrue,
        );
        expect(
          printed.any((line) => line.contains('[WARNING]') && line.contains('(UpLift): warn')),
          isTrue,
        );
        expect(
          printed.any((line) => line.contains('[SEVERE]') && line.contains('(UpLift): error')),
          isTrue,
        );
      });
    });
  });
}
