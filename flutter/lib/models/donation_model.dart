class Donation {
  final int id;
  final DateTime createdAt;
  final String donorName;
  final int amount; // stored as cents
  final String? thankYouMessage;

  Donation({
    required this.id,
    required this.createdAt,
    required this.donorName,
    required this.amount,
    this.thankYouMessage,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      donorName: json['donor']?['nickname'] ?? 'Anonymous',
      amount: json['amount'] ?? 0,
      thankYouMessage: json['thankYouMessage']?['message'],
    );
  }

  // helper to get amount as formatted string
  String get formattedAmount => "\$${(amount / 100).toStringAsFixed(2)}";

  String get formattedDate =>
      "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";
}
