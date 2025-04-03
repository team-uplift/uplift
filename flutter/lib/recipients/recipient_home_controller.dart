import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/components/bottom_nav_bar.dart';
import 'recipient_history_screen.dart';
import 'recipient_profile_screen.dart';
import 'recipient_settings_screen.dart';

// TODO link to home in appbar

class RecipientHome extends StatefulWidget {
  const RecipientHome({super.key});

  @override
  State<RecipientHome> createState() => _RecipientHomeState();
}

class _RecipientHomeState extends State<RecipientHome> {
  int _selectedItem = 0;
  Map<String, dynamic>? recipientProfile;
  bool _isLoading = true;
  late final List<Widget> _screens;

  @override
void initState() {
  super.initState();
  _loadProfile();
}

void _loadScreens() {
  _screens = [
    RecipientProfileScreen(profile: recipientProfile!),
    RecipientHistoryScreen(profile: recipientProfile!),
    RecipientSettingsScreen(profile: recipientProfile!),
  ];
}



Future<void> _loadProfile() async {
  try {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final attrMap = {
      for (final attr in attributes) attr.userAttributeKey.key: attr.value,
    };

    final cognitoId = attrMap['sub'];
    print('cognitoId: $cognitoId');

    final response = await http.get(
      Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users/cognito/$cognitoId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        recipientProfile = data;
        _isLoading = false;
        _loadScreens();
      });
    } else {
      print("Profile not found: ${response.statusCode}");
    }
  } catch (e) {
    print("Failed to load profile: $e");
  }
}


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
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _screens[_selectedItem],
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



// TODO stopping here for tonight --> almost have dynamic user profile build out
// TODO 500 error when requesting user by cognitoid in get request