// test/models/donor_badge_test.dart
// Tests for DonorBadge model and allBadges list

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/models/badge.dart';

void main() {
  group('DonorBadge model', () {
    test('constructor assigns all fields correctly', () {
      final badge = DonorBadge(
        id: 'test',
        name: 'Test Badge',
        description: 'Test description',
        icon: Icons.star,
        requiredDonations: 10,
        isUnlocked: true,
      );

      expect(badge.id, equals('test'));
      expect(badge.name, equals('Test Badge'));
      expect(badge.description, equals('Test description'));
      expect(badge.icon, equals(Icons.star));
      expect(badge.requiredDonations, equals(10));
      expect(badge.isUnlocked, isTrue);
    });

    test('isUnlocked defaults to false when not specified', () {
      final badge = DonorBadge(
        id: 'default',
        name: 'Default Badge',
        description: 'Default description',
        icon: Icons.star_border,
        requiredDonations: 1,
      );

      expect(badge.isUnlocked, isFalse);
    });
  });

  group('allBadges list', () {
    test('contains exactly four badges', () {
      expect(allBadges.length, equals(4));
    });

    test('each badge has correct properties and default state', () {
      final expectedData = [
        {'id': 'bronze',   'name': 'Bronze Donor',   'desc': 'Made 5 donations',   'req': 5},
        {'id': 'silver',   'name': 'Silver Donor',   'desc': 'Made 25 donations',  'req': 25},
        {'id': 'gold',     'name': 'Gold Donor',     'desc': 'Made 50 donations',  'req': 50},
        {'id': 'platinum', 'name': 'Platinum Donor', 'desc': 'Made 100 donations', 'req': 100},
      ];

      for (var i = 0; i < expectedData.length; i++) {
        final badge = allBadges[i];
        final exp = expectedData[i];

        expect(badge.id, equals(exp['id']));
        expect(badge.name, equals(exp['name']));
        expect(badge.description, equals(exp['desc']));
        expect(badge.icon, equals(Icons.workspace_premium));
        expect(badge.requiredDonations, equals(exp['req']));
        expect(badge.isUnlocked, isFalse);
      }
    });
  });
}
