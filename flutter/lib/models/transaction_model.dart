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
        firstName: recipient.firstName,
        lastName: recipient.lastName,
        imageURL: recipient.imageURL,
        lastAboutMe: recipient.lastAboutMe,
        streetAddress1: recipient.streetAddress1,
        streetAddress2: recipient.streetAddress2,
        city: recipient.city,
        state: recipient.state,
        zipCode: recipient.zipCode,
        lastReasonForHelp: recipient.lastReasonForHelp,
        identityLastVerified: recipient.identityLastVerified,
        incomeLastVerified: recipient.incomeLastVerified,
        nickname: recipient.nickname,
        createdAt: recipient.createdAt

      ),
      amount: amount,
      date: DateTime.now(), // Sets default to today
    );
  }
}
