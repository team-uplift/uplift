// test/api/user_api_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:uplift/api/user_api.dart';
import 'package:uplift/models/donor_model.dart';
import 'package:uplift/models/user_model.dart';
import 'package:uplift/models/recipient_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;
  late UserApi api;

  setUpAll(() {
    // In case any named parameters need fallback values
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockClient();
    api = UserApi(client: mockClient);
  });

  group('fetchUserById', () {
    test('returns User when status code is 200', () async {
      final fakeJson = {
        'id': 1,
        'createdAt': '2025-04-21T12:34:56.000Z',
        'cognitoId': 'cid',
        'email': 'me@example.com',
        'recipient': true,
        'recipientData': {
          'id': 1,
          'createdAt': '2025-04-21T12:34:56.000Z',
          'firstName': 'Alice',
          'formQuestions': [],
        },
      };

      when(() => mockClient.get(any())).thenAnswer((_) async =>
          http.Response(jsonEncode(fakeJson), 200));

      final user = await api.fetchUserById('cid');

      expect(user, isNotNull);
      expect(user!.email, equals('me@example.com'));
      expect(user.recipientData!.firstName, equals('Alice'));
    });

    test('returns null on non-200 status', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('Not found', 404));

      final user = await api.fetchUserById('cid');
      expect(user, isNull);
    });

    test('returns null on exception', () async {
      when(() => mockClient.get(any())).thenThrow(Exception('network down'));

      final user = await api.fetchUserById('cid');
      expect(user, isNull);
    });
  });

  group('updateUser', () {
    final dummyUser = User(
      id: 2,
      createdAt: DateTime.parse('2025-04-21T00:00:00.000Z'),
      cognitoId: 'x',
      email: 'x@x.com',
      recipient: false,
      donorData: Donor(
        id: 2,
        nickname: 'DonorNick',
        createdAt: DateTime.parse('2025-04-21T00:00:00.000Z'),
      ),
    );

    test('returns true on status 200', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      final result = await api.updateUser(dummyUser);
      expect(result, isTrue);
    });

    test('returns false on non-200', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 500));

      final result = await api.updateUser(dummyUser);
      expect(result, isFalse);
    });

    test('returns false on exception', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenThrow(Exception('oops'));

      final result = await api.updateUser(dummyUser);
      expect(result, isFalse);
    });
  });

  group('convertToDonor', () {
    final user = User(
      id: 3,
      createdAt: DateTime.parse('2025-04-21T00:00:00.000Z'),
      cognitoId: 'y',
      email: 'y@y.com',
      recipient: true,
      recipientData: Recipient(
        id: 3,
        firstName: 'Bob',
        formQuestions: [],
      ),
    );
    final convertedJson = {
      'id': 3,
      'createdAt': '2025-04-22T08:00:00.000Z',
      'cognitoId': 'y',
      'email': 'y@y.com',
      'recipient': false,
      'donorData': {
        'id': 3,
        'createdAt': '2025-04-22T08:00:00.000Z',
        'nickname': 'Bob',
      },
    };

    test('returns User on 200', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(jsonEncode(convertedJson), 200));

      final result = await api.convertToDonor(user);
      expect(result, isNotNull);
      expect(result!.recipient, isFalse);
    });

    test('returns null on non-200', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 400));

      final result = await api.convertToDonor(user);
      expect(result, isNull);
    });
  });

  group('convertToRecipient', () {
    final donorUser = User(
      id: 4,
      createdAt: DateTime.parse('2025-04-21T00:00:00.000Z'),
      cognitoId: 'z',
      email: 'z@z.com',
      recipient: false,
      donorData: Donor(
        id: 4,
        nickname: 'X',
        createdAt: DateTime.parse('2025-04-21T00:00:00.000Z'),
      ),
    );
    final recJson = {
      'id': 4,
      'createdAt': '2025-04-23T09:30:00.000Z',
      'cognitoId': 'z',
      'email': 'z@z.com',
      'recipient': true,
      'recipientData': {
        'id': 4,
        'createdAt': '2025-04-23T09:30:00.000Z',
        'firstName': 'X',
        'formQuestions': [],
      },
    };

    test('returns User on 200', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(jsonEncode(recJson), 200));

      final result = await api.convertToRecipient(donorUser);
      expect(result, isNotNull);
      expect(result!.recipient, isTrue);
    });

    test('returns null on exception', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenThrow(Exception('fail'));

      final result = await api.convertToRecipient(donorUser);
      expect(result, isNull);
    });
  });

  group('updateEmail', () {
    test('returns true on 200', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      final ok = await api.updateEmail(userId: 5, attrMap: {'sub': 's', 'email': 'e@e'});
      expect(ok, isTrue);
    });

    test('returns false on non-200', () async {
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 500));

      final ok = await api.updateEmail(userId: 5, attrMap: {'sub': 's', 'email': 'e@e'});
      expect(ok, isFalse);
    });
  });
}
