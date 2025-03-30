import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/donor_model.dart';
import '../api/donor_api.dart';

part 'donor_notifier_provider.g.dart';

@riverpod
Future<Donor?> donor(DonorRef ref, String donorId) async {
  return await DonorApi.fetchDonorById(donorId);
}
