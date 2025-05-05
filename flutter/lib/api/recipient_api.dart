/// recipient_api.dart
///
/// API methods for recipient related actions
/// Includes:
/// - creating a recipient
/// - updating selected tags for recipient
/// - uploading income verification images
/// - fetching all donations tied to a recipient
/// - fetching a specific donation
/// - sending a thank you message to a donor
///
library;

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uplift/constants/constants.dart';
import 'package:uplift/utils/logger.dart';
import '../models/donation_model.dart';

// if planning on using JWT for authentication, fastest method would be to
// use cognito helper functions here

class RecipientApi {
  // pass http client for testing or default to normal http client
  final http.Client client;
  RecipientApi({http.Client? client}) : client = client ?? http.Client();

  /// create a recipient user from formdata and amplify auth information
  ///
  /// returns the user id on success, null on failure
  Future<int?> createRecipientUser(
    Map<String, dynamic> formData,
    List<Map<String, dynamic>> formQuestions,
    Map<String, dynamic> attrMap,
  ) async {
    final payload = {
      'cognitoId': attrMap['sub'],
      'email': attrMap['email'],
      'recipient': true,
      'recipientData': {
        'firstName': formData['firstName'],
        'lastName': formData['lastName'],
        'streetAddress1': formData['streetAddress1'],
        'streetAddress2': formData['streetAddress2'],
        'city': formData['city'],
        'state': formData['state'],
        'zipCode': formData['zipCode'],
        'lastAboutMe': formData['lastAboutMe'],
        'lastReasonForHelp': formData['lastReasonForHelp'],
        'formQuestions': formQuestions,
      },
    };

    try {
      final response = await client.post(
        Uri.parse('${AppConfig.baseUrl}/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log.info("Successfully created recipient user.");
        return data['id'];
      } else {
        log.severe("Recipient creation failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log.severe("Error creating recipient: $e");
      return null;
    }
  }

  /// updates a recipients selected tags associated with their profile
  ///
  /// returns 'true' on success, 'false' on failure
  Future<bool> updateTags(int userId, List<String> selectedTags) async {
    try {
      final response = await client.put(
        Uri.parse('${AppConfig.baseUrl}/recipients/tagSelection/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(selectedTags),
      );
      log.info("Successfully updated recipient tags.");
      return response.statusCode == 204;
    } catch (e) {
      log.severe("Error updating recipient: $e");
      return false;
    }
  }

  /// uploads income image to api for verification
  ///
  /// returns 'true' if verified, 'false' otherwise
  Future<bool> uploadIncomeVerificationImage(int userId, File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            '${AppConfig.baseUrl}/recipients/verification/income/$userId'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
            'incomeVerificationFile', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 && responseBody.trim() == 'true') {
        log.info("Recipient income verification successful.");
        return true;
      } else {
        log.severe("Verification failed: $responseBody");
        return false;
      }
    } catch (e) {
      log.severe("Error verifying income: $e");
      return false;
    }
  }

  /// retrieves list of all donations associated with recipient
  ///
  /// returns (list of donation objects, string) on success, (empty list, string) on failure
  Future<(List<Donation>, String)> fetchDonationsForRecipient(
      int recipientId) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConfig.baseUrl}/donations/recipient/$recipientId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log.info("Successfully fetched recipient donations.");
        final donationsList =
            data.map((json) => Donation.fromJson(json)).toList();
        var msg = "";
        if (donationsList.isEmpty) {
          msg = "No donations yet.";
        }
        return (donationsList, msg);
      } else {
        log.severe("Failed to fetch donations: ${response.statusCode}");
        return (<Donation>[], "Failed to fetch donations.");
      }
    } catch (e) {
      log.severe("Error fetching donations: $e");
      return (<Donation>[], "Error fetching donations.");
    }
  }

  /// fetches a specific donation by donation id
  ///
  /// returns donation object on success, null on failure
  Future<Donation?> fetchDonationById(int donationId) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConfig.baseUrl}/donations/$donationId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log.info("Successfully fetched donation.");
        return Donation.fromJson(data);
      } else {
        log.severe("Failed to fetch donations: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log.severe("Error fetching donations: $e");
      return null;
    }
  }

  /// sends thank you message from recipient to donor
  ///
  /// returns donation object on success, null on failure
  Future<Donation?> sendThankYouMessage({
    required int donationId,
    required String message,
  }) async {
    final payload = {
      'donationId': donationId,
      'message': message,
    };

    try {
      final response = await client.post(
        Uri.parse('${AppConfig.baseUrl}/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log.info("Message sent successfully.");
        final data = jsonDecode(response.body);
        return Donation.fromJson(data);
      } else {
        log.warning("Failed to send message: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log.severe("Error sending thank you message: $e");
      return null;
    }
  }

  /// updates a recipient with new information from edited form
  ///
  /// returns 'true' on succes, 'false' on failure
  Future<bool> updateRecipientUserProfile(
    Map<String, dynamic> formData,
    List<Map<String, dynamic>> formQuestions,
    Map<String, dynamic> attrMap,
  ) async {
    final payload = {
      'id': formData['userId'],
      'cognitoId': attrMap['sub'],
      'email': attrMap['email'],
      'recipient': true,
      'recipientData': {
        'id': formData['userId'],
        'firstName': formData['firstName'],
        'lastName': formData['lastName'],
        'streetAddress1': formData['streetAddress1'],
        'streetAddress2': formData['streetAddress2'],
        'city': formData['city'],
        'state': formData['state'],
        'zipCode': formData['zipCode'],
        'lastAboutMe': formData['lastAboutMe'],
        'lastReasonForHelp': formData['lastReasonForHelp'],
        'formQuestions': formQuestions,
      },
    };

    try {
      final response = await client.put(
        Uri.parse('${AppConfig.baseUrl}/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      log.info("Successfully updated recipient user.");
      return response.statusCode == 200;
    } catch (e) {
      log.severe("Error updating recipient: $e");
      return false;
    }
  }
}

// TODO --> for how to incorporate JWT tokens later
// Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey).fetchAuthSession().then( (value) {
//       print(value.userPoolTokensResult.value.accessToken.toJson());
//     });
// HEADER STUFF
// Accept:  */*
// Authorization: Bearer <add token here>
