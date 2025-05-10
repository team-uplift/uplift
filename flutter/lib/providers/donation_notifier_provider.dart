// coverage:ignore-file
/// donation_notifier_provider.dart
///
/// Provides state management for donations in the app:
/// - Donation data model
/// - Donation fetching from API
/// - Donation state updates
/// - Error handling for donation operations
///
/// Used throughout the app to manage and display donation
/// information and handle donation-related operations.
library;

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

    // Parse thankYouMessage correctly
    String? thankYouMessage;
    if (json['thankYouMessage'] != null) {
      if (json['thankYouMessage'] is Map) {
        thankYouMessage = json['thankYouMessage']['message'] as String?;
      } else if (json['thankYouMessage'] is String) {
        thankYouMessage = json['thankYouMessage'] as String;
      }
    }

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
        recipient: recipient);
  }
}

class DonationState {
  final List<Donation> donations;
  final String? error;
  final bool isLoading;

  DonationState({
    required this.donations,
    this.error,
    this.isLoading = false,
  });

  DonationState copyWith({
    List<Donation>? donations,
    String? error,
    bool? isLoading,
  }) {
    return DonationState(
      donations: donations ?? this.donations,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DonationNotifier extends StateNotifier<DonationState> {
  DonationNotifier() : super(DonationState(donations: []));

  Future<void> fetchDonations() async {
    state = state.copyWith(isLoading: true, error: null);

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

      debugPrint('Fetching user info for cognito ID: $cognitoId');

      // Get user info from backend
      final userResponse = await http.get(
        Uri.parse(
            'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users/cognito/$cognitoId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      debugPrint('User response status: ${userResponse.statusCode}');
      debugPrint('User response body: ${userResponse.body}');

      if (userResponse.statusCode != 200) {
        throw Exception(
            'Failed to get user information: ${userResponse.statusCode}');
      }

      final userData = jsonDecode(userResponse.body);
      debugPrint('User data: $userData');
      final userId = userData['id'];

      if (userId == null) {
        throw Exception('Failed to get user ID from response');
      }

      debugPrint('Fetching donations for user ID: $userId');

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
        try {
          final List<dynamic> data = jsonDecode(response.body);
          debugPrint('Parsed donations data: $data');

          if (data is! List) {
            throw Exception(
                'Expected a list of donations but got: ${data.runtimeType}');
          }

          final donations = data.map((json) {
            try {
              return Donation.fromJson(json);
            } catch (e) {
              debugPrint('Error parsing donation: $e');
              debugPrint('Problematic JSON: $json');
              rethrow;
            }
          }).toList();

          state = state.copyWith(
            donations: donations,
            isLoading: false,
          );
        } catch (e) {
          debugPrint('Error parsing donations response: $e');
          throw Exception('Failed to parse donations data: $e');
        }
      } else {
        throw Exception('Failed to fetch donations: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching donations: $e');
      if (e.toString().contains('NotAuthorizedServiceException')) {
        state = state.copyWith(
          donations: [],
          error: 'Please log in to view your donations',
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          donations: [],
          error: 'Failed to load donations: ${e.toString()}',
          isLoading: false,
        );
      }
    }
  }
}

final donationNotifierProvider =
    StateNotifierProvider<DonationNotifier, DonationState>((ref) {
  return DonationNotifier();
});
