import 'package:flutter/foundation.dart';
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
    final transaction = Transaction(
      id: DateTime.now().toString(),
      recipient: recipient,
      amount: amount,
      date: DateTime.now(),
    );
    debugPrint('Created transaction: $transaction');
    return transaction;
  }

  @override
  String toString() {
    return 'Transaction(id: $id, recipient: ${recipient.firstName ?? "Anonymous"}, amount: \$$amount, date: $date)';
  }
}
