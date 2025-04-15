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
  final DateTime? identityLastVerified;
  final DateTime? incomeLastVerified;
  final String? nickname;
  final DateTime? createdAt;
  final String? imageURL;

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
    this.identityLastVerified,
    this.incomeLastVerified,
    this.nickname,
    this.createdAt,
    this.imageURL,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    try {
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
        identityLastVerified: json['identity_last_verified'] != null
            ? DateTime.parse(json['identity_last_verified'])
            : null,
        incomeLastVerified: json['income_last_verified'] != null
            ? DateTime.parse(json['income_last_verified'])
            : null,
        nickname: json['nickname'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        imageURL: json['imageURL'] as String?,
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
      'first_name': firstName,
      'last_name': lastName,
      'street_address1': streetAddress1,
      'street_address2': streetAddress2,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'last_about_me': lastAboutMe,
      'last_reason_for_help': lastReasonForHelp,
      'identity_last_verified': identityLastVerified?.toIso8601String(),
      'income_last_verified': incomeLastVerified?.toIso8601String(),
      'nickname': nickname,
      'created_at': createdAt?.toIso8601String(),
      'imageURL': imageURL,
    };
  }

  @override
  String toString() {
    return 'Recipient(id: $id, firstName: $firstName, lastName: $lastName, nickname: $nickname)';
  }
}
