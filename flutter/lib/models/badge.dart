import 'package:flutter/material.dart';

class DonorBadge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int requiredDonations;
  final bool isUnlocked;

  DonorBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.requiredDonations,
    this.isUnlocked = false,
  });
}

// List of all available badges
final List<DonorBadge> allBadges = [
  DonorBadge(
    id: 'bronze',
    name: 'Bronze Donor',
    description: 'Made 5 donations',
    icon: Icons.workspace_premium,
    requiredDonations: 5,
  ),
  DonorBadge(
    id: 'silver',
    name: 'Silver Donor',
    description: 'Made 25 donations',
    icon: Icons.workspace_premium,
    requiredDonations: 25,
  ),
  DonorBadge(
    id: 'gold',
    name: 'Gold Donor',
    description: 'Made 50 donations',
    icon: Icons.workspace_premium,
    requiredDonations: 50,
  ),
  DonorBadge(
    id: 'platinum',
    name: 'Platinum Donor',
    description: 'Made 100 donations',
    icon: Icons.workspace_premium,
    requiredDonations: 100,
  ),
];
