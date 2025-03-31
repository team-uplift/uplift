import 'package:flutter/material.dart';
import 'package:uplift/components/bottom_nav_bar.dart';
import 'recipient_history_screen.dart';
import 'recipient_profile_screen.dart';
import 'recipient_settings_screen.dart';
import 'package:go_router/go_router.dart';

// TODO link to home in appbar

class RecipientHome extends StatefulWidget {
  const RecipientHome({super.key});

  @override
  State<RecipientHome> createState() => _RecipientHomeState();
}

class _RecipientHomeState extends State<RecipientHome> {
  int _selectedItem = 0;

  final List<Widget> _screens = [
    RecipientProfileScreen(),
    const RecipientHistoryScreen(),
    const RecipientSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const DrawerWidget(),
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       context.goNamed('/home');
        //     }, 
        //     icon: const Icon(Icons.logout),
        //   )
        // ],
        // leading: IconButton(
        //   onPressed: () {context.goNamed('/home');}, 
        //   icon: const Icon(Icons.home),
        // ),
        title: const Text("uplift logo")
      ),
      body: _screens[_selectedItem],
      bottomNavigationBar: BottomNavBar(
        selectedItem: _selectedItem, 
        onItemTapped: _onItemTapped,

      ),
    );
  }
}

// TODO sort hamburger vs home button and app bar stuff
// TODO flow more like pinterest --> recipient signs up, then is provided list of generated tags, tags organized by temperature, can select 10 or whatever
// 