import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class RecipientApi {
  static const String baseUrl = 'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift';

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

  static Future<bool> updateTags(String userId, List<String> selectedTags) async {
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
}

