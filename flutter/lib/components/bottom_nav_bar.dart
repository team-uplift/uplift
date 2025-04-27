/// bottom_nav_bar.dart
///
/// Navigation bar component for recipient dashboard
///

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: AppColors.warmWhite),
            label: 'Profile',
            backgroundColor: AppColors.baseBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: AppColors.warmWhite),
            label: 'History',
            backgroundColor: AppColors.baseRed,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: AppColors.warmWhite),
            label: 'Settings',
            backgroundColor: AppColors.baseOrange,
          ),
        ]);
  }
}
