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
    return Donor(
      id: json['id'],
      nickname: json['nickname'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
