import 'package:uplift/models/donor_model.dart';
import 'package:uplift/models/recipient_model.dart';

class User {
  final int? id;
  final DateTime? created_at;
  final String cognito_id;
  final String email;
  final bool recipient;
  final Recipient? recipient_data;
  final Donor? donor_data;

  const User({
    this.id,
    this.created_at,
    required this.cognito_id,
    required this.email,
    required this.recipient,
    this.recipient_data,
    this.donor_data,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final bool recipient_flag = json['recipient'];

    if(recipient_flag) {
      return User(
        id: json['id'],
        cognito_id: json['cognito_id'],
        created_at: DateTime.parse(json['created_at']),
        email: json['email'],
        recipient: json['recipient'],
        recipient_data: Recipient.fromJson(json['recipient_data']),
      );
    } else {
      return User(
        id: json['id'],
        cognito_id: json['cognito_id'],
        created_at: DateTime.parse(json['created_at']),
        email: json['email'],
        recipient: json['recipient'],
        donor_data: Donor.fromJson(json['donor_data']),
      );
    }
    
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': created_at?.toIso8601String(),
      'cognito_id': cognito_id,
      'email': email,
      'recipient': recipient,
      'recipient_data': recipient_data?.toJson(),
      'donor_data': donor_data?.toJson()
    };
  }
}
