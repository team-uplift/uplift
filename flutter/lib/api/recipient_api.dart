import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipientApi {
  static const String baseUrl = 'http://your-api-url/uplift';

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
        'firstName': attrMap['given_name'],
        'lastName': attrMap['family_name'],
        'lastAboutMe': formData['lastAboutMe'],
        'lastReasonForHelp': formData['lastReasonForHelp'],
        'formQuestions': formQuestions,
      },
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id'];
      } else {
        print("Recipient creation failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error creating recipient: $e");
      return null;
    }
  }

  static Future<bool> updateRecipient(String userId, Map<String, dynamic> updatedFields) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/recipients/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedFields),
      );

      return response.statusCode == 204;
    } catch (e) {
      print("Error updating recipient: $e");
      return false;
    }
  }
}

