import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uplift/models/recipient_model.dart';
class Donation {
  final int id;
  final double amount;
  final int donorId;
  final int recipientId;
  final String recipientName;
  final DateTime createdAt;
  final String? thankYouMessage;
  final Recipient? recipient;
  Donation({
    required this.id,
    required this.amount,
    required this.donorId,
    required this.recipientId,
    required this.recipientName,
    required this.createdAt,
    this.thankYouMessage,
    this.recipient,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing donation JSON: $json');

    // Handle potential null values
    final id = json['id'] as int? ?? 0;
    final amount = (json['amount'] as num?)?.toDouble() ?? 0.0;
    final donorId = json['donorId'] as int? ?? 0;
    final recipientId = json['recipientId'] as int? ?? 0;
    final recipientName = json['recipientName'] as String? ?? 'Anonymous';
    final thankYouMessage = json['thankYouMessage'] as String?;
    final recipient = json['recipient'] != null
        ? Recipient.fromJson(json['recipient'])
        : null;
    // Parse date with error handling
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(json['createdAt'] as String? ?? '');
    } catch (e) {
      debugPrint('Error parsing date: $e');
      createdAt = DateTime.now();
    }

    return Donation(
      id: id,
      amount: amount,
      donorId: donorId,
      recipientId: recipientId,
      recipientName: recipientName,
      createdAt: createdAt,
      thankYouMessage: thankYouMessage,
      recipient: recipient
    );
  }
}

class DonationNotifier extends StateNotifier<List<Donation>> {
  DonationNotifier() : super([]);

  Future<void> fetchDonations() async {
    try {
      // Get current user attributes
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final attrMap = {
        for (final attr in attributes) attr.userAttributeKey.key: attr.value,
      };
      final cognitoId = attrMap['sub'];

      if (cognitoId == null) {
        throw Exception('Failed to get user authentication information');
      }

      // Get user info from backend
      final userResponse = await http.get(
        Uri.parse(
            'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users/cognito/$cognitoId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (userResponse.statusCode != 200) {
        throw Exception('Failed to get user information');
      }

      final userData = jsonDecode(userResponse.body);
      debugPrint('User data: $userData');
      final userId = userData['id'];

      if (userId == null) {
        throw Exception('Failed to get user ID');
      }

      // Fetch donations for the user
      final response = await http.get(
        Uri.parse(
            'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/donations/donor/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      debugPrint('Donations response status: ${response.statusCode}');
      debugPrint('Donations response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('Parsed donations data: $data');
        state = data.map((json) => Donation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch donations');
      }
    } catch (e) {
      debugPrint('Error fetching donations: $e');
      rethrow;
    }
  }
}

final donationNotifierProvider =
    StateNotifierProvider<DonationNotifier, List<Donation>>((ref) {
  return DonationNotifier();
});
