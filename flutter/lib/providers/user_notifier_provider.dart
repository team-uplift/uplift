import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uplift/models/user_model.dart';
// import '../models/donor_model.dart';
import '../api/donor_api.dart';

part 'user_notifier_provider.g.dart';

@riverpod
Future<User?> user(UserRef ref, String userId) async {
  return await DonorApi.fetchDonorById(userId);
}
