import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/models/recipient_model.dart';

void main() {
  group('Recipient Model', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 10,
        'firstName': 'Jane',
        'lastName': 'Doe',
        'city': 'Springfield',
        'createdAt': '2025-04-21T12:34:56.000Z',
        'formQuestions': [],
        'recipientData': {
          'id': 10,
          'firstName': 'Jane',
          'lastName': 'Doe',
          'nickname': 'JD',
          'createdAt': '2025-04-21T12:34:56.000Z',
          'incomeLastVerified': '2025-04-20T10:00:00.000Z',
        }
      };

      final recipient = Recipient.fromJson(json);

      expect(recipient.id, 10);
      expect(recipient.firstName, 'Jane');
      expect(recipient.lastName, 'Doe');
      expect(recipient.nickname, 'JD');
      expect(recipient.createdAt, DateTime.parse('2025-04-21T12:34:56.000Z'));
      expect(recipient.incomeLastVerified, DateTime.parse('2025-04-20T10:00:00.000Z'));
    });

    test('toJson returns expected map', () {
      final recipient = Recipient(
        id: 11,
        firstName: 'John',
        lastName: 'Smith',
        city: 'Metropolis',
        createdAt: DateTime.parse('2025-04-21T12:00:00.000Z'),
        formQuestions: [],
      );

      final json = recipient.toJson();

      expect(json['id'], 11);
      expect(json['firstName'], 'John');
      expect(json['lastName'], 'Smith');
      expect(json['city'], 'Metropolis');
      expect(json['createdAt'], '2025-04-21T12:00:00.000Z');
    });
  });
}
