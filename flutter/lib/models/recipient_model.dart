class Recipient {
  final int id;
  final String firstName;
  final String lastName;
  final String streetAddress1;
  final String? streetAddress2;
  final String city;
  final String state;
  final String zipCode;
  final String lastAboutMe;
  final String lastReasonForHelp;
  final DateTime identityLastVerified;
  final DateTime incomeLastVerified;
  final String nickname;
  final DateTime createdAt;
  final String imageURL;

  const Recipient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.streetAddress1,
    this.streetAddress2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.lastAboutMe,
    required this.lastReasonForHelp,
    required this.identityLastVerified,
    required this.incomeLastVerified,
    required this.nickname,
    required this.createdAt,
    required this.imageURL
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      streetAddress1: json['street_address1'] as String,
      streetAddress2: json['street_address2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zip_code'] as String,
      lastAboutMe: json['last_about_me'] as String,
      lastReasonForHelp: json['last_reason_for_help'] as String,
      identityLastVerified: DateTime.parse(json['identity_last_verified']),
      incomeLastVerified: DateTime.parse(json['income_last_verified']),
      nickname: json['nickname'] as String,
      createdAt: DateTime.parse(json['created_at']),
      imageURL: json['imageURL'] as String
    );
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
      'identity_last_verified': identityLastVerified.toIso8601String(),
      'income_last_verified': incomeLastVerified.toIso8601String(),
      'nickname': nickname,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
