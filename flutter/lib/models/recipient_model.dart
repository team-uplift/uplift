class Recipient  {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final String description;

  const Recipient({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.description,
  });

  // Convert a JSON map into a Recipient object
  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );
  }

  // Convert a Recipient object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
