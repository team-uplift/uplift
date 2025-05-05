// test/unit/recipient_settings_helpers_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/utils/recipient_settings_helpers.dart';

void main() {
  test('formatDuration pads single digits', () {
    final d = Duration(hours: 2, minutes: 3, seconds: 4);
    final s = RecipientSettingsHelpers.formatDuration(d);
    expect(s, '02h 03m 04s');
  });

  test('computeTimeRemaining yields zero if past 24h', () {
  final t0  = DateTime(2025, 5, 2, 12, 0, 0);
  final now = t0.add(const Duration(hours: 25));
  final rem = RecipientSettingsHelpers.computeTimeRemaining(t0, now: now);
  expect(rem, Duration.zero);
});

  test('computeTimeRemaining counts down correctly if under 24h', () {
    final t0  = DateTime(2025, 5, 3, 12, 0, 0);
    final now = t0.add(const Duration(hours: 3, minutes: 30));
    final rem = RecipientSettingsHelpers.computeTimeRemaining(t0, now: now);
    expect(rem, const Duration(hours: 20, minutes: 30));
  });


  test('rebuildFormDataFromRecipient maps basics and custom questions', () {
    final user = User(
      id: 99,
      cognitoId: '',
      email: '',
      recipient: true,
      recipientData: null,
      donorData: null,
      createdAt: null,
    );
    final recipient = Recipient(
      id: 2,
      firstName: 'Alice',
      lastName: 'Smith',
      streetAddress1: '',
      streetAddress2: '',
      city: '',
      state: '',
      zipCode: '',
      lastAboutMe: '',
      lastReasonForHelp: '',
      formQuestions: [
        {'question': 'Foo?', 'answer': 'bar'}
      ],
      identityLastVerified: null,
      incomeLastVerified: null,
      nickname: null,
      createdAt: null,
      imageURL: null,
      lastDonationTimestamp: null,
      tags: [],
      tagsLastGenerated: null,
    );
    final regQs = <Map<String, Object?>>[
      <String, Object?>{'q': 'Foo?', 'key': 'fooAnswer', 'type': 'text'},
    ];
    final m = RecipientSettingsHelpers
        .rebuildFormDataFromRecipient(user, recipient, regQs);

    expect(m['userId'], 99);
    expect(m['firstName'], 'Alice');
    expect(m['fooAnswer'], 'bar');
  });

  test('buildNameAddressData returns correct fullName, address, email', () {
    final user = User(
      id: 1,
      cognitoId: 'cid',
      email: 'test@example.com',
      recipient: true,
      recipientData: null,
      donorData: null,
      createdAt: null,
    );
    final recipient = Recipient(
      id: 3,
      firstName: 'Jane',
      lastName: 'Doe',
      streetAddress1: '123 Main St',
      streetAddress2: 'Apt 4B',
      city: 'Springfield',
      state: 'IL',
      zipCode: '62704',
      lastAboutMe: '',
      lastReasonForHelp: '',
      formQuestions: null,
      identityLastVerified: null,
      incomeLastVerified: null,
      nickname: null,
      createdAt: null,
      imageURL: null,
      lastDonationTimestamp: null,
      tags: [],
      tagsLastGenerated: null,
    );

    final m = RecipientSettingsHelpers.buildNameAddressData(
      profile: user,
      recipient: recipient,
    );

    expect(m['fullName'], 'Jane Doe');
    expect(
      m['address'],
      '123 Main St\nApt 4B\nSpringfield, IL 62704',
    );
    expect(m['email'], 'test@example.com');
  });
}
