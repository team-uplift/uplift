// coverage:ignore-file
/// user_notifier_provider.dart
///
/// Provides state management for user data in the app:
/// - User authentication state
/// - User profile data
/// - User type (donor/recipient)
/// - User preferences
///
/// Used throughout the app to manage user state and
/// handle user-related operations.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uplift/models/user_model.dart';
// import '../models/donor_model.dart';
import '../api/user_api.dart';

part 'user_notifier_provider.g.dart';

@riverpod
Future<User?> user(UserRef ref, String userId) async {
  final api = UserApi();
  return await api.fetchUserById(userId);
}
