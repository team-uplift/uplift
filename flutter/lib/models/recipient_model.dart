class Recipient {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  const Recipient({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  // Convert a JSON map into a Recipient object
  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );
  }

  // Convert a Recipient object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
