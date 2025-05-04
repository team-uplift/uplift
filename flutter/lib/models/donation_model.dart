/// donation_model.dart
///
/// Defines the Donation model that represents a donation transaction:
/// - Donation amount
/// - Recipient information
/// - Transaction date
/// - Thank you message status
///
/// Used throughout the app to track and display donation history
/// and manage donation-related functionality.

import 'package:uplift/models/recipient_model.dart';

class Donation {
  final int id;
  final DateTime createdAt;
  final String donorName;
  final int amount; // stored as cents
  final String? thankYouMessage;
  final Recipient? recipient;

  Donation({
    required this.id,
    required this.createdAt,
    required this.donorName,
    required this.amount,
    this.thankYouMessage,
    this.recipient,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      donorName: json['donor']?['nickname'] ?? 'Anonymous',
      amount: json['amount'] ?? 0,
      thankYouMessage: json['thankYouMessage']?['message'],
      recipient: json['recipient'] != null
          ? Recipient.fromJson(json['recipient'])
          : null,
    );
  }

  // helper to get amount as formatted string
  String get formattedAmount => "\$${(amount).toStringAsFixed(2)}";

  String get formattedDate =>
      "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";
}
