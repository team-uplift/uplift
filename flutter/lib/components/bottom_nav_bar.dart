/// bottom_nav_bar.dart
///
/// A custom bottom navigation bar component that provides:
/// - Main navigation items
/// - Navigation state management
/// - Visual feedback for current section
/// - Consistent navigation across the app
///
/// Used as the primary navigation method throughout the app,
/// providing easy access to main sections.

import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedItem;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedItem,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: selectedItem,
        onTap: onItemTapped,
        type: BottomNavigationBarType.shifting,
        iconSize: 30,
        items: const [
          // PROFILE
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: AppColors.warmWhite),
            label: 'Profile',
            backgroundColor: AppColors.baseBlue,
          ),
          // DONATION HISTORY
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: AppColors.warmWhite),
            label: 'History',
            backgroundColor: AppColors.baseRed,
          ),
          // SETTINGS
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: AppColors.warmWhite),
            label: 'Settings',
            backgroundColor: AppColors.baseOrange,
          ),
        ]);
  }
}
