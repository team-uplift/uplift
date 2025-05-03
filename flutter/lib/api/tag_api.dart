/// tag_api.dart
///
/// API methods for tag related actions
/// Includes:
/// - generating tags from a recipient profile
///
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uplift/constants/constants.dart';
import 'package:uplift/utils/logger.dart';
import '../models/tag_model.dart';

class TagApi {
  
  // pass http client for testing or default to normal http client
  final http.Client client;
  TagApi({http.Client? client}) : client = client ?? http.Client();


  /// generates tags from a recipients registration answers
  ///
  /// returns a list of tag objects on success, an empty list on failure
  Future<List<Tag>> generateTags(
      int userId, List<Map<String, dynamic>> questions) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConfig.baseUrl}/recipients/tagGeneration/$userId'),
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
      // TODO handle error messaging in display widget
      log.severe("Tag generation error: $e");
      return [];
    }
  }
}
