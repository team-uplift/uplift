/// donor_model.dart
///
/// Defines the Donor model that represents a donation provider:
/// - Personal information
/// - Donation preferences
/// - Donation history
/// - Matching criteria
///
/// Used throughout the app to manage donor profiles and
/// facilitate the donation matching process.

import 'package:uplift/models/donor_tag_model.dart';

class Donor {
  final int id;
  final String nickname;
  final DateTime createdAt;

  Donor({
    required this.id,
    required this.nickname,
    required this.createdAt,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    try {
      return Donor(
        id: json['id'] as int,
        nickname: json['nickname'] as String,
        createdAt: DateTime.parse(json['createdAt']),
      );
    } catch (e) {
      print('Error parsing Donor from JSON: $e');
      print('JSON received: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Donor(id: $id, nickname: $nickname, createdAt: $createdAt)';
  }
}
