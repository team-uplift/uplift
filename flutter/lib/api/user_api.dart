/// user_api.dart
///
/// API methods for user related actions
/// Includes:
/// - fetching a user by ID
/// - updating a user's information
/// - converting a user from donor to recipient
/// - converting a user from recipient to donor
/// - deleting a user's account
///
library;

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/user_model.dart';
import 'dart:convert';

import 'package:uplift/utils/logger.dart';

class UserApi {
  // pass http client for testing or default to normal http client
  final http.Client client;
  UserApi({http.Client? client}) : client = client ?? http.Client();

  /// fetches a user by a user id
  ///
  /// returns a User object on success, null on failure
  Future<User?> fetchUserById(String userId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/users/cognito/$userId');

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log.info("Successfully fetched user.");
        return User.fromJson(data);
      } else {
        log.severe('Failed to load donor. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.severe('Error fetching donor: $e');
      return null;
    }
  }

  /// updates a user's information
  ///
  /// returns 'true' on success, 'false' on failure
  Future<bool> updateUser(User user) async {
    final url = Uri.parse('${AppConfig.baseUrl}/users');

    try {
      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      log.info("Successfully updated user.");
      return response.statusCode == 200;
    } catch (e) {
      log.severe("Error updating user: $e");
      return false;
    }
  }

  /// converts a user from recipient to donor
  ///
  /// returns a User object on success, null on failure
  Future<User?> convertToDonor(User user) async {
    final url = Uri.parse('${AppConfig.baseUrl}/users/switch/donor/${user.id}');

    final payload = {
      'nickname': user.recipientData?.nickname,
    };

    log.info("convert to donor");

    try {
      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log.info("Successfully converted user to donor.");
        return User.fromJson(data);
      } else {
        log.severe(
            'Failed to convert to donor. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.severe('Error converting to donor: $e');

      return null;
    }
  }

  /// converts a user from donor to recipient
  ///
  /// returns a User object on success, null on failure
  Future<User?> convertToRecipient(User user) async {
    final url = Uri.parse('${AppConfig.baseUrl}/users/switch/recipient');

    try {
      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log.info("Successfully converted user to recipient.");
        return User.fromJson(data);
      } else {
        log.severe(
            'Failed to convert to recipient. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.severe('Error converting to recipient: $e');

      return null;
    }
  }

  /// deletes a user account from DB and amplify
  ///
  /// does not return
  Future<void> deleteAccount(User user) async {
    final userId = user.id;

    try {
      final response = await client.delete(
        Uri.parse('${AppConfig.baseUrl}/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 400) {
        log.severe("Backend deletion unsuccessful");
      }

      // try deleting from cognito
      try {
        await Amplify.Auth.deleteUser();
      } catch (e) {
        log.warning("Cognito user may already be deleted: $e");
      }

      // Force sign out from all devices
      await Amplify.Auth.signOut(options: SignOutOptions(globalSignOut: true));
      log.info("Successfully deleted user.");
    } catch (e) {
      log.severe('Error during delete request: $e');
    }
  }

  /// updates the email address of a user
  ///
  /// returns the status code of the response
  Future<bool> updateEmail({
    required int userId,
    required Map<String, dynamic> attrMap,
  }) async {
    final payload = {
      'id': userId,
      'cognitoId': attrMap['sub'],
      'email': attrMap['email'],
    };

    final response = await client.put(
      Uri.parse('${AppConfig.baseUrl}/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    log.info("Successfully updated user email.");
    return response.statusCode == 200;
  }
}
