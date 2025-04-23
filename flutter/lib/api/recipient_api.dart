import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/donation_model.dart';



class RecipientApi {
  static const String baseUrl =
      'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift';

  static Future<String?> createRecipientUser(
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

    print("Recipient api payload: $payload");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id'].toString();
      } else {
        print("Recipient creation failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error creating recipient: $e");
      return null;
    }
  }

  static Future<bool> updateTags(
      String userId, List<String> selectedTags) async {
    try {
      print("update tags: $selectedTags");
      final response = await http.put(
        Uri.parse('$baseUrl/recipients/tagSelection/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(selectedTags),
      );
      print("update recipient: ${response.body}");

      return response.statusCode == 204;
    } catch (e) {
      print("Error updating recipient: $e");
      return false;
    }
  }

  static Future<bool> uploadIncomeVerificationImage(
      String userId, File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/recipients/verification/income/$userId'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 && responseBody.trim() == 'true') {
        return true;
      } else {
        print("Verification failed: $responseBody");
        return false;
      }
    } catch (e) {
      print("Error verifying income: $e");
      return false;
    }
  }

  static Future<List<Donation>> fetchDonationsForRecipient(
      String recipientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations/recipient/$recipientId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Donation.fromJson(json)).toList();
      } else {
        print("Failed to fetch donations: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching donations: $e");
      return [];
    }
  }

  static Future<Donation?> fetchDonationById(String donationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations/$donationId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("get donation: ${response.body}");
        return Donation.fromJson(data);
      } else {
        print("Failed to fetch donations: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching donations: $e");
      return null;
    }
  }

  static Future<bool> sendThankYouMessage({
    // required int userId,
    required int donationId,
    required String message,
  }) async {
    final payload = {
      // 'id': userId,
      'donationId': donationId,
      'message': message,
      // 'donorRead': false,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Message sent successfully.");
        return true;
      } else {
        print("Failed to send message: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error sending thank you message: $e");
      return false;
    }
  }
}

// TODO
// Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey).fetchAuthSession().then( (value) {
//       print(value.userPoolTokensResult.value.accessToken.toJson());
//     });
// HEADER STUFF
// Accept:  */*
// Authorization: Bearer <add token here>
