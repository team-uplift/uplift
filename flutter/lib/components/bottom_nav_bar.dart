import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/constants/constants.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedItem;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedItem,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedItem,
      onTap: onItemTapped,
      
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tag),
          label: 'Tags',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: Colors.amber,
        ),
      ]
    );
  }
}
        
