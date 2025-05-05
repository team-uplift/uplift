// test/unit/recipient_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/tag_model.dart';

void main() {
  group('Recipient.fromJson', () {
    test('parses nested recipientData and simple fields', () {
      final json = {
        'id': 10,
        'firstName': 'Jane',
        'lastName': 'Doe',
        'city': 'Springfield',
        'formQuestions': [],
        'recipientData': {
          'id': 10,
          'firstName': 'Jane',
          'lastName': 'Doe',
          'nickname': 'JD',
          'createdAt': '2025-04-21T12:34:56.000Z',
          'incomeLastVerified': '2025-04-20T10:00:00.000Z',
        },
        'identityLastVerified': '2025-04-19T09:00:00.000Z',
        'lastDonationTimestamp': '2025-04-22T08:00:00.000Z',
        'tagsLastGenerated': '2025-04-23T07:00:00.000Z',
        'tags': [
          {
            'tagName': 't1',
            'weight': 0.5,
            'createdAt': '2025-04-18T06:00:00.000Z',
            'addedAt': '2025-04-18T06:00:00.000Z',
          }
        ],
      };

      final r = Recipient.fromJson(json);

      expect(r.id, 10);
      expect(r.firstName, 'Jane');
      expect(r.lastName, 'Doe');
      expect(r.nickname, 'JD');
      expect(r.city, 'Springfield');
      // Date fields
      expect(r.identityLastVerified,
          DateTime.parse('2025-04-19T09:00:00.000Z'));
      expect(r.incomeLastVerified,
          DateTime.parse('2025-04-20T10:00:00.000Z'));
      expect(r.lastDonationTimestamp,
          DateTime.parse('2025-04-22T08:00:00.000Z'));
      expect(r.tagsLastGenerated,
          DateTime.parse('2025-04-23T07:00:00.000Z'));
      // Tags parsing
      expect(r.tags, isNotNull);
      expect(r.tags!.first.tagName, 't1');
      expect(r.tags!.first.weight, 0.5);
    });

    test('when no name or nickname are in the JSON, firstName stays null', () {
      final json = {'id': 5};
      final r = Recipient.fromJson(json);
      expect(r.firstName, isNull);
      expect(r.lastName,  isNull);
      expect(r.nickname,  isNull);
    });

  });

  group('Recipient.toJson', () {
    test('includes all fields with correct keys', () {
      final dt1 = DateTime.parse('2025-05-01T00:00:00.000Z');
      final dt2 = DateTime.parse('2025-05-02T00:00:00.000Z');
      final r = Recipient(
        id: 11,
        firstName: 'John',
        lastName: 'Smith',
        streetAddress1: '123 St',
        streetAddress2: 'Apt 4',
        city: 'Metro',
        state: 'ST',
        zipCode: '12345',
        lastAboutMe: 'About',
        lastReasonForHelp: 'Need',
        formQuestions: [ {'question': 'Q', 'answer': 'A'} ],
        identityLastVerified: dt1,
        incomeLastVerified: dt2,
        nickname: 'JS',
        createdAt: dt2,
        imageURL: 'http://img',
        lastDonationTimestamp: dt1,
        tags: [Tag(createdAt: dt1, tagName: 'x', weight: 1.0, addedAt: dt1)],
        tagsLastGenerated: dt2,
      );

      final m = r.toJson();
      expect(m['id'], 11);
      expect(m['firstName'], 'John');
      expect(m['lastName'], 'Smith');
      expect(m['streetAddress1'], '123 St');
      expect(m['streetAddress2'], 'Apt 4');
      expect(m['city'], 'Metro');
      expect(m['state'], 'ST');
      expect(m['zip_code'], '12345');
      expect(m['last_about_me'], 'About');
      expect(m['last_reason_for_help'], 'Need');
      expect(m['formQuestions'], isA<List< Map<String, dynamic> >>());
      expect(m['identity_last_verified'], dt1.toIso8601String());
      expect(m['income_last_verified'], dt2.toIso8601String());
      expect(m['nickname'], 'JS');
      expect(m['createdAt'], dt2.toIso8601String());
      expect(m['imageURL'], 'http://img');
      // Note: toJson does not include tags, lastDonationTimestamp, tagsLastGenerated
    });
  });

  group('toString and copyWith', () {
    test('toString shows id, firstName, lastName, nickname', () {
      final r = Recipient(id: 7, firstName: 'A', lastName: 'B', nickname: null);
      expect(r.toString(),
          'Recipient(id: 7, firstName: A, lastName: B, nickname: null)');
    });

    test('copyWith updates provided fields', () {
      final original = Recipient(
        id: 1,
        firstName: 'X',
        lastName: 'Y',
        streetAddress1: 'S1',
        formQuestions: [],
      );
      final copy = original.copyWith(
        firstName: 'Z',
        city: 'NewCity',
        formQuestions: [ {'question': 'Q','answer':'A'} ],
      );
      expect(copy.id, 1);
      expect(copy.firstName, 'Z');
      expect(copy.lastName, 'Y');
      expect(copy.city, 'NewCity');
      expect(copy.formQuestions, isNotEmpty);
    });
  });
}
