// test/api/recipient_api_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/donation_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  const baseUrl = AppConfig.baseUrl;
  late MockClient mockClient;
  late RecipientApi api;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockClient();
    api = RecipientApi(client: mockClient);
  });

  group('createRecipientUser', () {
    final formData = {
      'firstName': 'Jane',
      'lastName': 'Doe',
      'streetAddress1': '123 Main St',
      'streetAddress2': 'Apt 4',
      'city': 'Testville',
      'state': 'TS',
      'zipCode': '12345',
      'lastAboutMe': 'Hello!',
      'lastReasonForHelp': 'Need help',
    };
    final formQuestions = [
      {'question': 'Q1', 'answer': 'A1'}
    ];
    final attrMap = {'sub': 'abc', 'email': 'jane@doe.com'};

    test('returns id on 200', () async {
      final responseJson = {'id': 99};
      when(() => mockClient.post(
            Uri.parse('$baseUrl/users'),
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(jsonEncode(responseJson), 200),
      );

      final id =
          await api.createRecipientUser(formData, formQuestions, attrMap);
      expect(id, equals(99));
    });

    test('returns id on 201', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 42}), 201));

      final id = await api.createRecipientUser({}, [], {});
      expect(id, equals(42));
    });

    test('returns null on error status', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('fail', 500));

      final id = await api.createRecipientUser({}, [], {});
      expect(id, isNull);
    });

    test('returns null on exception', () async {
      when(() => mockClient.post(any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenThrow(Exception('network'));

      final id = await api.createRecipientUser({}, [], {});
      expect(id, isNull);
    });
  });

  group('updateTags', () {
    test('returns true on 204', () async {
      when(() => mockClient.put(
            Uri.parse('$baseUrl/recipients/tagSelection/7'),
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('', 204));

      final ok = await api.updateTags(7, ['t1', 't2']);
      expect(ok, isTrue);
    });

    test('returns false on non-204', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 400));

      final ok = await api.updateTags(7, []);
      expect(ok, isFalse);
    });

    test('returns false on exception', () async {
      when(() => mockClient.put(any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenThrow(Exception());

      final ok = await api.updateTags(7, []);
      expect(ok, isFalse);
    });
  });

  group('fetchDonationsForRecipient', () {
    test('parses list on 200 and message is empty', () async {
      final donationsJson = [
        {
          'id': 1,
          'createdAt': '2025-04-21T10:00:00Z',
          'donor': {'nickname': 'X'},
          'amount': 1500
        }
      ];
      when(() => mockClient.get(
                Uri.parse('$baseUrl/donations/recipient/5'),
                headers: {'Content-Type': 'application/json'},
              ))
          .thenAnswer(
              (_) async => http.Response(jsonEncode(donationsJson), 200));

      final result = await api.fetchDonationsForRecipient(5);
      final donations = result.$1;
      final message = result.$2;

      expect(donations, hasLength(1));
      expect(donations.first.donorName, 'X');
      expect(message, isEmpty); // <— now we assert it's the empty string
    });

    test('returns empty list and fixed error message on non-200', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('not found', 404));

      final result = await api.fetchDonationsForRecipient(5);
      expect(result.$1, isEmpty);
      expect(result.$2, equals('Failed to fetch donations.'));
    });

    test('returns empty list and exception message on exception', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenThrow(Exception('oops'));

      final result = await api.fetchDonationsForRecipient(5);
      expect(result.$1, isEmpty);
      expect(result.$2, equals('Error fetching donations.'));
    });
  });

  group('fetchDonationById', () {
    test('parses donation on 200', () async {
      final donationJson = {
        'id': 2,
        'createdAt': '2025-04-21T10:00:00Z',
        'donor': {'nickname': 'Y'},
        'amount': 2000
      };
      when(() => mockClient.get(
                Uri.parse('$baseUrl/donations/2'),
                headers: {'Content-Type': 'application/json'},
              ))
          .thenAnswer(
              (_) async => http.Response(jsonEncode(donationJson), 200));

      final d = await api.fetchDonationById(2);
      expect(d, isNotNull);
      expect(d!.id, equals(2));
    });

    test('returns null on exception', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenThrow(Exception());

      final d = await api.fetchDonationById(2);
      expect(d, isNull);
    });
  });

  group('sendThankYouMessage', () {
    test('returns Donation on 200/201', () async {
      final resJson = {
        'id': 3,
        'createdAt': '2025-04-21T10:00:00Z',
        'donor': {'nickname': 'Z'},
        'amount': 3000
      };
      when(() => mockClient.post(
            Uri.parse('$baseUrl/messages'),
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(jsonEncode(resJson), 201));

      final d = await api.sendThankYouMessage(donationId: 3, message: 'thanks');
      expect(d, isNotNull);
      expect(d!.donorName, equals('Z'));
    });

    test('returns null on non-200/201', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 400));

      final d = await api.sendThankYouMessage(donationId: 3, message: 'x');
      expect(d, isNull);
    });

    test('returns null on exception', () async {
      when(() => mockClient.post(any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenThrow(Exception());

      final d = await api.sendThankYouMessage(donationId: 3, message: 'x');
      expect(d, isNull);
    });
  });

  group('updateRecipientUserProfile', () {
    final formData = {
      'userId': 5,
      'firstName': 'F',
      'lastName': 'L',
      'streetAddress1': 'S1',
      'streetAddress2': 'S2',
      'city': 'C',
      'state': 'ST',
      'zipCode': 'Z',
      'lastAboutMe': 'A',
      'lastReasonForHelp': 'R',
    };
    final formQuestions = [
      {'question': 'Q', 'answer': 'A'}
    ];
    final attrMap = {'sub': 'u5', 'email': 'u5@x.com'};

    test('returns true on 200', () async {
      when(() => mockClient.put(
            Uri.parse('$baseUrl/users'),
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('', 200));

      final ok = await api.updateRecipientUserProfile(
          formData, formQuestions, attrMap);
      expect(ok, isTrue);
    });

    test('returns false on exception', () async {
      when(() => mockClient.put(any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenThrow(Exception());

      final ok = await api.updateRecipientUserProfile(
          formData, formQuestions, attrMap);
      expect(ok, isFalse);
    });
  });
}
