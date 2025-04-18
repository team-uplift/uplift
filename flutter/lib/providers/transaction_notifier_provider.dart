import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:uplift/models/transaction_model.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]); // ✅ Starts with an empty list

  void addTransaction(Transaction transaction) {
    try {
      debugPrint('Adding transaction: $transaction');
      state = [...state, transaction]; // ✅ Properly updates state
      debugPrint('New state length: ${state.length}');
      print(
          "✅ Added transaction: ${transaction.amount} to ${transaction.recipient.firstName}");
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    }
  }
}

// ✅ Use `StateNotifierProvider` instead of `@riverpod`
final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>(
  (ref) => TransactionNotifier(),
);
