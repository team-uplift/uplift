import 'package:flutter/material.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/components/bottom_nav_bar.dart';
import 'recipient_history.dart';
import 'recipient_profile.dart';
import 'recipient_tags.dart';
import 'recipient_settings.dart';

class RecipientHome extends StatefulWidget {
  const RecipientHome({super.key});

  @override
  State<RecipientHome> createState() => _RecipientHomeState();
}

class _RecipientHomeState extends State<RecipientHome> {
  int _selectedItem = 0;

  final List<Widget> _screens = [
    const RecipientProfile(),
    const RecipientTags(),
    const RecipientHistory(),
    const RecipientSettings(),
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
        title: const Center(
          child: Text("uplift")
        ),
      ),
      body: _screens[_selectedItem],
      bottomNavigationBar: BottomNavBar(
        selectedItem: _selectedItem, 
        onItemTapped: _onItemTapped,
      ),
    );
  }
}