import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/donor_model.dart';

class DonorApi {
  static const baseUrl = 'https://todo.com';

  static Future<Donor?> fetchDonorById(String donorId) async {
    final url = Uri.parse('$baseUrl/donors/$donorId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Donor.fromJson(data);
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
