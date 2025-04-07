import 'package:http/http.dart' as http;
import 'package:uplift/models/user_model.dart';
import 'dart:convert';

// import '../models/donor_model.dart';

class UserApi {
  static const baseUrl =
      'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift';

  static Future<User?> fetchUserById(String userId) async {
    final url = Uri.parse('$baseUrl/users/cognito/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        print('Failed to load donor. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching donor: $e');

      return null;
    }
  }
}
