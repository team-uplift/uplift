/// donor_tag_model.dart
///
/// Defines the DonorTag model that represents donor preferences:
/// - Tag name
/// - Preference weight
/// - Matching criteria
///
/// Used to store and manage donor preferences for
/// the matching algorithm.

class DonorTag {
  final String tagName;
  final String? createdAt; // Optional if you don't always need it

  DonorTag({required this.tagName, this.createdAt});

  factory DonorTag.fromJson(Map<String, dynamic> json) {
    return DonorTag(
      tagName: json['tagName'] ?? 'Untitled', // fallback if null
      createdAt: json['createdAt'],
    );
  }
}
