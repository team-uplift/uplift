// test/unit/donor_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/models/donor_model.dart';

void main() {
  group('Donor Model', () {
    test('fromJson creates correct Donor instance', () {
      final json = {
        'id': 1,
        'nickname': 'Donor1',
        'createdAt': '2025-04-21T12:34:56.000Z',
      };

      final donor = Donor.fromJson(json);

      expect(donor.id, 1);
      expect(donor.nickname, 'Donor1');
      expect(donor.createdAt, DateTime.parse('2025-04-21T12:34:56.000Z'));
    });

    test('fromJson throws if createdAt is invalid', () {
      final badJson = {
        'id': 2,
        'nickname': 'Donor2',
        'createdAt': 'not-a-date',
      };
      expect(() => Donor.fromJson(badJson), throwsA(isA<FormatException>()));
    });

    test('toJson returns correct map', () {
      final donor = Donor(
        id: 2,
        nickname: 'TestDonor',
        createdAt: DateTime.parse('2025-04-21T12:34:56.000Z'),
      );

      final json = donor.toJson();

      expect(json['id'], 2);
      expect(json['nickname'], 'TestDonor');
      expect(json['createdAt'], '2025-04-21T12:34:56.000Z');
    });

    test('toString contains all fields', () {
      final dt = DateTime.parse('2025-04-21T12:34:56.000Z');
      final donor = Donor(id: 3, nickname: 'D3', createdAt: dt);

      final str = donor.toString();
      expect(str, contains('id: 3'));
      expect(str, contains('nickname: D3'));
      expect(str, contains('createdAt: $dt'));
    });
  });
}
