import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uplift/models/recipient_model.dart';

part 'recipient_notifier_provider.g.dart';

@riverpod
class RecipientNotifier extends _$RecipientNotifier {
  @override
  List<Recipient> build() {
    return []; // Initial empty list
  }

  // Add a recipient
  void addRecipient(Recipient recipient) {
    state = [...state, recipient];
  }

  // Remove a recipient by ID
  void removeRecipient(String id) {
    state = state.where((recipient) => recipient.id != id).toList();
  }

  // Update a recipient
  void updateRecipient(Recipient updatedRecipient) {
    state = state.map((recipient) {
      return recipient.id == updatedRecipient.id ? updatedRecipient : recipient;
    }).toList();
  }
}
