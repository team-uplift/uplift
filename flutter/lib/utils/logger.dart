// logger.dart
import 'package:logging/logging.dart';

final Logger log = Logger('UpLift');

void setupLogging() {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String();
    final msg = '[${record.level.name}] $time (${record.loggerName}): ${record.message}';
    
    // You could forward this to a cloud logging tool here
    print(msg);

    // Optionally: Forward to a file, Crashlytics, or backend
    // e.g. if (record.level >= Level.SEVERE) sendToCrashlytics(record);
  });
}
