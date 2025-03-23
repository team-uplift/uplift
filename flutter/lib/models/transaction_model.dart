import 'package:uplift/models/recipient_model.dart';

class Transaction {
  final String id;
  final Recipient recipient;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.recipient,
    required this.amount,
    required this.date,
  });

  // Factory constructor to set default date to today
  factory Transaction.create({
    required Recipient recipient,
    required double amount,
  }) {
    return Transaction(
      id: DateTime.now().toString(), // Unique ID
      recipient: Recipient(
        id: recipient.id,
        name: recipient.name,
        imageUrl: recipient.imageUrl,
        description: recipient.description

      ),
      amount: amount,
      date: DateTime.now(), // Sets default to today
    );
  }
}
