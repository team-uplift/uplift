/// tag_api.dart
///
/// API methods for tag related actions
/// Includes:
/// - generating tags from a recipient profile
///

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uplift/utils/logger.dart';
import '../models/tag_model.dart';

class TagApi {
  static const String baseUrl =
      'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift';

  /// generates tags from a recipients registration answers
  ///
  /// returns a list of tag objects on success, an empty list on failure
  static Future<List<Tag>> generateTags(
      int userId, List<Map<String, dynamic>> questions) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recipients/tagGeneration/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(questions),
      );

      if (response.statusCode == 201) {
        final tagsData = jsonDecode(response.body);
        log.info("Successfully generated tags.");
        return (tagsData as List).map((tag) => Tag.fromJson(tag)).toList();
      } else {
        log.severe("Failed to generate tags: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log.severe("Tag generation error: $e");
      return [];
    }
  }
}
