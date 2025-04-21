import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tag_model.dart';

class TagApi {
  static const String baseUrl = 'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift';

  static Future<List<Tag>> generateTags(String userId, List<Map<String, dynamic>> questions) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recipients/tagGeneration/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(questions),
      );

      if (response.statusCode == 201) {
        final tagsData = jsonDecode(response.body);
        return (tagsData as List).map((tag) => Tag.fromJson(tag)).toList();
      } else {
        print("Failed to generate tags: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Tag generation error: $e");
      return [];
    }
  }

}
