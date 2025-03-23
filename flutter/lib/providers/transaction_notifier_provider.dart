import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uplift/models/transaction_model.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]); // ✅ Starts with an empty list

  void addTransaction(Transaction transaction) {
    state = [...state, transaction]; // ✅ Properly updates state
    print(
        "✅ Added transaction: ${transaction.amount} to ${transaction.recipient.name}");
    print("📊 Total transactions in state: ${state.length}");
  }
}

// ✅ Use `StateNotifierProvider` instead of `@riverpod`
final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>(
  (ref) => TransactionNotifier(),
);
