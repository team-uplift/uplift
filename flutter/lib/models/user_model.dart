/// user_model.dart
///
/// Defines the User model that extends the base UpliftUser:
/// - Additional user attributes
/// - User preferences
/// - Account status
/// - Profile completion
///
/// Used to extend the base user functionality with
/// additional features and attributes.

import 'package:uplift/models/donor_model.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/UpliftUser.dart';

class User {
  final int? id;
  final DateTime? createdAt;
  final String cognitoId;
  final String email;
  final bool recipient;
  final Recipient? recipientData;
  final Donor? donorData;

  const User({
    this.id,
    this.createdAt,
    required this.cognitoId,
    required this.email,
    required this.recipient,
    this.recipientData,
    this.donorData,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final bool recipientFlag = json['recipient'];

    if (recipientFlag) {
      return User(
        id: json['id'],
        cognitoId: json['cognitoId'],
        createdAt: DateTime.parse(json['createdAt']),
        email: json['email'],
        recipient: json['recipient'],
        recipientData: Recipient.fromJson(json['recipientData']),
      );
    } else {
      return User(
        id: json['id'],
        cognitoId: json['cognitoId'],
        createdAt: DateTime.parse(json['createdAt']),
        email: json['email'],
        recipient: json['recipient'],
        donorData: Donor.fromJson(json['donorData']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'cognitoId': cognitoId,
      'email': email,
      'recipient': recipient,
      'recipientData': recipientData?.toJson(),
      'donorData': donorData?.toJson()
    };
  }
}
