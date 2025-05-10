import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/badge.dart';
import '../providers/donation_notifier_provider.dart';

class BadgeService {
  static const String _unlockedBadgesKey = 'unlocked_badges';
  final WidgetRef ref;

  BadgeService(this.ref);

  int getDonationCount() {
    final donationState = ref.read(donationNotifierProvider);
    return donationState.donations.length;
  }

  Future<void> incrementDonationCount() async {
    // Implementation for incrementing donation count
  }

  Future<List<String>> getUnlockedBadgeIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unlockedBadgesKey) ?? [];
  }

  Future<void> unlockBadge(String badgeId) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedBadges = prefs.getStringList(_unlockedBadgesKey) ?? [];
    if (!unlockedBadges.contains(badgeId)) {
      unlockedBadges.add(badgeId);
      await prefs.setStringList(_unlockedBadgesKey, unlockedBadges);
    }
  }

  Future<List<DonorBadge>> getBadges() async {
    final donationCount = getDonationCount();
    print('Current donation count: $donationCount'); // Debug log

    return allBadges.map((badge) {
      final isUnlocked = donationCount >= badge.requiredDonations;
      print(
          'Badge ${badge.name}: requires ${badge.requiredDonations} donations, isUnlocked: $isUnlocked'); // Debug log
      return DonorBadge(
        id: badge.id,
        name: badge.name,
        description: badge.description,
        icon: badge.icon,
        requiredDonations: badge.requiredDonations,
        isUnlocked: isUnlocked,
      );
    }).toList();
  }

  // Add method to reset donation count for testing
  Future<void> resetDonationCount() async {
    // No need for this method anymore as we're using actual donation count
  }
}
