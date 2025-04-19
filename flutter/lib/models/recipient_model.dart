import 'package:uplift/models/tag_model.dart';

class Recipient {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? streetAddress1;
  final String? streetAddress2;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? lastAboutMe;
  final String? lastReasonForHelp;
  final List<Map<String, dynamic>>? formQuestions;
  final DateTime? identityLastVerified;
  final DateTime? incomeLastVerified;
  final String? nickname;
  final DateTime? createdAt;
  final String? imageURL;
  final DateTime? lastDonationTimestamp;
  final List<Tag>? tags;
  final DateTime? tagsLastGenerated;


  const Recipient({
    required this.id,
    this.firstName,
    this.lastName,
    this.streetAddress1,
    this.streetAddress2,
    this.city,
    this.state,
    this.zipCode,
    this.lastAboutMe,
    this.lastReasonForHelp,
    this.formQuestions,
    this.identityLastVerified,
    this.incomeLastVerified,
    this.nickname,
    this.createdAt,
    this.imageURL,
    this.lastDonationTimestamp,
    this.tags,
    this.tagsLastGenerated
    
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    try {
      // Check if the data is nested under recipientData
      final recipientData = json['recipientData'] ?? json;

      // Generate a default display name if no name fields are present
      String? firstName = recipientData['firstName'] as String?;
      String? lastName = recipientData['lastName'] as String?;
      String? nickname = recipientData['nickname'] as String?;

      // If no name fields are present, use a default based on ID
      if (firstName == null && lastName == null && nickname == null) {
        firstName = 'Recipient ${recipientData['id']}';
      }

      return Recipient(
        id: json['id'] as int,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        streetAddress1: json['street_address1'] as String?,
        streetAddress2: json['street_address2'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        zipCode: json['zip_code'] as String?,
        lastAboutMe: json['last_about_me'] as String?,
        lastReasonForHelp: json['last_reason_for_help'] as String?,
        formQuestions: (json['formQuestions'] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e))
          .toList() ?? [],
        identityLastVerified: json['identity_last_verified'] != null
            ? DateTime.parse(json['identity_last_verified'])
            : null,
        incomeLastVerified: recipientData['incomeLastVerified'] != null
            ? DateTime.parse(recipientData['incomeLastVerified'])
            : null,
        nickname: nickname,
        createdAt: recipientData['createdAt'] != null
            ? DateTime.parse(recipientData['createdAt'])
            : null,
        imageURL: json['imageURL'] as String?,
        tagsLastGenerated: json['tagsLastGenerated'] != null
            ? DateTime.parse(json['tagsLastGenerated'])
            : null,
        lastDonationTimestamp: json['lastDonationTimestamp'] != null
            ? DateTime.parse(json['lastDonationTimestamp'])
            : null,
        tags: (json['tags'] is List)
            ? (json['tags'] as List).map((t) => Tag.fromJson(t)).toList()
            : null,
      );
    } catch (e) {
      print('Error parsing Recipient from JSON: $e');
      print('JSON received: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'streetAddress1': streetAddress1,
      'streetAddress2': streetAddress2,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'last_about_me': lastAboutMe,
      'last_reason_for_help': lastReasonForHelp,
      'formQuestions': formQuestions,
      'identity_last_verified': identityLastVerified?.toIso8601String(),
      'income_last_verified': incomeLastVerified?.toIso8601String(),
      'nickname': nickname,
      'createdAt': createdAt?.toIso8601String(),
      'imageURL': imageURL,
    };
  }

  @override
  String toString() {
    return 'Recipient(id: $id, firstName: $firstName, lastName: $lastName, nickname: $nickname)';
  }
}
