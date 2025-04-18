class Donor {
  final int id;
  final String nickname;
  final DateTime createdAt;

  Donor({
    required this.id,
    required this.nickname,
    required this.createdAt,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    try {
      return Donor(
        id: json['id'] as int,
        nickname: json['nickname'] as String,
        createdAt: DateTime.parse(json['createdAt']),
      );
    } catch (e) {
      print('Error parsing Donor from JSON: $e');
      print('JSON received: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Donor(id: $id, nickname: $nickname, createdAt: $createdAt)';
  }
}
