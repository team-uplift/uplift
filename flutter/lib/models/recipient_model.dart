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
        id: recipientData['id'] as int,
        firstName: firstName,
        lastName: lastName,
        streetAddress1: recipientData['streetAddress1'] as String?,
        streetAddress2: recipientData['streetAddress2'] as String?,
        city: recipientData['city'] as String?,
        state: recipientData['state'] as String?,
        zipCode: recipientData['zipCode'] as String?,
        lastAboutMe: recipientData['lastAboutMe'] as String?,
        lastReasonForHelp: recipientData['lastReasonForHelp'] as String?,
        identityLastVerified: recipientData['identityLastVerified'] != null
            ? DateTime.parse(recipientData['identityLastVerified'])
            : null,
        incomeLastVerified: recipientData['incomeLastVerified'] != null
            ? DateTime.parse(recipientData['incomeLastVerified'])
            : null,
        nickname: nickname,
        createdAt: recipientData['createdAt'] != null
            ? DateTime.parse(recipientData['createdAt'])
            : null,
        imageURL: recipientData['imageUrl'] as String?,
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
      'zipCode': zipCode,
      'lastAboutMe': lastAboutMe,
      'lastReasonForHelp': lastReasonForHelp,
      'identityLastVerified': identityLastVerified?.toIso8601String(),
      'incomeLastVerified': incomeLastVerified?.toIso8601String(),
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
